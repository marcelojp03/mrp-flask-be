# controllers/mrp_controller.py
from flask import Blueprint, request, jsonify
from datetime import date, datetime
from app.services.mrp_service import MRPService
from app.responses import Responses
from auth.decorators import auth_required

mrp_bp = Blueprint('mrp', __name__, url_prefix='/api/mrp')
mrp_service = MRPService()

@mrp_bp.route('/run', methods=['POST'])
@auth_required
def run_mrp(org_id, user_id):
    """
    POST /api/mrp/run
    Ejecutar MRP (Material Requirements Planning)
    
    Flujo:
    1. Lee planes MPS publicados en el rango de fechas
    2. Explota BOMs para calcular necesidades de componentes
    3. Resta stock disponible para obtener necesidad neta
    4. Genera propuestas BUY (si tiene proveedor) o MAKE (si tiene BOM)
    5. Calcula fechas de vencimiento considerando lead times
    
    Body:
    {
        "period_start": "2025-02-01",
        "period_end": "2025-02-28"
    }
    
    Response:
    {
        "message": "X propuestas MRP generadas",
        "proposals_created": X,
        "proposals": [
            {
                "id": 1,
                "product_id": 123,
                "type": "BUY",
                "quantity": 150.0,
                "due_date": "2025-01-25",
                "status": "proposed",
                "supplier_id": 5,
                "estimated_cost": 1500.00,
                ...
            },
            ...
        ]
    }
    """
    try:
        data = request.get_json()
        
        # Validar campos requeridos
        if 'period_start' not in data or 'period_end' not in data:
            return Responses.error('Campos requeridos: period_start, period_end', 400)
        
        period_start = date.fromisoformat(data['period_start'])
        period_end = date.fromisoformat(data['period_end'])
        
        result = mrp_service.run(
            org_id=org_id,
            period_start=period_start,
            period_end=period_end,
            created_by=user_id
        )
        
        return Responses.success(data=result, message=result['message'], http_code=201)
    
    except ValueError as e:
        return Responses.error(str(e), 400)
    except Exception as e:
        return Responses.error(str(e), 500)


@mrp_bp.route('/proposals', methods=['GET'])
@auth_required
def list_proposals(org_id, user_id):
    """
    GET /api/mrp/proposals
    Listar propuestas MRP con filtros
    
    Query params:
    - product_id: int
    - type: str (BUY|MAKE)
    - status: str (proposed|approved|rejected|executed)
    - due_date_start: date (YYYY-MM-DD)
    - due_date_end: date (YYYY-MM-DD)
    """
    try:
        product_id = request.args.get('product_id', type=int)
        type = request.args.get('type')
        status = request.args.get('status')
        due_date_start = request.args.get('due_date_start')
        due_date_end = request.args.get('due_date_end')
        
        # Convertir fechas
        if due_date_start:
            due_date_start = date.fromisoformat(due_date_start)
        if due_date_end:
            due_date_end = date.fromisoformat(due_date_end)
        
        proposals = mrp_service.list_proposals(
            org_id=org_id,
            product_id=product_id,
            type=type,
            status=status,
            due_date_start=due_date_start,
            due_date_end=due_date_end
        )
        
        return Responses.success(data=proposals, message=f'{len(proposals)} propuestas encontradas'
        )
    
    except Exception as e:
        return Responses.error(str(e), 500)


@mrp_bp.route('/proposals/<int:proposal_id>', methods=['GET'])
@auth_required
def get_proposal(org_id, user_id, proposal_id):
    """GET /api/mrp/proposals/:id - Obtener propuesta por ID"""
    try:
        proposal = mrp_service.get_proposal(proposal_id, org_id)
        
        if not proposal:
            return Responses.error('Propuesta no encontrada', 404)
        
        return Responses.success(data=proposal)
    
    except Exception as e:
        return Responses.error(str(e), 500)


@mrp_bp.route('/proposals/<int:proposal_id>/approve', methods=['PUT'])
@auth_required
def approve_proposal(org_id, user_id, proposal_id):
    """
    PUT /api/mrp/proposals/:id/approve
    Aprobar propuesta MRP
    
    Cambia status de 'proposed' a 'approved'
    Registra quién y cuándo aprobó
    """
    try:
        proposal = mrp_service.approve_proposal(
            proposal_id=proposal_id,
            org_id=org_id,
            approved_by=user_id
        )
        
        if not proposal:
            return Responses.error('Propuesta no encontrada', 404)
        
        return Responses.success(data=proposal, message='Propuesta aprobada exitosamente')
    
    except ValueError as e:
        return Responses.error(str(e), 400)
    except Exception as e:
        return Responses.error(str(e), 500)


@mrp_bp.route('/proposals/<int:proposal_id>/reject', methods=['PUT'])
@auth_required
def reject_proposal(org_id, user_id, proposal_id):
    """
    PUT /api/mrp/proposals/:id/reject
    Rechazar propuesta MRP
    
    Body (opcional):
    {
        "reason": "Stock suficiente disponible"
    }
    """
    try:
        data = request.get_json() or {}
        reason = data.get('reason')
        
        proposal = mrp_service.reject_proposal(
            proposal_id=proposal_id,
            org_id=org_id,
            reason=reason
        )
        
        if not proposal:
            return Responses.error('Propuesta no encontrada', 404)
        
        return Responses.success(data=proposal, message='Propuesta rechazada')
    
    except ValueError as e:
        return Responses.error(str(e), 400)
    except Exception as e:
        return Responses.error(str(e), 500)


@mrp_bp.route('/proposals/<int:proposal_id>/execute', methods=['PUT'])
@auth_required
def execute_proposal(org_id, user_id, proposal_id):
    """
    PUT /api/mrp/proposals/:id/execute
    Marcar propuesta como ejecutada
    
    Body:
    {
        "reference_type": "WO",  // WO (Work Order) o PO (Purchase Order)
        "reference_id": 123       // ID de la orden creada
    }
    
    Esto vincula la propuesta con la orden real que se creó
    """
    try:
        data = request.get_json()
        
        if 'reference_type' not in data or 'reference_id' not in data:
            return Responses.error('Campos requeridos: reference_type, reference_id', 400)
        
        if data['reference_type'] not in ['WO', 'PO']:
            return Responses.error('reference_type debe ser WO (Work Order) o PO (Purchase Order)', 400)
        
        proposal = mrp_service.execute_proposal(
            proposal_id=proposal_id,
            org_id=org_id,
            reference_type=data['reference_type'],
            reference_id=data['reference_id']
        )
        
        if not proposal:
            return Responses.error('Propuesta no encontrada', 404)
        
        return Responses.success(data=proposal, message=f'Propuesta marcada como ejecutada (vinculada a {data["reference_type"]} #{data["reference_id"]})'
        )
    
    except ValueError as e:
        return Responses.error(str(e), 400)
    except Exception as e:
        return Responses.error(str(e), 500)


@mrp_bp.route('/proposals/bulk-approve', methods=['POST'])
@auth_required
def bulk_approve_proposals(org_id, user_id):
    """
    POST /api/mrp/proposals/bulk-approve
    Aprobar múltiples propuestas a la vez
    
    Body:
    {
        "proposal_ids": [1, 2, 3, 4, 5]
    }
    """
    try:
        data = request.get_json()
        
        if 'proposal_ids' not in data or not isinstance(data['proposal_ids'], list):
            return Responses.error('Campo requerido: proposal_ids (array)', 400)
        
        approved = []
        errors = []
        
        for proposal_id in data['proposal_ids']:
            try:
                proposal = mrp_service.approve_proposal(
                    proposal_id=proposal_id,
                    org_id=org_id,
                    approved_by=user_id
                )
                if proposal:
                    approved.append(proposal)
                else:
                    errors.append(f'Propuesta {proposal_id} no encontrada')
            except Exception as e:
                errors.append(f'Propuesta {proposal_id}: {str(e)}')
        
        return Responses.success(data={
                'approved_count': len(approved),
                'approved': approved,
                'errors_count': len(errors),
                'errors': errors
            }, message=f'{len(approved)} propuestas aprobadas' + 
                   (f', {len(errors)} errores' if errors else '')
        )
    
    except Exception as e:
        return Responses.error(str(e), 500)
