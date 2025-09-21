#models/category.py
from myapp import db
from datetime import datetime

class Category(db.Model):
    __tablename__ = 'category' 
    id = db.Column('categoryid', db.Integer, primary_key=True, autoincrement=True, nullable=False)
    code = db.Column('code', db.String(50), nullable=True)
    name = db.Column('name', db.String(100), nullable=False)
    description = db.Column('description', db.String(200), nullable=True)
    created_at = db.Column('created_at', db.TIMESTAMP, default=datetime.utcnow)
    updated_at = db.Column('updated_at', db.TIMESTAMP, default=datetime.utcnow, onupdate=datetime.utcnow)
    deleted_at = db.Column('deleted_at', db.TIMESTAMP, nullable=True)
    created_by = db.Column('created_by', db.Integer)
    updated_by = db.Column('updated_by', db.Integer)
    status = db.Column(db.Integer, nullable=False, default=1)  # 1: Activo, 0: Eliminado
    folder = db.Column('folder', db.String(100), nullable=True)
    company_id_by = db.Column('companyid_by', db.Integer, nullable=True) 

    # subcategory = db.relationship('invsubcategory', backref=db.backref('category', lazy=True))
    # subcategory = db.relationship('invsubcategory', back_populates='category')

    # estado = db.Column(db.Boolean, server_default='1')
    # subcategories = db.relationship('Subcategory', backref='category', lazy=True)
    subcategories = db.relationship('Subcategory', back_populates='category', lazy=True)

    def serialize(self):
        return {
            'id': self.id,
            'code': self.code,
            'name': self.name,
            'description': self.description,
            'created_at': self.created_at,
            'updated_at': self.updated_at,
            'deleted_at': self.deleted_at,
            'created_by': self.created_by,
            'updated_by': self.updated_by,
            'status': self.status,
            'folder': self.folder,
            'company_id_by': self.company_id_by,
        }
