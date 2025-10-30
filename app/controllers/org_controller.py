from flask import Blueprint, request
from app.responses import Responses
from app.services.organization_service import OrganizationService

org_bp = Blueprint('orgs', __name__, url_prefix='/api/orgs')
svc = OrganizationService()

@org_bp.route('', methods=['GET'])
def list_orgs():
    return Responses.success(svc.list())

@org_bp.route('/<int:org_id>', methods=['GET'])
def get_org(org_id):
    o = svc.get(org_id)
    return Responses.success(o) if o else Responses.error("Organización no encontrada", 404)

@org_bp.route('', methods=['POST'])
def create_org():
    data = request.get_json() or {}
    try:
        o = svc.create(data)
        return Responses.success(o, "Organización creada", 201)
    except ValueError as ve:
        return Responses.error(str(ve), 422)
