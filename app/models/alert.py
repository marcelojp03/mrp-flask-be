# models/alert.py
from app.db import db
from datetime import datetime

class Alert(db.Model):
    __tablename__ = 'alert'
    
    id = db.Column(db.Integer, primary_key=True)
    org_id = db.Column(db.Integer, db.ForeignKey('organization.id'), nullable=False)
    
    # Tipo de alerta
    type = db.Column(db.String(50), nullable=False)  # low_stock, wo_delay, mrp_pending, supplier_expiry, etc.
    severity = db.Column(db.String(20), nullable=False, default='info')  # info, warning, critical
    
    # Contenido
    title = db.Column(db.String(200), nullable=False)
    message = db.Column(db.Text, nullable=False)
    
    # Referencias (opcional - para vincular con entidades)
    reference_type = db.Column(db.String(50))  # product, work_order, mrp_proposal, supplier, etc.
    reference_id = db.Column(db.Integer)
    
    # Metadata adicional (JSON)
    alert_metadata = db.Column('metadata', db.JSON)
    
    # Estado
    is_read = db.Column(db.Boolean, default=False, nullable=False)
    read_at = db.Column(db.DateTime)
    read_by = db.Column(db.Integer, db.ForeignKey('user.id'))
    
    # Timestamps
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    expires_at = db.Column(db.DateTime)  # Opcional: alertas que expiran
    
    # Relationships
    organization = db.relationship('Organization', backref='alerts')
    reader = db.relationship('User', foreign_keys=[read_by], backref='read_alerts')
    
    __table_args__ = (
        db.Index('idx_alert_org_unread', 'org_id', 'is_read'),
        db.Index('idx_alert_type', 'type'),
        db.Index('idx_alert_severity', 'severity'),
        db.Index('idx_alert_created', 'created_at'),
    )
    
    def serialize(self):
        return {
            'id': self.id,
            'org_id': self.org_id,
            'type': self.type,
            'severity': self.severity,
            'title': self.title,
            'message': self.message,
            'reference_type': self.reference_type,
            'reference_id': self.reference_id,
            'metadata': self.alert_metadata,
            'is_read': self.is_read,
            'read_at': self.read_at.isoformat() if self.read_at else None,
            'read_by': self.read_by,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'expires_at': self.expires_at.isoformat() if self.expires_at else None
        }
