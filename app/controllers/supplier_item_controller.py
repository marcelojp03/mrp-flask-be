from flask import Blueprint, request
from app.responses import Responses
from app.services.supplier_item_service import SupplierItemService

supplier_item_bp = Blueprint('supplier_items', __name__, url_prefix='/api/supplier-items')
svc = SupplierItemService()

@supplier_item_bp.route('', methods=['GET'])
def list_supplier_items():
    product_id = request.args.get('product_id', type=int)
    supplier_id = request.args.get('supplier_id', type=int)
    return Responses.success(svc.list(product_id=product_id, supplier_id=supplier_id))

@supplier_item_bp.route('', methods=['POST'])
def create_supplier_item():
    data = request.get_json() or {}
    try:
        row = svc.create(data)
        return Responses.success(row, "Relación proveedor–ítem creada", 201)
    except ValueError as ve:
        return Responses.error(str(ve), 422)

@supplier_item_bp.route('/<int:row_id>', methods=['PUT'])
def update_supplier_item(row_id):
    data = request.get_json() or {}
    row = svc.update(row_id, data)
    return Responses.success(row, "Relación actualizada") if row else Responses.error("Relación no encontrada", 404)

@supplier_item_bp.route('/<int:row_id>', methods=['DELETE'])
def delete_supplier_item(row_id):
    ok = svc.delete(row_id)
    return Responses.success(message="Relación eliminada") if ok else Responses.error("Relación no encontrada", 404)
