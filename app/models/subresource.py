#models/subresource.py
from app.db import db

class Subresource(db.Model):
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    resource_id = db.Column(db.Integer, db.ForeignKey('resource.id'), nullable=False)
    name = db.Column(db.String(50), unique=False, nullable=False)
    description = db.Column(db.String(200), unique=False, nullable=True)
    url = db.Column(db.String(100), unique=False, nullable=True)
    icon = db.Column(db.String(80), unique=False, nullable=True)

    resource = db.relationship('Resource', back_populates='subresources')

    def serialize(self):
        return {
            'id': self.id,
            'resource_id': self.resource_id,
            'name': self.name,
            'description': self.description,
            'url': self.url,
            'icon': self.icon,
        }
