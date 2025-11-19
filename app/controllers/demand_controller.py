# controllers/demand_controller.py
from flask import Blueprint, request, jsonify
from datetime import date, datetime
from app.services.demand_service import DemandService
from app.responses import Responses
from auth.decorators import auth_required
import csv
import io

demand_bp = Blueprint('demand', __name__, url_prefix='/api/demand')
demand_service = DemandService()

@demand_bp.route('', methods=['GET'])
@auth_required
def list_demands(org_id, user_id):
    """
    GET /api/demand
    Listar demandas con filtros opcionales
    
    Query params:
    - product_id: int (filtrar por producto)
    - period_start: date (YYYY-MM-DD)
    - period_end: date (YYYY-MM-DD)
    - source: str (manual|import|forecast)
    - status: str (draft|confirmed|cancelled)
    """
    try:
        # Obtener filtros
        product_id = request.args.get('product_id', type=int)
        period_start = request.args.get('period_start')
        period_end = request.args.get('period_end')
        source = request.args.get('source')
        status = request.args.get('status')
        
        # Convertir fechas
        if period_start:
            period_start = date.fromisoformat(period_start)
        if period_end:
            period_end = date.fromisoformat(period_end)
        
        demands = demand_service.list(
            org_id=org_id,
            product_id=product_id,
            period_start=period_start,
            period_end=period_end,
            source=source,
            status=status
        )
        
        return Responses.success(data=demands, message=f'{len(demands)} demandas encontradas'
        )
    
    except Exception as e:
        return Responses.error(str(e), 500)


@demand_bp.route('/<int:demand_id>', methods=['GET'])
@auth_required
def get_demand(org_id, user_id, demand_id):
    """GET /api/demand/:id - Obtener demanda por ID"""
    try:
        demand = demand_service.get(demand_id, org_id)
        
        if not demand:
            return Responses.error('Demanda no encontrada', 404)
        
        return Responses.success(data=demand)
    
    except Exception as e:
        return Responses.error(str(e), 500)


@demand_bp.route('', methods=['POST'])
@auth_required
def create_demand(org_id, user_id):
    """
    POST /api/demand
    Crear nueva demanda
    
    Body:
    {
        "product_id": 123,
        "period": "2025-02-01",
        "quantity": 100.5,
        "source": "manual",  // opcional: manual|import|forecast (default: manual)
        "status": "draft",   // opcional: draft|confirmed|cancelled (default: draft)
        "notes": "Demanda estimada"  // opcional
    }
    """
    try:
        data = request.get_json()
        
        # Validar campos requeridos
        required_fields = ['product_id', 'period', 'quantity']
        for field in required_fields:
            if field not in data:
                return Responses.error(f'Campo requerido: {field}', 400)
        
        # Convertir fecha
        period = date.fromisoformat(data['period'])
        
        demand = demand_service.create(
            org_id=org_id,
            product_id=data['product_id'],
            period=period,
            quantity=float(data['quantity']),
            source=data.get('source', 'manual'),
            status=data.get('status', 'draft'),
            notes=data.get('notes'),
            created_by=user_id
        )
        
        return Responses.success(data=demand, message='Demanda creada exitosamente', http_code=201)
    
    except ValueError as e:
        return Responses.error(str(e), 400)
    except Exception as e:
        return Responses.error(str(e), 500)


@demand_bp.route('/<int:demand_id>', methods=['PUT'])
@auth_required
def update_demand(org_id, user_id, demand_id):
    """
    PUT /api/demand/:id
    Actualizar demanda
    
    Body (todos opcionales):
    {
        "quantity": 150.0,
        "period": "2025-02-15",
        "source": "import",
        "status": "confirmed",
        "notes": "Actualización de demanda"
    }
    """
    try:
        data = request.get_json()
        
        # Convertir fecha si se provee
        if 'period' in data and data['period']:
            data['period'] = date.fromisoformat(data['period'])
        
        demand = demand_service.update(demand_id, org_id, **data)
        
        if not demand:
            return Responses.error('Demanda no encontrada', 404)
        
        return Responses.success(data=demand, message='Demanda actualizada exitosamente')
    
    except ValueError as e:
        return Responses.error(str(e), 400)
    except Exception as e:
        return Responses.error(str(e), 500)


@demand_bp.route('/<int:demand_id>', methods=['DELETE'])
@auth_required
def delete_demand(org_id, user_id, demand_id):
    """DELETE /api/demand/:id - Eliminar demanda"""
    try:
        deleted = demand_service.delete(demand_id, org_id)
        
        if not deleted:
            return Responses.error('Demanda no encontrada', 404)
        
        return Responses.success(message='Demanda eliminada exitosamente')
    
    except Exception as e:
        return Responses.error(str(e), 500)


@demand_bp.route('/<int:demand_id>/confirm', methods=['PUT'])
@auth_required
def confirm_demand(org_id, user_id, demand_id):
    """
    PUT /api/demand/:id/confirm
    Confirmar demanda (cambiar status de draft a confirmed)
    
    Una demanda confirmada puede alimentar el flujo MPS → MRP
    """
    try:
        demand = demand_service.confirm(demand_id, org_id)
        
        if not demand:
            return Responses.error('Demanda no encontrada o ya confirmada', 404)
        
        return Responses.success(
            data=demand,
            message='Demanda confirmada exitosamente'
        )
    
    except Exception as e:
        return Responses.error(str(e), 500)


@demand_bp.route('/summary', methods=['GET'])
@auth_required
def get_summary(org_id, user_id):
    """
    GET /api/demand/summary
    Obtener resumen de demandas por estado y período
    
    Query params:
    - period_start: date (YYYY-MM-DD) - opcional
    - period_end: date (YYYY-MM-DD) - opcional
    
    Response:
    {
        "total": 150,
        "by_status": {
            "draft": 50,
            "confirmed": 90,
            "cancelled": 10
        },
        "by_source": {
            "manual": 80,
            "import": 40,
            "forecast": 30
        },
        "by_period": [
            {"period": "2025-01-01", "count": 25, "total_quantity": 1500.5},
            {"period": "2025-02-01", "count": 30, "total_quantity": 2000.0}
        ],
        "total_quantity": 15000.0
    }
    """
    try:
        period_start = request.args.get('period_start')
        period_end = request.args.get('period_end')
        
        if period_start:
            period_start = date.fromisoformat(period_start)
        if period_end:
            period_end = date.fromisoformat(period_end)
        
        summary = demand_service.get_summary(
            org_id=org_id,
            period_start=period_start,
            period_end=period_end
        )
        
        return Responses.success(data=summary)
    
    except Exception as e:
        return Responses.error(str(e), 500)


@demand_bp.route('/import', methods=['POST'])
@auth_required
def import_demands(org_id, user_id):
    """
    POST /api/demand/import
    Importar demandas desde CSV
    
    CSV format:
    product_code,period,quantity,notes
    PROD-001,2025-02-01,100,Demanda Q1
    PROD-002,2025-02-01,50,
    
    Headers esperados:
    - product_code: código del producto (se busca en la BD)
    - period: fecha YYYY-MM-DD
    - quantity: cantidad numérica
    - notes: opcional
    """
    try:
        # Verificar que se envió un archivo
        if 'file' not in request.files:
            return Responses.error('No se envió archivo CSV', 400)
        
        file = request.files['file']
        
        if file.filename == '':
            return Responses.error('Nombre de archivo vacío', 400)
        
        if not file.filename.endswith('.csv'):
            return Responses.error('El archivo debe ser CSV', 400)
        
        # Leer CSV
        stream = io.StringIO(file.stream.read().decode("UTF8"), newline=None)
        csv_reader = csv.DictReader(stream)
        
        demands_data = []
        errors = []
        
        from app.models.product import Product
        
        for i, row in enumerate(csv_reader, start=2):  # start=2 porque línea 1 son headers
            try:
                # Buscar producto por código
                product = Product.query.filter_by(
                    code=row['product_code'].strip(),
                    org_id=org_id,
                    status=True
                ).first()
                
                if not product:
                    errors.append(f"Línea {i}: Producto '{row['product_code']}' no encontrado")
                    continue
                
                # Validar cantidad
                quantity = float(row['quantity'])
                if quantity <= 0:
                    errors.append(f"Línea {i}: Cantidad debe ser mayor a 0")
                    continue
                
                # Validar fecha
                period = date.fromisoformat(row['period'].strip())
                
                demands_data.append({
                    'product_id': product.id,
                    'period': period,
                    'quantity': quantity,
                    'source': 'import',
                    'status': 'draft',
                    'notes': row.get('notes', '').strip() or None
                })
            
            except KeyError as e:
                errors.append(f"Línea {i}: Columna faltante - {str(e)}")
            except ValueError as e:
                errors.append(f"Línea {i}: Error de formato - {str(e)}")
            except Exception as e:
                errors.append(f"Línea {i}: {str(e)}")
        
        # Crear demandas
        if demands_data:
            created = demand_service.bulk_create(org_id, demands_data, created_by=user_id)
        else:
            created = []
        
        return Responses.success(data={
                'created_count': len(created),
                'created': created,
                'errors_count': len(errors),
                'errors': errors
            }, message=f'{len(created)} demandas importadas' + 
                   (f', {len(errors)} errores' if errors else '')
        )
    
    except Exception as e:
        return Responses.error(f'Error al importar CSV: {str(e)}', 500)
