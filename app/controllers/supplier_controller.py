from flask import Blueprint, request
from flask_jwt_extended import jwt_required, get_jwt
from app.responses import Responses
from app.services.supplier_service import SupplierService

supplier_bp = Blueprint('suppliers', __name__, url_prefix='/api/suppliers')
svc = SupplierService()

@supplier_bp.route('', methods=['GET'])
@jwt_required()
def list_suppliers():
    jwt_data = get_jwt()
    org_id = jwt_data.get('org_id')
    if not org_id:
        return Responses.error('Token sin org_id', 401)
    return Responses.success(svc.list(org_id=org_id))

@supplier_bp.route('/<int:supplier_id>', methods=['GET'])
@jwt_required()
def get_supplier(supplier_id):
    jwt_data = get_jwt()
    org_id = jwt_data.get('org_id')
    if not org_id:
        return Responses.error('Token sin org_id', 401)
    s = svc.get(supplier_id, org_id=org_id)
    return Responses.success(s) if s else Responses.error("Proveedor no encontrado", 404)

@supplier_bp.route('', methods=['POST'])
@jwt_required()
def create_supplier():
    jwt_data = get_jwt()
    org_id = jwt_data.get('org_id')
    if not org_id:
        return Responses.error('Token sin org_id', 401)
    
    data = request.get_json() or {}
    try:
        s = svc.create(org_id=org_id, **data)
        return Responses.success(s, "Proveedor creado", 201)
    except ValueError as ve:
        return Responses.error(str(ve), 422)

@supplier_bp.route('/<int:supplier_id>', methods=['PUT'])
@jwt_required()
def update_supplier(supplier_id):
    jwt_data = get_jwt()
    org_id = jwt_data.get('org_id')
    if not org_id:
        return Responses.error('Token sin org_id', 401)
    
    data = request.get_json() or {}
    s = svc.update(supplier_id, org_id=org_id, **data)
    return Responses.success(s, "Proveedor actualizado") if s else Responses.error("Proveedor no encontrado", 404)

@supplier_bp.route('/<int:supplier_id>', methods=['DELETE'])
@jwt_required()
def delete_supplier(supplier_id):
    jwt_data = get_jwt()
    org_id = jwt_data.get('org_id')
    if not org_id:
        return Responses.error('Token sin org_id', 401)
    
    ok = svc.delete(supplier_id, org_id=org_id)
    return Responses.success(message="Proveedor eliminado") if ok else Responses.error("Proveedor no encontrado", 404)
