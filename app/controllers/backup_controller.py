# controllers/backup_controller.py
from flask import Blueprint, jsonify
from app.db import db
from app.responses import Responses
from sqlalchemy import inspect, text
from flask_jwt_extended import jwt_required, get_jwt
from datetime import datetime

backup_bp = Blueprint('backup', __name__, url_prefix='/api/backup')

def _get_all_tables_with_org():
    """Obtiene todas las tablas que tienen columna org_id"""
    inspector = inspect(db.engine)
    tables_with_org = []
    
    for table_name in inspector.get_table_names():
        columns = [col['name'] for col in inspector.get_columns(table_name)]
        if 'org_id' in columns:
            tables_with_org.append(table_name)
    
    return tables_with_org

def _get_all_tables_without_org():
    """Obtiene todas las tablas que NO tienen columna org_id (datos compartidos)"""
    inspector = inspect(db.engine)
    all_tables = inspector.get_table_names()
    tables_with_org = _get_all_tables_with_org()
    
    # Excluir tablas del sistema
    system_tables = ['alembic_version', 'spatial_ref_sys']
    
    return [t for t in all_tables if t not in tables_with_org and t not in system_tables]

@backup_bp.route('', methods=['GET'])
@jwt_required()
def export_backup():
    """
    Genera backup JSON COMPLETO de TODAS las tablas de la base de datos
    - Tablas con org_id: filtradas por organización
    - Tablas sin org_id: datos completos (unidades, roles, recursos, etc.)
    Solo Admin debería acceder (TODO: agregar decorator de rol)
    """
    try:
        jwt_data = get_jwt()
        org_id = jwt_data.get('org_id')
        
        if not org_id:
            return Responses.error('Token sin org_id', 401)
        
        backup_data = {
            'org_id': org_id,
            'backup_timestamp': datetime.utcnow().isoformat(),
            'backup_version': '2.0',  # Backup completo
            'data': {}
        }
        
        # 1. Tablas con org_id (filtradas por organización)
        tables_with_org = _get_all_tables_with_org()
        for table_name in tables_with_org:
            try:
                query = text(f"SELECT * FROM {table_name} WHERE org_id = :org_id")
                result = db.session.execute(query, {'org_id': org_id})
                rows = [dict(row._mapping) for row in result]
                
                # Convertir tipos no serializables
                for row in rows:
                    for key, value in row.items():
                        if isinstance(value, datetime):
                            row[key] = value.isoformat()
                        elif isinstance(value, (bytes, bytearray)):
                            row[key] = value.hex()
                
                backup_data['data'][table_name] = {
                    'count': len(rows),
                    'rows': rows,
                    'has_org_filter': True
                }
            except Exception as e:
                backup_data['data'][table_name] = {
                    'error': str(e),
                    'has_org_filter': True
                }
        
        # 2. Tablas sin org_id (datos compartidos: unidades, roles, recursos, planes, etc.)
        tables_without_org = _get_all_tables_without_org()
        for table_name in tables_without_org:
            try:
                query = text(f"SELECT * FROM {table_name}")
                result = db.session.execute(query)
                rows = [dict(row._mapping) for row in result]
                
                # Convertir tipos no serializables
                for row in rows:
                    for key, value in row.items():
                        if isinstance(value, datetime):
                            row[key] = value.isoformat()
                        elif isinstance(value, (bytes, bytearray)):
                            row[key] = value.hex()
                
                backup_data['data'][table_name] = {
                    'count': len(rows),
                    'rows': rows,
                    'has_org_filter': False
                }
            except Exception as e:
                backup_data['data'][table_name] = {
                    'error': str(e),
                    'has_org_filter': False
                }
        
        # Estadísticas del backup
        backup_data['statistics'] = {
            'tables_with_org': len(tables_with_org),
            'tables_without_org': len(tables_without_org),
            'total_tables': len(tables_with_org) + len(tables_without_org),
            'total_rows': sum(
                item.get('count', 0) 
                for item in backup_data['data'].values() 
                if 'count' in item
            )
        }
        
        return Responses.success(backup_data, 'Backup completo generado exitosamente')
        
    except Exception as ex:
        return Responses.error(f'Error al generar backup: {ex}', 500)
