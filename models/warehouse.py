#models/warehouse.py

from app.db import db
from sqlalchemy import func


class Warehouse(db.Model):
    __tablename__ = 'warehouse'
    id = db.Column('id', db.Integer, primary_key=True, autoincrement=True, nullable=False)
    name = db.Column('name', db.String(100), nullable=False)
    location = db.Column('location', db.String(200))
    org_id = db.Column('org_id', db.Integer, db.ForeignKey('organization.id'), nullable=False, server_default=db.text('1'))
    created_at = db.Column('created_at', db.TIMESTAMP, server_default=func.now())
    updated_at = db.Column('updated_at', db.TIMESTAMP, server_default=func.now(), onupdate=func.now())

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
