# entities/producto_almacen_entity.py
from models.product_warehouse import ProductWarehouse
from myapp import db


class ProductWarehouseEntity:
    def get_all(self):
        rows = ProductWarehouse.query.all()
        return [r.serialize() for r in rows]

    def get_by_product_id(self, product_id):
        rows = ProductWarehouse.query.filter_by(product_id=product_id).all()
        return [r.serialize() for r in rows]

    def get_by_ids(self, product_id, warehouse_id):
        row = ProductWarehouse.query.filter_by(product_id=product_id, warehouse_id=warehouse_id).first()
        return row.serialize() if row else None

    def get_stock(self, product_id):
        rows = ProductWarehouse.query.filter_by(product_id=product_id).all()
        stock = 0
        if not rows:
            return stock
        for r in rows:
            stock += r.current_stock or 0
        return stock

    def create(self, product_id, warehouse_id, current_stock):
        row = ProductWarehouse(product_id=product_id, warehouse_id=warehouse_id, current_stock=current_stock)
        db.session.add(row)
        db.session.commit()
        return row.serialize()

    def update(self, product_id, warehouse_id, new_stock):
        row = ProductWarehouse.query.filter_by(product_id=product_id, warehouse_id=warehouse_id).first()
        if row:
            row.current_stock = new_stock
            db.session.commit()
        return row.serialize() if row else None

    def delete(self, product_id, warehouse_id):
        row = ProductWarehouse.query.filter_by(product_id=product_id, warehouse_id=warehouse_id).first()
        if row:
            db.session.delete(row)
            db.session.commit()
        return row.serialize() if row else None

    def restore_stock(self, product_id, warehouse_id, qty):
        row = ProductWarehouse.query.filter_by(product_id=product_id, warehouse_id=warehouse_id).first()
        if row:
            row.current_stock = (row.current_stock or 0) + qty
            db.session.commit()
            return True
        return False