#models/user_role.py
from myapp import db

class UserRole(db.Model):
    __tablename__='user_role'
    role_id = db.Column(db.Integer, db.ForeignKey('role.id'), primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), primary_key=True)

    role = db.relationship('Role', back_populates='users')
    user = db.relationship('User', back_populates='roles')

    def serialize(self):
        return {
            'role_id': self.role_id,
            'role': self.role.name if self.role else None,
            'user_id': self.user_id
        }
