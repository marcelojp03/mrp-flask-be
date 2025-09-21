from flask import Blueprint, request
from app.responses import Responses
from services.user_role_service import UserRoleService

user_role_bp = Blueprint('user_roles', __name__, url_prefix='/api/user-roles')
svc = UserRoleService()

@user_role_bp.route('', methods=['GET'])
def list_user_roles():
    return Responses.success(svc.list())

@user_role_bp.route('/user/<int:user_id>', methods=['GET'])
def roles_by_user(user_id):
    return Responses.success(svc.by_user(user_id))

@user_role_bp.route('', methods=['POST'])
def assign_role():
    data = request.get_json() or {}
    try:
        res = svc.assign(role_id=data.get('role_id'), user_id=data.get('user_id'))
        return Responses.success(res, "Rol asignado", 201)
    except ValueError as ve:
        return Responses.error(str(ve), 422)

@user_role_bp.route('', methods=['PUT'])
def upsert_role():
    data = request.get_json() or {}
    res = svc.upsert(role_id=data.get('role_id'), user_id=data.get('user_id'))
    return Responses.success(res, "Rol actualizado")

@user_role_bp.route('', methods=['DELETE'])
def unassign_role():
    data = request.get_json() or {}
    ok = svc.unassign(role_id=data.get('role_id'), user_id=data.get('user_id'))
    return Responses.success(message="Rol quitado") if ok else Responses.error("No existe asignación", 404)
