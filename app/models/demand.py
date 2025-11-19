# models/demand.py
from app.db import db
from sqlalchemy import func
from datetime import date

class Demand(db.Model):
    """
    Modelo de Demanda - Sprint 4
    Representa la demanda proyectada o histórica de productos por periodo
    """
    __tablename__ = 'demand'
    
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    org_id = db.Column(db.Integer, db.ForeignKey('organization.id'), nullable=False, index=True)
    product_id = db.Column(db.Integer, db.ForeignKey('product.id'), nullable=False, index=True)
    
    # Periodo puede ser fecha, semana o mes
    period = db.Column(db.Date, nullable=False, index=True)  # Fecha de inicio del periodo
    quantity = db.Column(db.Numeric(15, 2), nullable=False)
    
    # Fuente de la demanda
    source = db.Column(
        db.Enum('manual', 'import', 'forecast', name='demand_source'),
        nullable=False,
        server_default='manual'
    )
    
    # Estado de la demanda
    status = db.Column(
        db.Enum('draft', 'confirmed', 'cancelled', name='demand_status'),
        nullable=False,
        server_default='draft'
    )
    
    # Notas adicionales
    notes = db.Column(db.Text, nullable=True)
    
    # Auditoría
    created_by = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=True)
    created_at = db.Column(db.TIMESTAMP, server_default=func.now(), nullable=False)
    updated_at = db.Column(db.TIMESTAMP, server_default=func.now(), onupdate=func.now())
    
    # Relaciones
    product = db.relationship('Product', backref='demands', lazy=True)
    organization = db.relationship('Organization', backref='demands', lazy=True)
    creator = db.relationship('User', backref='created_demands', lazy=True)
    
    def serialize(self):
        return {
            'id': self.id,
            'org_id': self.org_id,
            'product_id': self.product_id,
            'product_code': self.product.code if self.product else None,
            'product_name': self.product.name if self.product else None,
            'period': self.period.isoformat() if self.period else None,
            'quantity': float(self.quantity) if self.quantity else 0,
            'source': self.source,
            'status': self.status,
            'notes': self.notes,
            'created_by': self.created_by,
            'created_by_name': self.creator.name if self.creator else None,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }
    
    def __repr__(self):
        return f'<Demand {self.id}: {self.product_id} - {self.period} - {self.quantity}>'
