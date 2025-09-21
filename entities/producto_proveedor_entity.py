# entities/producto_proveedor_entity.py
# DISABLED: Model producto_proveedor was removed, no equivalent in English models for S1
# from models.producto_proveedor import Producto_Proveedor
from myapp import db

class ProductSupplierEntity:
    """
    PLACEHOLDER: This entity is disabled for S1 as the underlying model was removed.
    The producto_proveedor model had broken FKs and was eliminated.
    For S2, consider creating a proper ProductSupplier model if needed.
    """
    def get_all(self):
        # Return empty list for now
        return []

    def get_by_ids(self, product_id, supplier_id):
        # Return None for now  
        return None
    
    def get_by_supplier_id(self, supplier_id):
        # Return empty list for now
        return []
    
    def create(self, product_id, supplier_id):
        # Return None for now
        return None

    def update(self, product_id, supplier_id):
        # Return None for now
        return None

    def delete(self, product_id, supplier_id):
        # Return None for now
        return None
