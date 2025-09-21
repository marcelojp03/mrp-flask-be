#models/purchase_detail.py
from myapp import db

class PurchaseDetail(db.Model):
    __tablename__='purchase_detail'
    id = db.Column(db.Integer, primary_key=True)
    purchase_id = db.Column(db.Integer, db.ForeignKey('purchase.id'), nullable=False)
    product_id = db.Column(db.Integer, db.ForeignKey('product.productid'), nullable=False)
    quantity = db.Column(db.Integer, nullable=False)
    price = db.Column(db.DECIMAL(10, 2), nullable=False)
    total = db.Column(db.DECIMAL(10, 2), nullable=False)

    purchase = db.relationship('Purchase', backref=db.backref('purchase_details', lazy=True))
    product = db.relationship('Product', backref=db.backref('purchase_details', lazy=True))

    def serialize(self):
        return {
            'id': self.id,
            'purchase_id': self.purchase_id,
            'product_id': self.product_id,
            'quantity': self.quantity,
            'price': str(self.price),
            'total': str(self.total),
        }
