# controllers/mps_controller.py
from flask import Blueprint, request, jsonify
from datetime import date, datetime
from app.services.mps_service import MPSService
from app.responses import Responses
from auth.decorators import auth_required

mps_bp = Blueprint('mps', __name__, url_prefix='/api/mps')
mps_service = MPSService()

@mps_bp.route('', methods=['GET'])
@auth_required
def list_mps_plans(org_id, user_id):
    """
    GET /api/mps
    Listar planes MPS con filtros
    
    Query params:
    - product_id: int
    - period_start: date (YYYY-MM-DD)
    - period_end: date (YYYY-MM-DD)
    - status: str (draft|published|cancelled)
    """
    try:
        product_id = request.args.get('product_id', type=int)
        period_start = request.args.get('period_start')
        period_end = request.args.get('period_end')
        status = request.args.get('status')
        
        # Convertir fechas
        if period_start:
            period_start = date.fromisoformat(period_start)
        if period_end:
            period_end = date.fromisoformat(period_end)
        
        plans = mps_service.list(
            org_id=org_id,
            product_id=product_id,
            period_start=period_start,
            period_end=period_end,
            status=status
        )
        
        return Responses.success(data=plans, message=f'{len(plans)} planes MPS encontrados'
        )
    
    except Exception as e:
        return Responses.error(str(e), 500)


@mps_bp.route('/<int:mps_plan_id>', methods=['GET'])
@auth_required
def get_mps_plan(org_id, user_id, mps_plan_id):
    """GET /api/mps/:id - Obtener plan MPS por ID"""
    try:
        plan = mps_service.get(mps_plan_id, org_id)
        
        if not plan:
            return Responses.error('Plan MPS no encontrado', 404)
        
        return Responses.success(data=plan)
    
    except Exception as e:
        return Responses.error(str(e), 500)


@mps_bp.route('/simulate', methods=['POST'])
@auth_required
def simulate_mps(org_id, user_id):
    """
    POST /api/mps/simulate
    Simular plan MPS basado en demanda confirmada
    
    Body:
    {
        "period_start": "2025-02-01",
        "period_end": "2025-02-28",
        "product_ids": [123, 456]  // opcional, si no se envía: todos los productos
    }
    
    Response:
    [
        {
            "product_id": 123,
            "product_code": "PROD-001",
            "product_name": "Producto A",
            "period": "2025-02-01",
            "planned_qty": 150.0,
            "demand_qty": 150.0,
            "demand_ids": [1, 2, 3]
        },
        ...
    ]
    """
    try:
        data = request.get_json()
        
        # Validar campos requeridos
        if 'period_start' not in data or 'period_end' not in data:
            return Responses.error('Campos requeridos: period_start, period_end', 400)
        
        period_start = date.fromisoformat(data['period_start'])
        period_end = date.fromisoformat(data['period_end'])
        product_ids = data.get('product_ids')
        
        proposals = mps_service.simulate(
            org_id=org_id,
            period_start=period_start,
            period_end=period_end,
            product_ids=product_ids
        )
        
        return Responses.success(data=proposals, message=f'{len(proposals)} propuestas MPS generadas'
        )
    
    except ValueError as e:
        return Responses.error(str(e), 400)
    except Exception as e:
        return Responses.error(str(e), 500)


@mps_bp.route('/publish', methods=['POST'])
@auth_required
def publish_mps(org_id, user_id):
    """
    POST /api/mps/publish
    Publicar plan MPS (guardar propuestas simuladas)
    
    Body:
    {
        "plans": [
            {
                "product_id": 123,
                "period": "2025-02-01",
                "planned_qty": 150.0,
                "demand_ids": [1, 2],  // opcional
                "notes": "Plan Q1 2025"  // opcional
            },
            ...
        ]
    }
    """
    try:
        data = request.get_json()
        
        if 'plans' not in data or not isinstance(data['plans'], list):
            return Responses.error('Campo requerido: plans (array)', 400)
        
        if not data['plans']:
            return Responses.error('El array de plans no puede estar vacío', 400)
        
        published = mps_service.publish(
            org_id=org_id,
            mps_data=data['plans'],
            created_by=user_id
        )
        
        return Responses.success(data=published, message=f'{len(published)} planes MPS publicados exitosamente', http_code=201)
    
    except Exception as e:
        return Responses.error(str(e), 500)


@mps_bp.route('', methods=['POST'])
@auth_required
def create_mps_plan(org_id, user_id):
    """
    POST /api/mps
    Crear plan MPS individual (alternativa a publish para crear uno solo)
    
    Body:
    {
        "product_id": 123,
        "period": "2025-02-01",
        "planned_qty": 100.0,
        "status": "draft",  // opcional: draft|published (default: draft)
        "demand_id": 5,  // opcional
        "notes": "Plan manual"  // opcional
    }
    """
    try:
        data = request.get_json()
        
        required_fields = ['product_id', 'period', 'planned_qty']
        for field in required_fields:
            if field not in data:
                return Responses.error(f'Campo requerido: {field}', 400)
        
        period = date.fromisoformat(data['period'])
        
        plan = mps_service.create(
            org_id=org_id,
            product_id=data['product_id'],
            period=period,
            planned_qty=float(data['planned_qty']),
            status=data.get('status', 'draft'),
            demand_id=data.get('demand_id'),
            notes=data.get('notes'),
            created_by=user_id
        )
        
        return Responses.success(data=plan, message='Plan MPS creado exitosamente', http_code=201)
    
    except ValueError as e:
        return Responses.error(str(e), 400)
    except Exception as e:
        return Responses.error(str(e), 500)


@mps_bp.route('/<int:mps_plan_id>', methods=['PUT'])
@auth_required
def update_mps_plan(org_id, user_id, mps_plan_id):
    """
    PUT /api/mps/:id
    Actualizar plan MPS
    
    Body (todos opcionales):
    {
        "planned_qty": 200.0,
        "period": "2025-02-15",
        "status": "published",
        "notes": "Actualización"
    }
    """
    try:
        data = request.get_json()
        
        if 'period' in data and data['period']:
            data['period'] = date.fromisoformat(data['period'])
        
        plan = mps_service.update(mps_plan_id, org_id, **data)
        
        if not plan:
            return Responses.error('Plan MPS no encontrado', 404)
        
        return Responses.success(data=plan, message='Plan MPS actualizado exitosamente')
    
    except ValueError as e:
        return Responses.error(str(e), 400)
    except Exception as e:
        return Responses.error(str(e), 500)


@mps_bp.route('/<int:mps_plan_id>/cancel', methods=['PUT'])
@auth_required
def cancel_mps_plan(org_id, user_id, mps_plan_id):
    """
    PUT /api/mps/:id/cancel
    Cancelar plan MPS (cambiar status a 'cancelled')
    """
    try:
        plan = mps_service.update(mps_plan_id, org_id, status='cancelled')
        
        if not plan:
            return Responses.error('Plan MPS no encontrado', 404)
        
        return Responses.success(data=plan, message='Plan MPS cancelado exitosamente')
    
    except ValueError as e:
        return Responses.error(str(e), 400)
    except Exception as e:
        return Responses.error(str(e), 500)


@mps_bp.route('/<int:mps_plan_id>', methods=['DELETE'])
@auth_required
def delete_mps_plan(org_id, user_id, mps_plan_id):
    """DELETE /api/mps/:id - Eliminar plan MPS (solo si no está publicado)"""
    try:
        deleted = mps_service.delete(mps_plan_id, org_id)
        
        if not deleted:
            return Responses.error('Plan MPS no encontrado', 404)
        
        return Responses.success(message='Plan MPS eliminado exitosamente')
    
    except ValueError as e:
        return Responses.error(str(e), 400)
    except Exception as e:
        return Responses.error(str(e), 500)
