#models/product_warehouse.py
from app.db import db


class ProductWarehouse(db.Model):
    __tablename__ = 'product_warehouse'
    __table_args__ = (
        db.UniqueConstraint('productid', 'warehouseid', name='uq_product_warehouse'),
        # Indexes for faster queries
        db.Index('ix_product_warehouse_product', 'productid'),
        db.Index('ix_product_warehouse_warehouse', 'warehouseid'),
    )
    id = db.Column(db.Integer, primary_key=True, autoincrement=True, nullable=False)
    product_id = db.Column('productid', db.Integer, db.ForeignKey('product.id'), nullable=False)
    warehouse_id = db.Column('warehouseid', db.Integer, db.ForeignKey('warehouse.id'), nullable=False)
    current_stock = db.Column('stock', db.Numeric(10, 2), nullable=False, server_default='0')

    product = db.relationship('Product', back_populates='product_warehouses', lazy=True)
    warehouse = db.relationship('Warehouse', back_populates='product_warehouses', lazy=True)

    def serialize(self):
        return {
            'id': self.id,
            'product_id': self.product_id,
            'product_name': self.product.name if self.product else None,
            'warehouse_id': self.warehouse_id,
            'warehouse_name': self.warehouse.name if self.warehouse else None,
            'current_stock': float(self.current_stock) if self.current_stock is not None else 0.0,
        }
