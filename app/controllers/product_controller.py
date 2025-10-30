# controllers/product_controller.py
from flask import Blueprint, request
from app.responses import Responses
from app.services.product_service import ProductService
from flask_jwt_extended import jwt_required, get_jwt

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
@jwt_required()
def list_products():
    jwt_data = get_jwt()
    org_id = jwt_data.get('org_id')
    
    if not org_id:
        return Responses.error('Token sin org_id', 401)
    
    only_active = _parse_only_active(request.args.get('only_active'))
    return Responses.success(svc.list(org_id=org_id, only_active=only_active))

@product_bp.route('/<int:product_id>', methods=['GET'])
@jwt_required()
def get_product(product_id):
    jwt_data = get_jwt()
    org_id = jwt_data.get('org_id')
    
    if not org_id:
        return Responses.error('Token sin org_id', 401)
    
    p = svc.get(product_id, org_id=org_id)
    return Responses.success(p) if p else Responses.error("Producto no encontrado", 404)

@product_bp.route('', methods=['POST'])
@jwt_required()
def create_product():
    jwt_data = get_jwt()
    org_id = jwt_data.get('org_id')
    
    if not org_id:
        return Responses.error('Token sin org_id', 401)
    
    data = request.get_json() or {}
    
    # Validar límite de productos según plan (SaasGuard)
    from app.services.saas_guard_service import SaasGuardService
    try:
        saas_guard = SaasGuardService()
        saas_guard.assert_can_add_product(org_id)
    except ValueError as e:
        return Responses.error(str(e), 403)
    
    try:
        p = svc.create(
            org_id=org_id,  # Usar org_id del JWT, NO del body
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
@jwt_required()
def update_product(product_id):
    jwt_data = get_jwt()
    org_id = jwt_data.get('org_id')
    
    if not org_id:
        return Responses.error('Token sin org_id', 401)
    
    data = request.get_json() or {}
    try:
        p = svc.update(product_id, org_id=org_id, **data)
        if not p:
            return Responses.error("Producto no encontrado o no pertenece a tu organización", 404)
        return Responses.success(p, "Producto actualizado")
    except ValueError as ve:
        return Responses.error(str(ve), 422)

@product_bp.route('/<int:product_id>', methods=['DELETE'])
@jwt_required()
def delete_product(product_id):
    jwt_data = get_jwt()
    org_id = jwt_data.get('org_id')
    
    if not org_id:
        return Responses.error('Token sin org_id', 401)
    
    ok = svc.delete_soft(product_id, org_id=org_id)
    return Responses.success(message="Producto eliminado") if ok else Responses.error("Producto no encontrado", 404)

@product_bp.route('/<int:product_id>/reactivate', methods=['POST'])
@jwt_required()
def reactivate_product(product_id):
    jwt_data = get_jwt()
    org_id = jwt_data.get('org_id')
    
    if not org_id:
        return Responses.error('Token sin org_id', 401)
    
    p = svc.reactivate(product_id, org_id=org_id)
    return Responses.success(p, "Producto reactivado") if p else Responses.error("Producto no encontrado", 404)
