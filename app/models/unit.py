#models/unit.py
from app.db import db

class Unit(db.Model):
    __tablename__ = 'unit'
    id = db.Column('id', db.Integer, primary_key=True, autoincrement=True, nullable=False)
    code = db.Column('code', db.String(50))
    description = db.Column('description', db.String(50))

    def serialize(self):
        return {
            'id': self.id,
            'code': self.code,
            'description': self.description,
        }
