#models/movement.py
from datetime import datetime

from app.db import db


class Movement(db.Model):
    __tablename__ = 'movement'
    __table_args__ = (
        db.CheckConstraint('quantity > 0', name='ck_movement_qty_pos'),
        # Indexes for faster lookups
        db.Index('ix_movement_product_id', 'product_id'),
        db.Index('ix_movement_from_warehouse', 'from_warehouse_id'),
        db.Index('ix_movement_to_warehouse', 'to_warehouse_id'),
        db.Index('ix_movement_created_at', 'created_at'),
    )
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    org_id = db.Column(db.Integer, db.ForeignKey('organization.id'), nullable=False, server_default=db.text('1'))
    product_id = db.Column(db.Integer, db.ForeignKey('product.id'), nullable=False)
    from_warehouse_id = db.Column(db.Integer, db.ForeignKey('warehouse.id'))
    to_warehouse_id = db.Column(db.Integer, db.ForeignKey('warehouse.id'))
    movement_type = db.Column(db.Enum('IN', 'OUT', 'TRANSFER', 'ADJUST', name='movement_type'), nullable=False)
    reason = db.Column(db.Enum('PURCHASE', 'CONSUMPTION', 'TRANSFER', 'PRODUCTION', 'ADJUSTMENT', 'RETURN', 'OTHER', name='movement_reason'), nullable=False)
    quantity = db.Column(db.Numeric(18, 6), nullable=False)
    reference_id = db.Column(db.String(80))
    reference_type = db.Column(db.String(40))
    note = db.Column(db.String(255))
    created_by = db.Column(db.Integer, db.ForeignKey('user.id'))
    created_at = db.Column(db.TIMESTAMP, default=datetime.utcnow, nullable=False)

    def serialize(self):
        return {
            'id': self.id,
            'org_id': self.org_id,
            'product_id': self.product_id,
            'from_warehouse_id': self.from_warehouse_id,
            'to_warehouse_id': self.to_warehouse_id,
            'movement_type': self.movement_type,
            'reason': self.reason,
            'quantity': float(self.quantity),
            'reference_id': self.reference_id,
            'reference_type': self.reference_type,
            'note': self.note,
            'created_by': self.created_by,
            'created_at': self.created_at,
        }
