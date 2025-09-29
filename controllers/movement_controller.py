# controllers/movement_controller.py
from flask import Blueprint, request
from app.responses import Responses
from services.movement_service import MovementService

movement_bp = Blueprint('movements', __name__, url_prefix='/api/movements')
svc = MovementService()

@movement_bp.route('', methods=['POST'])
def create_movement():
    data = request.get_json() or {}
    try:
        m = svc.create(
            org_id=data.get('org_id', 1),
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
def list_movements():
    filters = dict(
        product_id=request.args.get('product_id', type=int),
        from_warehouse_id=request.args.get('from_warehouse_id', type=int),
        to_warehouse_id=request.args.get('to_warehouse_id', type=int),
        movement_type=request.args.get('movement_type'),
        reason=request.args.get('reason'),
        # (opcional) org_id si quieres filtrar por organización:
        org_id=request.args.get('org_id', type=int),
    )
    items = svc.list(**filters)
    return Responses.success(items)

