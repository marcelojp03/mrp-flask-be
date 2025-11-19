# models/mps_plan.py
from app.db import db
from sqlalchemy import func

class MPSPlan(db.Model):
    """
    Modelo de Plan Maestro de Producción (MPS) - Sprint 4
    Representa el plan de producción por producto y periodo
    """
    __tablename__ = 'mps_plan'
    
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    org_id = db.Column(db.Integer, db.ForeignKey('organization.id'), nullable=False, index=True)
    product_id = db.Column(db.Integer, db.ForeignKey('product.id'), nullable=False, index=True)
    
    # Periodo del plan
    period = db.Column(db.Date, nullable=False, index=True)  # Fecha de inicio del periodo
    
    # Cantidades planificadas
    planned_qty = db.Column(db.Numeric(15, 2), nullable=False)
    
    # Estado del plan
    status = db.Column(
        db.Enum('draft', 'published', 'cancelled', name='mps_status'),
        nullable=False,
        server_default='draft',
        index=True
    )
    
    # Referencia a la demanda que originó este plan
    demand_id = db.Column(db.Integer, db.ForeignKey('demand.id'), nullable=True)
    
    # Notas adicionales
    notes = db.Column(db.Text, nullable=True)
    
    # Auditoría
    created_by = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=True)
    created_at = db.Column(db.TIMESTAMP, server_default=func.now(), nullable=False)
    updated_at = db.Column(db.TIMESTAMP, server_default=func.now(), onupdate=func.now())
    published_at = db.Column(db.TIMESTAMP, nullable=True)
    
    # Relaciones
    product = db.relationship('Product', backref='mps_plans', lazy=True)
    organization = db.relationship('Organization', backref='mps_plans', lazy=True)
    demand = db.relationship('Demand', backref='mps_plans', lazy=True)
    creator = db.relationship('User', backref='created_mps_plans', lazy=True)
    
    def serialize(self):
        return {
            'id': self.id,
            'org_id': self.org_id,
            'product_id': self.product_id,
            'product_code': self.product.code if self.product else None,
            'product_name': self.product.name if self.product else None,
            'period': self.period.isoformat() if self.period else None,
            'planned_qty': float(self.planned_qty) if self.planned_qty else 0,
            'status': self.status,
            'demand_id': self.demand_id,
            'notes': self.notes,
            'created_by': self.created_by,
            'created_by_name': self.creator.name if self.creator else None,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
            'published_at': self.published_at.isoformat() if self.published_at else None
        }
    
    def __repr__(self):
        return f'<MPSPlan {self.id}: {self.product_id} - {self.period} - {self.planned_qty}>'
