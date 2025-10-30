# controllers/report_controller.py
from flask import Blueprint, request, Response
from app.db import db
from models.product import Product
from models.movement import Movement
from models.warehouse import Warehouse
from flask_jwt_extended import jwt_required, get_jwt
import csv
import io
from datetime import datetime

report_bp = Blueprint('reports', __name__, url_prefix='/api/reports')

def _to_csv_value(v):
    """Convierte valores a formato CSV seguro"""
    if v is None:
        return ''
    if isinstance(v, datetime):
        return v.isoformat()
    if isinstance(v, bool):
        return 'Sí' if v else 'No'
    return str(v)

@report_bp.route('/products.csv', methods=['GET'])
@jwt_required()
def export_products_csv():
    """Exporta productos a CSV (filtrado por org_id del JWT)"""
    try:
        jwt_data = get_jwt()
        org_id = jwt_data.get('org_id')
        
        if not org_id:
            return "Error: token sin org_id", 401
        
        products = Product.query.filter_by(org_id=org_id, status=True).order_by(Product.name).all()
        
        output = io.StringIO()
        writer = csv.writer(output)
        
        # Headers
        writer.writerow([
            'ID', 'Código', 'Nombre', 'Descripción', 'Tipo Item', 
            'Tipo Abastecimiento', 'Stock Mínimo', 'Estado', 'Creado'
        ])
        
        # Rows
        for p in products:
            writer.writerow([
                p.id,
                p.code or '',
                p.name or '',
                p.description or '',
                p.item_type or '',
                p.procurement_type or '',
                p.min_stock or 0,
                'Activo' if p.status else 'Inactivo',
                _to_csv_value(p.created_at)
            ])
        
        output.seek(0)
        return Response(
            output.getvalue(),
            mimetype='text/csv',
            headers={'Content-Disposition': f'attachment; filename=productos_{datetime.utcnow().date()}.csv'}
        )
        
    except Exception as ex:
        return f"Error al exportar productos: {ex}", 500


@report_bp.route('/movements.csv', methods=['GET'])
@jwt_required()
def export_movements_csv():
    """
    Exporta movimientos a CSV (filtrado por org_id)
    Query params: ?from=YYYY-MM-DD&to=YYYY-MM-DD
    """
    try:
        jwt_data = get_jwt()
        org_id = jwt_data.get('org_id')
        
        if not org_id:
            return "Error: token sin org_id", 401
        
        # Filtros opcionales
        date_from = request.args.get('from')
        date_to = request.args.get('to')
        
        query = Movement.query.filter_by(org_id=org_id)
        
        if date_from:
            try:
                dt_from = datetime.strptime(date_from, '%Y-%m-%d')
                query = query.filter(Movement.created_at >= dt_from)
            except:
                pass
        
        if date_to:
            try:
                dt_to = datetime.strptime(date_to, '%Y-%m-%d')
                query = query.filter(Movement.created_at <= dt_to)
            except:
                pass
        
        movements = query.order_by(Movement.created_at.desc()).limit(5000).all()
        
        output = io.StringIO()
        writer = csv.writer(output)
        
        # Headers
        writer.writerow([
            'ID', 'Producto ID', 'Tipo Movimiento', 'Almacén Origen ID', 
            'Almacén Destino ID', 'Cantidad', 'Motivo', 'Tipo Referencia',
            'ID Referencia', 'Creado Por', 'Fecha'
        ])
        
        # Rows
        for m in movements:
            writer.writerow([
                m.id,
                m.product_id or '',
                m.movement_type or '',
                m.from_warehouse_id or '',
                m.to_warehouse_id or '',
                m.quantity or 0,
                m.reason or '',
                m.reference_type or '',
                m.reference_id or '',
                m.created_by or '',
                _to_csv_value(m.created_at)
            ])
        
        output.seek(0)
        return Response(
            output.getvalue(),
            mimetype='text/csv',
            headers={'Content-Disposition': f'attachment; filename=movimientos_{datetime.utcnow().date()}.csv'}
        )
        
    except Exception as ex:
        return f"Error al exportar movimientos: {ex}", 500
