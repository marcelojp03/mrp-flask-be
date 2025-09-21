#models/product_image.py
from myapp import db

class ProductImage(db.Model):
    __tablename__='product_image'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255), nullable=False)
    product_id = db.Column(db.Integer, db.ForeignKey('product.id'), nullable=False)

    product = db.relationship('Product', backref=db.backref('images', lazy=True))

    def serialize(self):
        return {
            'id': self.id,
            'name': self.name,
            'product_id': self.product_id
        }
