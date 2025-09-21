from flask import Blueprint, request
from app.responses import Responses
from services.user_service import UserService
from services.user_role_service import UserRoleService

user_bp = Blueprint('users', __name__, url_prefix='/api/users')
user_service = UserService()
user_role_service = UserRoleService()

@user_bp.route('', methods=['GET'])
def list_users():
    users = user_service.list()
    return Responses.success(users)

@user_bp.route('/<int:user_id>', methods=['GET'])
def get_user(user_id):
    res = user_service.get(user_id)
    if not res: return Responses.error("Usuario no encontrado", http_code=404, code="NOT_FOUND")
    return Responses.success(res)

@user_bp.route('', methods=['POST'])
def create_user():
    data = request.get_json() or {}
    try:
        user = user_service.create(data)
        role_id = data.get('role_id') or data.get('rol_id')
        if role_id:
            user_role_service.assign(role_id=role_id, user_id=user['id'])
        return Responses.success(user, message="Usuario creado", http_code=201)
    except ValueError as ve:
        return Responses.error(str(ve), http_code=422, code="VALIDATION_ERROR")
    except Exception as ex:
        return Responses.from_exception(ex)

@user_bp.route('/<int:user_id>', methods=['PUT'])
def update_user(user_id):
    data = request.get_json() or {}
    try:
        updated = user_service.update(user_id, data)
        if not updated: return Responses.error("Usuario no encontrado", http_code=404)
        role_id = data.get('role_id') or data.get('rol_id')
        if role_id is not None:
            user_role_service.upsert(role_id=role_id, user_id=user_id)
        return Responses.success(updated, message="Usuario actualizado")
    except ValueError as ve:
        return Responses.error(str(ve), http_code=422, code="VALIDATION_ERROR")
    except Exception as ex:
        return Responses.from_exception(ex)

@user_bp.route('/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    ok = user_service.delete_permanent(user_id)
    if not ok: return Responses.error("Usuario no encontrado", http_code=404)
    return Responses.success(message="Usuario eliminado")
