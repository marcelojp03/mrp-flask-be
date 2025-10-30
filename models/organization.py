#models/organization.py
from app.db import db


class Organization(db.Model):
    __tablename__ = 'organization'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(120), nullable=False)
    code = db.Column(db.String(60), unique=True, nullable=False)
    is_active = db.Column(db.Boolean, server_default=db.text('true'), nullable=False)

    def serialize(self):
        return {
            'id': self.id,
            'name': self.name,
            'code': self.code,
            'is_active': self.is_active,
        }
