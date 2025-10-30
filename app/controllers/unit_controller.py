from flask import Blueprint, request
from app.responses import Responses
from app.services.unit_service import UnitService

unit_bp = Blueprint('units', __name__, url_prefix='/api/units')
svc = UnitService()

@unit_bp.route('', methods=['GET'])
def list_units():
    return Responses.success(svc.list())

@unit_bp.route('/<int:unit_id>', methods=['GET'])
def get_unit(unit_id):
    u = svc.get(unit_id)
    return Responses.success(u) if u else Responses.error("Unidad no encontrada", 404)

@unit_bp.route('', methods=['POST'])
def create_unit():
    data = request.get_json() or {}
    try:
        u = svc.create(data)
        return Responses.success(u, "Unidad creada", 201)
    except ValueError as ve:
        return Responses.error(str(ve), 422)

@unit_bp.route('/<int:unit_id>', methods=['PUT'])
def update_unit(unit_id):
    data = request.get_json() or {}
    u = svc.update(unit_id, data)
    return Responses.success(u, "Unidad actualizada") if u else Responses.error("Unidad no encontrada", 404)

@unit_bp.route('/<int:unit_id>', methods=['DELETE'])
def delete_unit(unit_id):
    ok = svc.delete(unit_id)
    return Responses.success(message="Unidad eliminada") if ok else Responses.error("Unidad no encontrada", 404)
