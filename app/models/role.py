# models/role.py
from app.db import db

class Role(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(50), unique=True, nullable=False)
    description = db.Column(db.String(100), unique=True, nullable=True)
    status = db.Column(db.Boolean, server_default=db.text('true'))

    # Relación con UserRole para obtener usuarios asociados con este rol
    users = db.relationship('UserRole', back_populates='role', lazy='dynamic')

    def serialize(self):
        return {
            'id': self.id,
            'name': self.name,
            'description': self.description,
            'status': self.status,
        }
