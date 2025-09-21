#models/subcategory.py
from datetime import datetime
from myapp import db


class Subcategory(db.Model):
    __tablename__ = 'subcategory'  # Especificar el nombre de la tabla
    id = db.Column('subcategoryid', db.Integer, primary_key=True, autoincrement=True, nullable=False)
    category_id = db.Column('categoryid', db.Integer,db.ForeignKey('category.categoryid'), nullable=False)    
    code = db.Column('code', db.String(50), nullable=True)
    name = db.Column('name', db.String(100), nullable=True)
    description = db.Column('description', db.String(200), nullable=True)
    created_at = db.Column('created_at', db.TIMESTAMP, default=datetime.utcnow)
    updated_at = db.Column('updated_at', db.TIMESTAMP, default=datetime.utcnow, onupdate=datetime.utcnow)
    deleted_at = db.Column('deleted_at', db.TIMESTAMP, nullable=True)
    created_by = db.Column('created_by', db.Integer)
    updated_by = db.Column('updated_by', db.Integer)
    status = db.Column(db.Integer, nullable=False, default=1)  # 1: Activo, 0: Eliminado
    subfolder = db.Column('subfolder', db.String(100), nullable=True)
    company_id_by = db.Column('companyid_by', db.Integer, nullable=True)

    # category = db.relationship('invcategory', backref=db.backref('subcategory', lazy=True))
    # category = db.relationship('invcategory', back_populates='subcategory')
    # category = db.relationship('Category', back_populates='subcategories')
    category = db.relationship('Category', back_populates='subcategories',lazy=True)

    def serialize(self):
        return {
            'id': self.id,
            'category_id': self.category_id,
            'code': self.code,
            'name': self.name,
            'description': self.description,
            'created_at': self.created_at,
            'updated_at': self.updated_at,
            'deleted_at': self.deleted_at,
            'created_by': self.created_by,
            'updated_by': self.updated_by,
            'status': self.status,
            'subfolder': self.subfolder,
            'company_id_by': self.company_id_by,
            'category':self.category.name if self.category else None
        }
