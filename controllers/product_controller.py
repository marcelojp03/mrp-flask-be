# controllers/product_controller.py
from flask import Blueprint, request
from app.responses import Responses
from services.product_service import ProductService

product_bp = Blueprint('products', __name__, url_prefix='/api/products')
svc = ProductService()

def _parse_only_active(val: str):
    # None -> sin filtro; 'true'->True; 'false'->False
    if val is None:
        return None
    v = val.strip().lower()
    if v in ('true', '1', 't', 'yes', 'y'):
        return True
    if v in ('false', '0', 'f', 'no', 'n'):
        return False
    return None

@product_bp.route('', methods=['GET'])
def list_products():
    org_id = request.args.get('org_id', type=int)
    only_active = _parse_only_active(request.args.get('only_active'))  # por defecto None => todos
    return Responses.success(svc.list(org_id=org_id, only_active=only_active))

@product_bp.route('/<int:product_id>', methods=['GET'])
def get_product(product_id):
    p = svc.get(product_id)  # trae aunque esté inactivo
    return Responses.success(p) if p else Responses.error("Producto no encontrado", 404)

@product_bp.route('', methods=['POST'])
def create_product():
    data = request.get_json() or {}
    try:
        p = svc.create(
            org_id=data.get('org_id', 1),
            code=data['code'],
            name=data['name'],
            description=data.get('description'),
            item_type=data.get('item_type', 'FG'),
            procurement_type=data.get('procurement_type', 'BUY'),
            min_stock=data.get('min_stock', 0),
            unit_id=data.get('unit_id'),
            status=data.get('status', True),
        )
        return Responses.success(p, "Producto creado", 201)
    except KeyError as ke:
        return Responses.error(f"Campo requerido faltante: {ke}", 422)
    except ValueError as ve:
        return Responses.error(str(ve), 422)

@product_bp.route('/<int:product_id>', methods=['PUT'])
def update_product(product_id):
    data = request.get_json() or {}
    try:
        p = svc.update(product_id, **data)
        if not p:
            return Responses.error("Producto no encontrado", 404)
        return Responses.success(p, "Producto actualizado")
    except ValueError as ve:
        return Responses.error(str(ve), 422)

@product_bp.route('/<int:product_id>', methods=['DELETE'])
def delete_product(product_id):
    ok = svc.delete_soft(product_id)
    return Responses.success(message="Producto eliminado") if ok else Responses.error("Producto no encontrado", 404)

@product_bp.route('/<int:product_id>/reactivate', methods=['POST'])
def reactivate_product(product_id):
    p = svc.reactivate(product_id)
    return Responses.success(p, "Producto reactivado") if p else Responses.error("Producto no encontrado", 404)
