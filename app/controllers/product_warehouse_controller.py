from flask import Blueprint, request
from app.responses import Responses
from app.services.product_warehouse_service import ProductWarehouseService

pw_bp = Blueprint('product_warehouses', __name__, url_prefix='/api/product-warehouses')
svc = ProductWarehouseService()

@pw_bp.route('', methods=['GET'])
def list_pw():
    product_id = request.args.get('product_id', type=int)
    warehouse_id = request.args.get('warehouse_id', type=int)
    return Responses.success(svc.list(product_id=product_id, warehouse_id=warehouse_id))

@pw_bp.route('', methods=['POST'])
def create_pw():
    data = request.get_json() or {}
    try:
        row = svc.create(data)
        return Responses.success(row, "Vinculación producto-almacén creada", 201)
    except ValueError as ve:
        return Responses.error(str(ve), 422)

@pw_bp.route('', methods=['PUT'])
def update_pw():
    data = request.get_json() or {}
    try:
        row = svc.update(data)
        return Responses.success(row, "Stock actualizado")
    except ValueError as ve:
        return Responses.error(str(ve), 422)

@pw_bp.route('', methods=['DELETE'])
def delete_pw():
    data = request.get_json() or {}
    ok = svc.delete(data)
    return Responses.success(message="Vinculación eliminada") if ok else Responses.error("No encontrada", 404)
