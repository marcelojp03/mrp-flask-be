from flask import Blueprint, request
from app.responses import Responses
from services.warehouse_service import WarehouseService

warehouse_bp = Blueprint('warehouses', __name__, url_prefix='/api/warehouses')
svc = WarehouseService()

@warehouse_bp.route('', methods=['GET'])
def list_warehouses():
    return Responses.success(svc.list())

@warehouse_bp.route('/<int:warehouse_id>', methods=['GET'])
def get_warehouse(warehouse_id):
    w = svc.get(warehouse_id)
    return Responses.success(w) if w else Responses.error("Almacén no encontrado", 404)

@warehouse_bp.route('', methods=['POST'])
def create_warehouse():
    data = request.get_json() or {}
    try:
        w = svc.create(data)
        return Responses.success(w, "Almacén creado", 201)
    except ValueError as ve:
        return Responses.error(str(ve), 422)

@warehouse_bp.route('/<int:warehouse_id>', methods=['PUT'])
def update_warehouse(warehouse_id):
    data = request.get_json() or {}
    w = svc.update(warehouse_id, data)
    return Responses.success(w, "Almacén actualizado") if w else Responses.error("Almacén no encontrado", 404)

@warehouse_bp.route('/<int:warehouse_id>', methods=['DELETE'])
def delete_warehouse(warehouse_id):
    ok = svc.delete(warehouse_id)
    return Responses.success(message="Almacén eliminado") if ok else Responses.error("Almacén no encontrado", 404)
