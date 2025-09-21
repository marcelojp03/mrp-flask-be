#models/role_resource.py
from myapp import db

class RoleResource(db.Model):
    __tablename__='role_resource'
    role_id = db.Column(db.Integer, db.ForeignKey('role.id'),primary_key=True)
    resource_id = db.Column(db.Integer, db.ForeignKey('resource.id'),primary_key=True)
    subresource_id = db.Column(db.Integer, db.ForeignKey('subresource.id'),primary_key=True)

    def serialize(self):
        return {
            'role_id': self.role_id,
            'resource_id': self.resource_id,
            'subresource_id': self.subresource_id
        }
