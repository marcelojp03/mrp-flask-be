#models/user.py
from app.db import db
class User(db.Model):
    __tablename__ = 'user'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(100), unique=True, nullable=False)
    password = db.Column(db.String(255), nullable=False)
    photo = db.Column(db.String(255), nullable=True)  
    status = db.Column(db.Boolean, server_default=db.text('true'))

    # Relación con UserRole para obtener los roles del usuario
    roles = db.relationship('UserRole', back_populates='user', lazy='dynamic')

    
    def serialize(self):
        return {
            'id': self.id,
            'name': self.name,
            'email': self.email,
            'photo': self.photo,
            'status': self.status,
            'roles': [user_role.serialize() for user_role in self.roles]
        }
