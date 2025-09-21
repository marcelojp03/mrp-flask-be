#models/warehouse.py
from datetime import datetime

from myapp import db


class Warehouse(db.Model):
    __tablename__ = 'warehouse'
    id = db.Column('id', db.Integer, primary_key=True, autoincrement=True, nullable=False)
    name = db.Column('name', db.String(100), nullable=False)
    location = db.Column('location', db.String(200))
    org_id = db.Column('org_id', db.Integer, db.ForeignKey('organization.id'), nullable=False, server_default=db.text('1'))
    created_at = db.Column('created_at', db.TIMESTAMP, default=datetime.utcnow)
    updated_at = db.Column('updated_at', db.TIMESTAMP, default=datetime.utcnow, onupdate=datetime.utcnow)

    # Relaciones
    product_warehouses = db.relationship('ProductWarehouse', back_populates='warehouse', lazy='dynamic')

    def serialize(self):
        return {
            'id': self.id,
            'name': self.name,
            'location': self.location,
            'org_id': self.org_id,
            'created_at': self.created_at,
            'updated_at': self.updated_at,
        }
