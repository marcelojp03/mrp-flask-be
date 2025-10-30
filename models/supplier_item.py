# models/supplier_item.py
from app.db import db

class SupplierItem(db.Model):
    __tablename__ = 'supplier_item'
    __table_args__ = (
        db.UniqueConstraint('product_id', 'supplier_id', name='uq_supplier_item_prod_sup'),
        db.CheckConstraint('lead_time_days >= 0', name='ck_supplier_item_lead_time_nonneg'),
        db.CheckConstraint('min_order_qty >= 0', name='ck_supplier_item_moq_nonneg'),
        db.CheckConstraint('price >= 0', name='ck_supplier_item_price_nonneg'),
    )

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    org_id = db.Column(db.Integer, db.ForeignKey('organization.id'), nullable=False, server_default=db.text('1'))
    product_id = db.Column(db.Integer, db.ForeignKey('product.id'), nullable=False)
    supplier_id = db.Column(db.Integer, db.ForeignKey('supplier.id'), nullable=False)

    price = db.Column(db.Numeric(12, 4), nullable=True)          # precio vigente
    currency = db.Column(db.String(3), nullable=True)             # 'BOB', 'USD' (opcional S1)
    lead_time_days = db.Column(db.Integer, nullable=True)         # LT proveedor → para MRP S3
    min_order_qty = db.Column(db.Numeric(12, 4), nullable=True)   # Lote mínimo
    pack_size = db.Column(db.Numeric(12, 4), nullable=True)       # múltiplo de compra (opcional)

    is_preferred = db.Column(db.Boolean, server_default=db.text('false'), nullable=False)
    is_active = db.Column(db.Boolean, server_default=db.text('true'), nullable=False)

    def serialize(self):
        f = lambda x: float(x) if x is not None else None
        return {
            'id': self.id,
            'org_id': self.org_id,
            'product_id': self.product_id,
            'supplier_id': self.supplier_id,
            'price': f(self.price),
            'currency': self.currency,
            'lead_time_days': self.lead_time_days,
            'min_order_qty': f(self.min_order_qty),
            'pack_size': f(self.pack_size),
            'is_preferred': self.is_preferred,
            'is_active': self.is_active,
        }
