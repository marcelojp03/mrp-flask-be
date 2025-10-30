# controllers/movement_controller.py
from flask import Blueprint, request
from flask_jwt_extended import jwt_required, get_jwt
from app.responses import Responses
from services.movement_service import MovementService
from services.saas_guard_service import SaasGuardService

movement_bp = Blueprint('movements', __name__, url_prefix='/api/movements')
svc = MovementService()

@movement_bp.route('', methods=['POST'])
@jwt_required()
def create_movement():
    jwt_data = get_jwt()
    org_id = jwt_data.get('org_id')
    if not org_id:
        return Responses.error('Token sin org_id', 401)
    
    # Validar límite de movimientos diarios del plan
    saas_guard = SaasGuardService()
    try:
        saas_guard.assert_can_register_movement_today(org_id)
    except ValueError as ve:
        return Responses.error(str(ve), 403)
    
    data = request.get_json() or {}
    try:
        m = svc.create(
            org_id=org_id,  # Usar org_id del JWT, no del body
            product_id=data['product_id'],
            movement_type=data['movement_type'],
            reason=data['reason'],
            quantity=data['quantity'],
            created_by=data.get('created_by'),
            from_warehouse_id=data.get('from_warehouse_id'),
            to_warehouse_id=data.get('to_warehouse_id'),
            reference_type=data.get('reference_type'),
            reference_id=data.get('reference_id'),
            note=data.get('note'),
        )
        return Responses.success(m, "Movimiento registrado", 201)
    except KeyError as ke:
        return Responses.error(f"Campo requerido faltante: {ke}", 422)
    except ValueError as ve:
        return Responses.error(str(ve), 422)
    except Exception as ex:
        return Responses.from_exception(ex)


@movement_bp.route('', methods=['GET'])
@jwt_required()
def list_movements():
    jwt_data = get_jwt()
    org_id = jwt_data.get('org_id')
    if not org_id:
        return Responses.error('Token sin org_id', 401)
    
    filters = dict(
        org_id=org_id,  # Filtrar siempre por org_id del JWT
        product_id=request.args.get('product_id', type=int),
        from_warehouse_id=request.args.get('from_warehouse_id', type=int),
        to_warehouse_id=request.args.get('to_warehouse_id', type=int),
        movement_type=request.args.get('movement_type'),
        reason=request.args.get('reason'),
    )
    items = svc.list(**filters)
    return Responses.success(items)
