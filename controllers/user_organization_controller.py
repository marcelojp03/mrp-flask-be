from flask import Blueprint, request, jsonify
from services.user_organization_service import UserOrganizationService
from app.responses import Responses

user_org_bp = Blueprint('user_org', __name__, url_prefix='/api/user-org')
svc = UserOrganizationService()

@user_org_bp.route('/<int:user_id>/memberships', methods=['GET'])
def list_memberships(user_id):
    return jsonify(Responses.success(svc.list_by_user(user_id)))

@user_org_bp.route('/<int:user_id>/memberships', methods=['POST'])
def add_membership(user_id):
    data = request.get_json() or {}
    org_id = data.get('org_id')
    make_default = bool(data.get('is_default', False))
    if not org_id:
        return jsonify(Responses.error('org_id es requerido', 400)), 400
    m = svc.add_membership(user_id, org_id, make_default)
    return jsonify(Responses.success(m, 'Membresía agregada'))

@user_org_bp.route('/<int:user_id>/default', methods=['POST'])
def set_default(user_id):
    data = request.get_json() or {}
    org_id = data.get('org_id')
    if not org_id:
        return jsonify(Responses.error('org_id es requerido', 400)), 400
    m = svc.set_default(user_id, org_id)
    if not m:
        return jsonify(Responses.error('Membresía no encontrada', 404)), 404
    return jsonify(Responses.success(m, 'Default actualizado'))

@user_org_bp.route('/<int:user_id>/memberships/<int:org_id>', methods=['DELETE'])
def remove_membership(user_id, org_id):
    ok = svc.remove_membership(user_id, org_id)
    if not ok:
        return jsonify(Responses.error('Membresía no encontrada', 404)), 404
    return jsonify(Responses.success(None, 'Membresía eliminada'))
