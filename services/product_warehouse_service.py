from typing import Optional, List
from decimal import Decimal
from app.db import db
from models.product_warehouse import ProductWarehouse
from models.product import Product
from models.warehouse import Warehouse

class ProductWarehouseService:
    def list(self, product_id: int = None, warehouse_id: int = None) -> List[dict]:
        q = ProductWarehouse.query
        if product_id is not None:
            q = q.filter_by(product_id=product_id)
        if warehouse_id is not None:
            q = q.filter_by(warehouse_id=warehouse_id)
        return [r.serialize() for r in q.all()]

    def get(self, product_id: int, warehouse_id: int) -> Optional[dict]:
        row = ProductWarehouse.query.filter_by(product_id=product_id, warehouse_id=warehouse_id).first()
        return row.serialize() if row else None

    def create(self, data: dict) -> dict:
        product_id = data.get('product_id')
        warehouse_id = data.get('warehouse_id')
        current_stock = Decimal(str(data.get('current_stock', 0)))

        if not product_id or not warehouse_id:
            raise ValueError("product_id y warehouse_id son obligatorios")

        # Validaciones básicas
        if not Product.query.get(product_id):
            raise ValueError("Producto inválido")
        if not Warehouse.query.get(warehouse_id):
            raise ValueError("Almacén inválido")

        exists = ProductWarehouse.query.filter_by(product_id=product_id, warehouse_id=warehouse_id).first()
        if exists:
            raise ValueError("La relación producto–almacén ya existe")

        row = ProductWarehouse(product_id=product_id, warehouse_id=warehouse_id, current_stock=current_stock)
        db.session.add(row)
        db.session.commit()
        return row.serialize()

    def update(self, data: dict) -> dict:
        product_id = data.get('product_id')
        warehouse_id = data.get('warehouse_id')
        new_stock = data.get('current_stock')

        if product_id is None or warehouse_id is None or new_stock is None:
            raise ValueError("product_id, warehouse_id y current_stock son obligatorios")

        row = ProductWarehouse.query.filter_by(product_id=product_id, warehouse_id=warehouse_id).first()
        if not row:
            raise ValueError("No existe la relación producto–almacén")

        row.current_stock = Decimal(str(new_stock))
        db.session.commit()
        return row.serialize()

    def delete(self, data: dict) -> bool:
        product_id = data.get('product_id')
        warehouse_id = data.get('warehouse_id')
        if product_id is None or warehouse_id is None:
            raise ValueError("product_id y warehouse_id son obligatorios")

        row = ProductWarehouse.query.filter_by(product_id=product_id, warehouse_id=warehouse_id).first()
        if not row:
            return False
        db.session.delete(row)
        db.session.commit()
        return True
