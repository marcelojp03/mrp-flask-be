from flask import Blueprint, request
from app.responses import Responses
from services.product_service import ProductService

product_bp = Blueprint('products', __name__, url_prefix='/api/products')
svc = ProductService()

@product_bp.route('', methods=['GET'])
def list_products():
    use_s1 = request.args.get('s1', 'true').lower() != 'false'
    return Responses.success(svc.list(use_s1=use_s1))

@product_bp.route('/<int:product_id>', methods=['GET'])
def get_product(product_id):
    use_s1 = request.args.get('s1', 'true').lower() != 'false'
    p = svc.get(product_id, use_s1=use_s1)
    return Responses.success(p) if p else Responses.error("Producto no encontrado", 404)

@product_bp.route('', methods=['POST'])
def create_product():
    data = request.get_json() or {}
    try:
        p = svc.create(data)
        return Responses.success(p, "Producto creado", 201)
    except ValueError as ve:
        return Responses.error(str(ve), 422)

@product_bp.route('/<int:product_id>', methods=['PUT'])
def update_product(product_id):
    data = request.get_json() or {}
    try:
        p = svc.update(product_id, data)
        if not p: return Responses.error("Producto no encontrado", 404)
        return Responses.success(p, "Producto actualizado")
    except ValueError as ve:
        return Responses.error(str(ve), 422)

@product_bp.route('/<int:product_id>', methods=['DELETE'])
def delete_product(product_id):
    ok = svc.delete(product_id)
    return Responses.success(message="Producto eliminado") if ok else Responses.error("Producto no encontrado", 404)

@product_bp.route('/<int:product_id>/reactivate', methods=['POST'])
def reactivate_product(product_id):
    p = svc.reactivate(product_id)
    return Responses.success(p, "Producto reactivado") if p else Responses.error("Producto no encontrado", 404)
