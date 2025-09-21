from flask import Blueprint, request
from app.responses import Responses
from services.supplier_service import SupplierService

supplier_bp = Blueprint('suppliers', __name__, url_prefix='/api/suppliers')
svc = SupplierService()

@supplier_bp.route('', methods=['GET'])
def list_suppliers():
    return Responses.success(svc.list())

@supplier_bp.route('/<int:supplier_id>', methods=['GET'])
def get_supplier(supplier_id):
    s = svc.get(supplier_id)
    return Responses.success(s) if s else Responses.error("Proveedor no encontrado", 404)

@supplier_bp.route('', methods=['POST'])
def create_supplier():
    data = request.get_json() or {}
    try:
        s = svc.create(data)
        return Responses.success(s, "Proveedor creado", 201)
    except ValueError as ve:
        return Responses.error(str(ve), 422)

@supplier_bp.route('/<int:supplier_id>', methods=['PUT'])
def update_supplier(supplier_id):
    data = request.get_json() or {}
    s = svc.update(supplier_id, data)
    return Responses.success(s, "Proveedor actualizado") if s else Responses.error("Proveedor no encontrado", 404)

@supplier_bp.route('/<int:supplier_id>', methods=['DELETE'])
def delete_supplier(supplier_id):
    ok = svc.delete(supplier_id)
    return Responses.success(message="Proveedor eliminado") if ok else Responses.error("Proveedor no encontrado", 404)
