#controllers/role_controller.py
from flask import Blueprint, request, g
from app.responses import Responses
from auth.decorators import auth_required # CLAIM
from services.role_service import RoleService
from services.resource_service import ResourceService  # <-- nuevo

role_bp = Blueprint('roles', __name__, url_prefix='/api/roles')
role_service = RoleService()
resource_service = ResourceService()  # <-- nuevo

@role_bp.route('', methods=['GET'])
def list_roles():
    return Responses.success(role_service.list())

@role_bp.route('/<int:role_id>', methods=['GET'])
def get_role(role_id):
    r = role_service.get(role_id)
    return Responses.success(r) if r else Responses.error("Rol no encontrado", 404)

@role_bp.route('', methods=['POST'])
def create_role():
    data = request.get_json() or {}
    try:
        # RoleService.create(name, description=None, status=True)
        r = role_service.create(
            name=data.get('name'),
            description=data.get('description'),
            status=data.get('status', True)
        )
        return Responses.success(r, "Rol creado", 201)
    except ValueError as ve:
        return Responses.error(str(ve), 422, "VALIDATION_ERROR")

@role_bp.route('/<int:role_id>', methods=['PUT'])
def update_role(role_id):
    data = request.get_json() or {}
    r = role_service.update(
        role_id,
        name=data.get('name'),
        description=data.get('description'),
        status=data.get('status')
    )
    return Responses.success(r, "Rol actualizado") if r else Responses.error("Rol no encontrado", 404)

#@role_bp.route('/<int:user_id>/menu', methods=['GET'])  # opcional: ordena la ruta
@role_bp.route('/menu', methods=['GET'])
@auth_required
#def menu_for_user(user_id):
def my_menu():
    try:
        menu = resource_service.menu_for_user(g.user_id)  # <-- delega al ResourceService
        return Responses.success(menu)
    except Exception as ex:
        return Responses.from_exception(ex)
