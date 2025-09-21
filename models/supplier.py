#models/supplier.py
from myapp import db
from datetime import datetime

class Supplier(db.Model):
    __tablename__ = 'supplier'

    id = db.Column('id', db.Integer, primary_key=True, autoincrement=True, nullable=False)
    name = db.Column('name', db.String(100), nullable=False)
    phone = db.Column('phone', db.String(50),nullable=True)
    mobile = db.Column('mobile', db.String(50),nullable=True)
    address = db.Column('address', db.String(100),nullable=True)
    city = db.Column('city', db.String(100),nullable=True)
    email = db.Column('email', db.String(50),nullable=True)

    # Multi-tenant support
    org_id = db.Column('org_id', db.Integer, db.ForeignKey('organization.id'), nullable=False, server_default=db.text('1'))
    # Status: active/inactive
    status = db.Column(db.Boolean, nullable=False, server_default=db.text('true'))

    created_at = db.Column('created_at', db.TIMESTAMP, default=datetime.utcnow)
    updated_at = db.Column('updated_at', db.TIMESTAMP, default=datetime.utcnow, onupdate=datetime.utcnow)
    deleted_at = db.Column('deleted_at', db.TIMESTAMP, nullable=True)
    created_by = db.Column('created_by', db.Integer)
    updated_by = db.Column('updated_by', db.Integer)

    def serialize(self):
        return {
            'id': self.id,
            'name':self.name,
            'phone': self.phone,
            'mobile': self.mobile,
            'address': self.address,
            'city': self.city,
            'email': self.email,
            'status': self.status,
            'created_at': self.created_at,
            'updated_at': self.updated_at,
            'deleted_at': self.deleted_at,
            'created_by': self.created_by,
            'updated_by': self.updated_by,            
        }
