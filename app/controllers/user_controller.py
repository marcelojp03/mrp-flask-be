from flask import Blueprint, request, g
from app.responses import Responses
from app.services.user_service import UserService
from app.services.user_role_service import UserRoleService
from auth.decorators import auth_required

user_bp = Blueprint('users', __name__, url_prefix='/api/users')
user_service = UserService()
user_role_service = UserRoleService()

@user_bp.route('', methods=['GET'])
@auth_required
def list_users():
    # Filtrar usuarios por organización
    users = user_service.list_by_org(g.org_id)
    return Responses.success(users)

@user_bp.route('/<int:user_id>', methods=['GET'])
def get_user(user_id):
    res = user_service.get(user_id)
    if not res: 
        return Responses.error("Usuario no encontrado", http_code=404, code="NOT_FOUND")
    return Responses.success(res)

@user_bp.route('', methods=['POST'])
def create_user():
    data = request.get_json() or {}
    # Normalizar campos
    role_ids = data.get('role_ids')
    if role_ids is None:
        # aceptar también role_id o rol_id (único) y convertir a lista
        rid = data.get('role_id') or data.get('rol_id')
        role_ids = [rid] if rid else None

    # Validaciones mínimas
    missing = [k for k in ['name', 'email', 'password'] if not data.get(k)]
    if missing:
        return Responses.error(
            f"Faltan campos requeridos: {', '.join(missing)}",
            http_code=422, code="VALIDATION_ERROR"
        )
    try:
        user = user_service.create(
            name=data['name'],
            email=data['email'],
            password=data['password'],
            photo=data.get('photo'),
            role_ids=role_ids
        )
        return Responses.success(user, message="Usuario creado", http_code=201)
    except ValueError as ve:
        return Responses.error(str(ve), http_code=422, code="VALIDATION_ERROR")
    except Exception as ex:
        return Responses.from_exception(ex)

@user_bp.route('/<int:user_id>', methods=['PUT'])
def update_user(user_id):
    data = request.get_json() or {}

    # Normalizar role_ids igual que en create
    if 'role_ids' not in data:
        rid = data.get('role_id') or data.get('rol_id')
        if rid is not None:
            data['role_ids'] = [rid]

    try:
        updated = user_service.update(user_id, **data)  # <- desempaquetar kwargs
        if not updated:
            return Responses.error("Usuario no encontrado", http_code=404)
        return Responses.success(updated, message="Usuario actualizado")
    except ValueError as ve:
        return Responses.error(str(ve), http_code=422, code="VALIDATION_ERROR")
    except Exception as ex:
        return Responses.from_exception(ex)

@user_bp.route('/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    ok = user_service.delete_hard(user_id)  # <- nombre correcto del método
    if not ok:
        return Responses.error("Usuario no encontrado", http_code=404)
    return Responses.success(message="Usuario eliminado")

@user_bp.route('/<int:user_id>/password', methods=['PUT'])
@auth_required
def reset_user_password(user_id):
    """Endpoint para que el admin resetee la contraseña de cualquier usuario"""
    data = request.get_json() or {}
    
    new_password = data.get('password') or data.get('new_password')
    if not new_password:
        return Responses.error(
            "Se requiere el campo 'password' o 'new_password'",
            http_code=422,
            code="VALIDATION_ERROR"
        )
    
    try:
        updated = user_service.reset_password(user_id, new_password)
        if not updated:
            return Responses.error("Usuario no encontrado", http_code=404, code="NOT_FOUND")
        return Responses.success(message="Contraseña actualizada correctamente")
    except Exception as ex:
        return Responses.from_exception(ex)