# controllers/menu_controller.py
from flask import Blueprint, jsonify
from app.responses import Responses
from app.models.user_role import UserRole
from app.models.role_resource import RoleResource
from app.models.resource import Resource
from app.models.subresource import Subresource
from flask_jwt_extended import jwt_required, get_jwt

menu_bp = Blueprint('menu', __name__, url_prefix='/api/menu')

@menu_bp.route('', methods=['GET'])
@jwt_required()
def get_menu():
    """
    Construye el menú dinámico para el usuario basado en sus roles y permisos
    Retorna árbol de recursos y subrecursos permitidos
    """
    try:
        jwt_data = get_jwt()
        user_id = jwt_data.get('sub')
        
        if not user_id:
            return Responses.error('Token sin user_id', 401)
        
        # 1) Obtener roles del usuario
        user_roles = UserRole.query.filter_by(user_id=user_id).all()
        role_ids = [ur.role_id for ur in user_roles]
        
        if not role_ids:
            return Responses.success([], 'Usuario sin roles asignados')
        
        # 2) Obtener resources permitidos por esos roles
        role_resources = RoleResource.query.filter(RoleResource.role_id.in_(role_ids)).all()
        resource_ids = list(set([rr.resource_id for rr in role_resources]))
        
        if not resource_ids:
            return Responses.success([], 'Sin recursos asignados')
        
        # 3) Obtener recursos y sus subrecursos
        resources = Resource.query.filter(Resource.id.in_(resource_ids)).order_by(Resource.name).all()
        
        menu = []
        for res in resources:
            # Obtener subrecursos del resource
            subresources = Subresource.query.filter_by(resource_id=res.id).order_by(Subresource.name).all()
            
            menu_item = {
                'id': res.id,
                'name': res.name,
                'description': res.description,
                'subresources': [
                    {
                        'id': sub.id,
                        'name': sub.name,
                        'description': sub.description,
                        'url': sub.url,
                        'icon': sub.icon
                    }
                    for sub in subresources
                ]
            }
            menu.append(menu_item)
        
        return Responses.success(menu, 'Menú construido')
        
    except Exception as ex:
        return Responses.error(f'Error al construir menú: {ex}', 500)
