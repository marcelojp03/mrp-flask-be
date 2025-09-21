from flask import Blueprint, request
from app.responses import Responses
from services.movement_service import MovementService

movement_bp = Blueprint('movements', __name__, url_prefix='/api/movements')
svc = MovementService()

@movement_bp.route('', methods=['POST'])
def create_movement():
    data = request.get_json() or {}
    try:
        m = svc.create(data)
        return Responses.success(m, "Movimiento registrado", 201)
    except ValueError as ve:
        return Responses.error(str(ve), 422)
    except Exception as ex:
        return Responses.from_exception(ex)

@movement_bp.route('', methods=['GET'])
def list_movements():
    filters = dict(
        product_id=request.args.get('product_id', type=int),
        from_warehouse_id=request.args.get('from_warehouse_id', type=int),
        to_warehouse_id=request.args.get('to_warehouse_id', type=int),
        movement_type=request.args.get('movement_type'),
        reason=request.args.get('reason')
    )
    items = svc.list(**filters)
    return Responses.success(items)
