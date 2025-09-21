from sqlalchemy import func

from myapp import db
from models.product import Product
from models.product_warehouse import ProductWarehouse


class StockEntity:
    def list(self, product_id=None, warehouse_id=None):
        query = ProductWarehouse.query
        if product_id:
            query = query.filter_by(product_id=product_id)
        if warehouse_id:
            query = query.filter_by(warehouse_id=warehouse_id)
        return [row.serialize() for row in query.all()]

    def low_stock(self, warehouse_id=None):
        quantity_sum = func.coalesce(func.sum(ProductWarehouse.current_stock), 0)
        query = db.session.query(
            Product.id.label('product_id'),
            Product.code,
            Product.name,
            Product.min_stock,
            quantity_sum.label('qty'),
        ).outerjoin(
            ProductWarehouse,
            ProductWarehouse.product_id == Product.id,
        )

        if warehouse_id:
            query = query.filter(ProductWarehouse.warehouse_id == warehouse_id)

        query = query.group_by(Product.id).having(quantity_sum <= Product.min_stock)
        results = []
        for row in query.all():
            data = dict(row._mapping)
            data['qty'] = float(data['qty'])
            data['min_stock'] = float(data['min_stock']) if data['min_stock'] is not None else None
            results.append(data)
        return results
