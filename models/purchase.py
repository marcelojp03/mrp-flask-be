#models/purchase.py
from myapp import db
from datetime import datetime

class Purchase(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    # Multi-tenant support
    org_id = db.Column('org_id', db.Integer, db.ForeignKey('organization.id'), nullable=False, server_default=db.text('1'))
    order_number = db.Column(db.Integer, nullable=False)
    date = db.Column(db.DateTime, nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    # supplier references provider.providerid (provider table uses providerid PK)
    supplier_id = db.Column(db.Integer, db.ForeignKey('provider.providerid'), nullable=False)
    warehouse_id = db.Column(db.Integer, db.ForeignKey('warehouse.warehouseid'), nullable=False)
    total = db.Column(db.DECIMAL(10, 2), nullable=False)
    status = db.Column(db.String(50), nullable=False, default='completed')

    supplier = db.relationship('Supplier', backref=db.backref('purchases', lazy=True))
    warehouse = db.relationship('Warehouse', backref=db.backref('purchases', lazy=True))
    # user relationship omitted to avoid circular imports

    def serialize(self):
        return {
            'id': self.id,
            'order_number': self.order_number,
            'date': self.date,
            'user_id': self.user_id,
            'supplier_id': self.supplier_id,
            'warehouse_id': self.warehouse_id,
            'total': float(self.total) if self.total is not None else 0.0,
            'status': self.status
        }
