from app.db import db
from datetime import datetime

class WorkOrder(db.Model):
    __tablename__ = 'work_order'
    
    # Estados posibles
    STATUS_PLANNED = 'Planificada'
    STATUS_IN_PROGRESS = 'En Progreso'
    STATUS_FINISHED = 'Finalizada'
    STATUS_CANCELLED = 'Cancelada'
    
    id = db.Column(db.Integer, primary_key=True)
    org_id = db.Column(db.Integer, db.ForeignKey('organization.id'), nullable=False)
    product_id = db.Column(db.Integer, db.ForeignKey('product.id'), nullable=False)
    bom_id = db.Column(db.Integer, db.ForeignKey('bom.id'), nullable=False)
    quantity = db.Column(db.Numeric(10, 2), nullable=False)
    status = db.Column(db.String(50), default=STATUS_PLANNED, nullable=False)
    warehouse_id = db.Column(db.Integer, db.ForeignKey('warehouse.id'))
    assigned_to = db.Column(db.Integer, db.ForeignKey('user.id'))
    reference = db.Column(db.String(100))  # Referencia externa (orden venta, etc)
    notes = db.Column(db.Text)
    
    # Fechas
    planned_start = db.Column(db.DateTime)
    planned_end = db.Column(db.DateTime)
    actual_start = db.Column(db.DateTime)
    actual_end = db.Column(db.DateTime)
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
    created_by = db.Column(db.Integer, db.ForeignKey('user.id'))
    
    # Relationships
    organization = db.relationship('Organization', backref='work_orders')
    product = db.relationship('Product', foreign_keys=[product_id], backref='work_orders')
    bom = db.relationship('BOM', backref='work_orders')
    warehouse = db.relationship('Warehouse', backref='work_orders')
    assigned_user = db.relationship('User', foreign_keys=[assigned_to], backref='assigned_work_orders')
    creator = db.relationship('User', foreign_keys=[created_by], backref='created_work_orders')
    
    __table_args__ = (
        db.CheckConstraint('quantity > 0', name='ck_work_order_quantity_positive'),
        db.CheckConstraint(f"status IN ('{STATUS_PLANNED}', '{STATUS_IN_PROGRESS}', '{STATUS_FINISHED}', '{STATUS_CANCELLED}')", 
                          name='ck_work_order_status_valid')
    )
    
    def to_dict(self):
        return {
            'id': self.id,
            'org_id': self.org_id,
            'product_id': self.product_id,
            'product_name': self.product.name if self.product else None,
            'product_code': self.product.code if self.product else None,
            'bom_id': self.bom_id,
            'bom_version': self.bom.version if self.bom else None,
            'quantity': float(self.quantity) if self.quantity else 0,
            'status': self.status,
            'warehouse_id': self.warehouse_id,
            'warehouse_name': self.warehouse.name if self.warehouse else None,
            'assigned_to': self.assigned_to,
            'assigned_to_name': self.assigned_user.name if self.assigned_user else None,
            'reference': self.reference,
            'notes': self.notes,
            'planned_start': self.planned_start.isoformat() if self.planned_start else None,
            'planned_end': self.planned_end.isoformat() if self.planned_end else None,
            'actual_start': self.actual_start.isoformat() if self.actual_start else None,
            'actual_end': self.actual_end.isoformat() if self.actual_end else None,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
            'created_by': self.created_by,
            'created_by_name': self.creator.name if self.creator else None
        }
