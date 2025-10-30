from app.db import db
from datetime import datetime

class BOM(db.Model):
    __tablename__ = 'bom'
    
    id = db.Column(db.Integer, primary_key=True)
    org_id = db.Column(db.Integer, db.ForeignKey('organization.id'), nullable=False)
    product_id = db.Column(db.Integer, db.ForeignKey('product.id'), nullable=False)
    version = db.Column(db.String(50), nullable=False, default='1.0')
    is_active = db.Column(db.Boolean, default=False, nullable=False)
    description = db.Column(db.String(500))
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
    
    # Relationships
    organization = db.relationship('Organization', backref='boms')
    product = db.relationship('Product', backref='boms')
    components = db.relationship('BOMComponent', backref='bom', cascade='all, delete-orphan', lazy='dynamic')
    
    __table_args__ = (
        db.UniqueConstraint('org_id', 'product_id', 'version', name='uq_bom_product_version'),
    )
    
    def to_dict(self):
        return {
            'id': self.id,
            'org_id': self.org_id,
            'product_id': self.product_id,
            'product_name': self.product.name if self.product else None,
            'product_code': self.product.code if self.product else None,
            'version': self.version,
            'is_active': self.is_active,
            'description': self.description,
            'components': [c.to_dict() for c in self.components],
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }


class BOMComponent(db.Model):
    __tablename__ = 'bom_component'
    
    id = db.Column(db.Integer, primary_key=True)
    bom_id = db.Column(db.Integer, db.ForeignKey('bom.id'), nullable=False)
    component_id = db.Column(db.Integer, db.ForeignKey('product.id'), nullable=False)
    quantity = db.Column(db.Numeric(10, 4), nullable=False)
    scrap_percentage = db.Column(db.Numeric(5, 2), default=0.0, nullable=False)  # % de desperdicio
    unit_id = db.Column(db.Integer, db.ForeignKey('unit.id'))
    sequence = db.Column(db.Integer, default=0)
    notes = db.Column(db.String(500))
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    
    # Relationships
    component = db.relationship('Product', foreign_keys=[component_id], backref='used_in_boms')
    unit = db.relationship('Unit', backref='bom_components')
    
    __table_args__ = (
        db.UniqueConstraint('bom_id', 'component_id', name='uq_bom_component'),
        db.CheckConstraint('quantity > 0', name='ck_bom_component_quantity_positive'),
        db.CheckConstraint('scrap_percentage >= 0 AND scrap_percentage <= 100', name='ck_bom_component_scrap_range')
    )
    
    def to_dict(self):
        return {
            'id': self.id,
            'bom_id': self.bom_id,
            'component_id': self.component_id,
            'component_name': self.component.name if self.component else None,
            'component_code': self.component.code if self.component else None,
            'quantity': float(self.quantity) if self.quantity else 0,
            'scrap_percentage': float(self.scrap_percentage) if self.scrap_percentage else 0,
            'unit_id': self.unit_id,
            'unit_name': self.unit.name if self.unit else None,
            'sequence': self.sequence,
            'notes': self.notes,
            'created_at': self.created_at.isoformat() if self.created_at else None
        }
