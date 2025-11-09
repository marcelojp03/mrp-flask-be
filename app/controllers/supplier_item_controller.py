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
        row = svc.create(
            org_id=data.get('org_id', 1),
            product_id=data['product_id'],
            supplier_id=data['supplier_id'],
            price=data.get('price'),
            currency=data.get('currency'),
            lead_time_days=data.get('lead_time_days'),
            min_order_qty=data.get('min_order_qty'),
            pack_size=data.get('pack_size'),
            is_preferred=data.get('is_preferred', False),
            is_active=data.get('is_active', True)
        )
        return Responses.success(row, "Relación proveedor–ítem creada", 201)
    except KeyError as ke:
        return Responses.error(f"Campo requerido faltante: {ke}", 400)
    except ValueError as ve:
        return Responses.error(str(ve), 422)

@supplier_item_bp.route('/<int:row_id>', methods=['PUT'])
def update_supplier_item(row_id):
    data = request.get_json() or {}
    row = svc.update(row_id, **data)
    return Responses.success(row, "Relación actualizada") if row else Responses.error("Relación no encontrada", 404)

@supplier_item_bp.route('/<int:row_id>', methods=['DELETE'])
def delete_supplier_item(row_id):
    ok = svc.delete(row_id)
    return Responses.success(message="Relación eliminada") if ok else Responses.error("Relación no encontrada", 404)

@supplier_item_bp.route('/<int:row_id>/set-preferred', methods=['PUT'])
def set_preferred_supplier_item(row_id):
    """Marca este supplier_item como preferido (desmarca otros del mismo producto)"""
    row = svc.set_preferred(row_id)
    return Responses.success(row, "Proveedor marcado como preferido") if row else Responses.error("Relación no encontrada", 404)

@supplier_item_bp.route('/<int:row_id>/toggle-active', methods=['PUT'])
def toggle_active_supplier_item(row_id):
    """Activa/Desactiva el supplier_item"""
    row = svc.toggle_active(row_id)
    return Responses.success(row, "Estado actualizado") if row else Responses.error("Relación no encontrada", 404)
