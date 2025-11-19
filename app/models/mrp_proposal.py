# models/mrp_proposal.py
from app.db import db
from sqlalchemy import func

class MRPProposal(db.Model):
    """
    Modelo de Propuesta MRP - Sprint 4
    Representa propuestas de compra (BUY) o producción (MAKE) generadas por el MRP
    """
    __tablename__ = 'mrp_proposal'
    
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    org_id = db.Column(db.Integer, db.ForeignKey('organization.id'), nullable=False, index=True)
    product_id = db.Column(db.Integer, db.ForeignKey('product.id'), nullable=False, index=True)
    
    # Tipo de propuesta
    type = db.Column(
        db.Enum('BUY', 'MAKE', name='mrp_proposal_type'),
        nullable=False,
        index=True
    )
    
    # Cantidades y fechas
    quantity = db.Column(db.Numeric(15, 2), nullable=False)
    due_date = db.Column(db.Date, nullable=False, index=True)  # Fecha en que se necesita
    
    # Referencia al periodo del MPS que originó esta propuesta
    source_period = db.Column(db.Date, nullable=True)
    mps_plan_id = db.Column(db.Integer, db.ForeignKey('mps_plan.id'), nullable=True)
    
    # Estado de la propuesta
    status = db.Column(
        db.Enum('proposed', 'approved', 'rejected', 'executed', name='mrp_proposal_status'),
        nullable=False,
        server_default='proposed',
        index=True
    )
    
    # Razón/motivo de la propuesta
    reason = db.Column(db.Text, nullable=True)
    
    # Datos adicionales para compras
    supplier_id = db.Column(db.Integer, db.ForeignKey('supplier.id'), nullable=True)
    estimated_cost = db.Column(db.Numeric(15, 2), nullable=True)
    
    # Datos adicionales para producción
    warehouse_id = db.Column(db.Integer, db.ForeignKey('warehouse.id'), nullable=True)
    
    # Referencia a la entidad ejecutada (si se aprobó)
    executed_reference_type = db.Column(db.String(20), nullable=True)  # 'WO' o 'PO'
    executed_reference_id = db.Column(db.Integer, nullable=True)
    
    # Auditoría
    created_by = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=True)
    created_at = db.Column(db.TIMESTAMP, server_default=func.now(), nullable=False)
    updated_at = db.Column(db.TIMESTAMP, server_default=func.now(), onupdate=func.now())
    approved_at = db.Column(db.TIMESTAMP, nullable=True)
    approved_by = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=True)
    
    # Relaciones
    product = db.relationship('Product', backref='mrp_proposals', lazy=True)
    organization = db.relationship('Organization', backref='mrp_proposals', lazy=True)
    mps_plan = db.relationship('MPSPlan', backref='mrp_proposals', lazy=True)
    supplier = db.relationship('Supplier', backref='mrp_proposals', lazy=True)
    warehouse = db.relationship('Warehouse', backref='mrp_proposals', lazy=True)
    creator = db.relationship('User', foreign_keys=[created_by], backref='created_mrp_proposals', lazy=True)
    approver = db.relationship('User', foreign_keys=[approved_by], backref='approved_mrp_proposals', lazy=True)
    
    def serialize(self):
        return {
            'id': self.id,
            'org_id': self.org_id,
            'product_id': self.product_id,
            'product_code': self.product.code if self.product else None,
            'product_name': self.product.name if self.product else None,
            'type': self.type,
            'quantity': float(self.quantity) if self.quantity else 0,
            'due_date': self.due_date.isoformat() if self.due_date else None,
            'source_period': self.source_period.isoformat() if self.source_period else None,
            'mps_plan_id': self.mps_plan_id,
            'status': self.status,
            'reason': self.reason,
            'supplier_id': self.supplier_id,
            'supplier_name': self.supplier.name if self.supplier else None,
            'estimated_cost': float(self.estimated_cost) if self.estimated_cost else None,
            'warehouse_id': self.warehouse_id,
            'warehouse_name': self.warehouse.name if self.warehouse else None,
            'executed_reference_type': self.executed_reference_type,
            'executed_reference_id': self.executed_reference_id,
            'created_by': self.created_by,
            'created_by_name': self.creator.name if self.creator else None,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
            'approved_at': self.approved_at.isoformat() if self.approved_at else None,
            'approved_by': self.approved_by,
            'approved_by_name': self.approver.name if self.approver else None
        }
    
    def __repr__(self):
        return f'<MRPProposal {self.id}: {self.type} {self.product_id} - {self.quantity} - {self.due_date}>'
