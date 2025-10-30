#models/product.py
from datetime import datetime
from app.db import db

class Product(db.Model):
    __tablename__ = 'product'
    __table_args__ = (
        db.UniqueConstraint('org_id', 'code', name='uq_product_org_code'),
        db.CheckConstraint('min_stock >= 0', name='ck_product_min_stock_nonneg'),
    )

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    org_id = db.Column(db.Integer, db.ForeignKey('organization.id'), nullable=False, server_default=db.text('1'))

    code = db.Column(db.String(50), nullable=False)
    name = db.Column(db.String(100), nullable=False)
    description = db.Column(db.String(200))

    unit_id = db.Column(db.Integer, db.ForeignKey('unit.id'), nullable=True)

    min_stock = db.Column(db.Numeric(10, 2), nullable=False, server_default='0')
    procurement_type = db.Column(db.Enum('MAKE', 'BUY', name='procurement_type'), nullable=False, server_default='BUY')
    item_type = db.Column(db.Enum('RM', 'WIP', 'FG', 'CONSUMABLE', 'SERVICE', 'KIT', name='item_type'), nullable=False, server_default='FG')

    status = db.Column(db.Boolean, server_default=db.text('true'), nullable=False)
    created_at = db.Column(db.TIMESTAMP, default=datetime.utcnow, nullable=False)
    updated_at = db.Column(db.TIMESTAMP, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)

    unit = db.relationship('Unit', backref='products', lazy=True)
    product_warehouses = db.relationship('ProductWarehouse', back_populates='product', lazy='dynamic', cascade='all, delete-orphan')

    def serialize(self):
        f = lambda x: float(x) if x is not None else None
        return {
            'id': self.id, 
            'org_id': self.org_id, 
            'code': self.code, 
            'name': self.name,
            'description': self.description,
            'unit_id': self.unit_id, 
            'unit_code': (self.unit.code if self.unit else None),
            'min_stock': f(self.min_stock), 
            'procurement_type': self.procurement_type, 
            'item_type': self.item_type,
            'status': self.status, 
            'created_at': self.created_at, 
            'updated_at': self.updated_at
        }

    def is_stockable(self):
        return self.item_type in ['RM', 'WIP', 'FG', 'CONSUMABLE']

    def requires_unit(self):
        return self.is_stockable()
