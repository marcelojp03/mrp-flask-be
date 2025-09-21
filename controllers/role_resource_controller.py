from flask import Blueprint, request
from app.responses import Responses
from services.role_resource_service import RoleResourceService

role_resource_bp = Blueprint('role_resources', __name__, url_prefix='/api/role-resources')
svc = RoleResourceService()

@role_resource_bp.route('', methods=['GET'])
def list_all():
    role_id = request.args.get('role_id', type=int)
    return Responses.success(svc.list(role_id=role_id))

@role_resource_bp.route('', methods=['POST'])
def assign():
    data = request.get_json() or {}
    try:
        rr = svc.assign(role_id=data.get('role_id'), resource_id=data.get('resource_id'), subresource_id=data.get('subresource_id'))
        return Responses.success(rr, "Permiso asignado", 201)
    except ValueError as ve:
        return Responses.error(str(ve), 422)

@role_resource_bp.route('', methods=['DELETE'])
def unassign():
    data = request.get_json() or {}
    ok = svc.unassign(role_id=data.get('role_id'), resource_id=data.get('resource_id'), subresource_id=data.get('subresource_id'))
    return Responses.success(message="Permiso quitado") if ok else Responses.error("No existe permiso", 404)
