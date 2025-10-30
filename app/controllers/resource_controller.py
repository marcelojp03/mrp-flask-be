#controllers/resource_controller.py
from flask import Blueprint, request
from app.responses import Responses
from app.services.resource_service import ResourceService

resource_bp = Blueprint('resources', __name__, url_prefix='/api/resources')
svc = ResourceService()

@resource_bp.route('', methods=['GET'])
def list_resources():
    return Responses.success(svc.list())

@resource_bp.route('/<int:resource_id>', methods=['GET'])
def get_resource(resource_id):
    r = svc.get(resource_id)
    return Responses.success(r) if r else Responses.error("Recurso no encontrado", 404)

@resource_bp.route('', methods=['POST'])
def create_resource():
    data = request.get_json() or {}
    try:
        r = svc.create(data)
        return Responses.success(r, "Recurso creado", 201)
    except ValueError as ve:
        return Responses.error(str(ve), 422)

@resource_bp.route('/<int:resource_id>', methods=['PUT'])
def update_resource(resource_id):
    data = request.get_json() or {}
    r = svc.update(resource_id, data)
    return Responses.success(r, "Recurso actualizado") if r else Responses.error("Recurso no encontrado", 404)

@resource_bp.route('/<int:resource_id>', methods=['DELETE'])
def delete_resource(resource_id):
    ok = svc.delete(resource_id)
    return Responses.success(message="Recurso eliminado") if ok else Responses.error("Recurso no encontrado", 404)
