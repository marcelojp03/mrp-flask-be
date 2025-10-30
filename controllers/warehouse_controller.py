from flask import Blueprint, request
from flask_jwt_extended import jwt_required, get_jwt
from app.responses import Responses
from services.warehouse_service import WarehouseService
from services.saas_guard_service import SaasGuardService

warehouse_bp = Blueprint('warehouses', __name__, url_prefix='/api/warehouses')
svc = WarehouseService()

@warehouse_bp.route('', methods=['GET'])
@jwt_required()
def list_warehouses():
    jwt_data = get_jwt()
    org_id = jwt_data.get('org_id')
    if not org_id:
        return Responses.error('Token sin org_id', 401)
    return Responses.success(svc.list(org_id=org_id))

@warehouse_bp.route('/<int:warehouse_id>', methods=['GET'])
@jwt_required()
def get_warehouse(warehouse_id):
    jwt_data = get_jwt()
    org_id = jwt_data.get('org_id')
    if not org_id:
        return Responses.error('Token sin org_id', 401)
    w = svc.get(warehouse_id, org_id=org_id)
    return Responses.success(w) if w else Responses.error("Almacén no encontrado", 404)

@warehouse_bp.route('', methods=['POST'])
@jwt_required()
def create_warehouse():
    jwt_data = get_jwt()
    org_id = jwt_data.get('org_id')
    if not org_id:
        return Responses.error('Token sin org_id', 401)
    
    # Validar límite de almacenes del plan
    saas_guard = SaasGuardService()
    try:
        saas_guard.assert_can_add_warehouse(org_id)
    except ValueError as ve:
        return Responses.error(str(ve), 403)
    
    data = request.get_json() or {}
    try:
        w = svc.create(org_id=org_id, **data)
        return Responses.success(w, "Almacén creado", 201)
    except ValueError as ve:
        return Responses.error(str(ve), 422)

@warehouse_bp.route('/<int:warehouse_id>', methods=['PUT'])
@jwt_required()
def update_warehouse(warehouse_id):
    jwt_data = get_jwt()
    org_id = jwt_data.get('org_id')
    if not org_id:
        return Responses.error('Token sin org_id', 401)
    data = request.get_json() or {}
    w = svc.update(warehouse_id, org_id=org_id, **data)
    return Responses.success(w, "Almacén actualizado") if w else Responses.error("Almacén no encontrado", 404)

@warehouse_bp.route('/<int:warehouse_id>', methods=['DELETE'])
@jwt_required()
def delete_warehouse(warehouse_id):
    jwt_data = get_jwt()
    org_id = jwt_data.get('org_id')
    if not org_id:
        return Responses.error('Token sin org_id', 401)
    ok = svc.delete(warehouse_id, org_id=org_id)
    return Responses.success(message="Almacén eliminado") if ok else Responses.error("Almacén no encontrado", 404)
