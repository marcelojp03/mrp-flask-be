from flask import Blueprint, request
from app.responses import Responses
from services.subresource_service import SubresourceService

subresource_bp = Blueprint('subresources', __name__, url_prefix='/api/subresources')
svc = SubresourceService()

@subresource_bp.route('', methods=['GET'])
def list_subresources():
    resource_id = request.args.get('resource_id', type=int)
    return Responses.success(svc.list(resource_id=resource_id))

@subresource_bp.route('/<int:subresource_id>', methods=['GET'])
def get_subresource(subresource_id):
    sr = svc.get(subresource_id)
    return Responses.success(sr) if sr else Responses.error("Subrecurso no encontrado", 404)

@subresource_bp.route('', methods=['POST'])
def create_subresource():
    data = request.get_json() or {}
    try:
        sr = svc.create(data)
        return Responses.success(sr, "Subrecurso creado", 201)
    except ValueError as ve:
        return Responses.error(str(ve), 422)

@subresource_bp.route('/<int:subresource_id>', methods=['PUT'])
def update_subresource(subresource_id):
    data = request.get_json() or {}
    sr = svc.update(subresource_id, data)
    return Responses.success(sr, "Subrecurso actualizado") if sr else Responses.error("Subrecurso no encontrado", 404)

@subresource_bp.route('/<int:subresource_id>', methods=['DELETE'])
def delete_subresource(subresource_id):
    ok = svc.delete(subresource_id)
    return Responses.success(message="Subrecurso eliminado") if ok else Responses.error("Subrecurso no encontrado", 404)
