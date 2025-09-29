#models/user_organization.py
from sqlalchemy import func
from myapp import db
from datetime import datetime

class UserOrganization(db.Model):
    __tablename__ = 'user_organization'
    __table_args__ = (
        db.UniqueConstraint('user_id', 'org_id', name='uq_user_org'),
        # (Opcional) índice para consultar default rápido
        db.Index('ix_user_org_default', 'user_id', 'is_default'),
    )

    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), primary_key=True)
    org_id  = db.Column(db.Integer, db.ForeignKey('organization.id'), primary_key=True)
    is_default = db.Column(db.Boolean, nullable=False, server_default=db.text('false'))
    created_at = db.Column(db.DateTime, nullable=False, server_default=func.now())
    updated_at = db.Column(db.DateTime, nullable=False, server_default=func.now(), onupdate=func.now())

    def serialize(self):
        return {
            'user_id': self.user_id,
            'org_id': self.org_id,
            'is_default': self.is_default,
            'created_at': self.created_at,
            'updated_at': self.updated_at
        }
    
# class UserOrganization(db.Model):
#     __tablename__ = 'user_organization'
#     id = db.Column(db.Integer, primary_key=True, autoincrement=True)
#     user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
#     org_id = db.Column(db.Integer, db.ForeignKey('organization.id'), nullable=False)
#     org_role = db.Column(db.Enum('ADMIN', 'PLANNER', 'SUPERVISOR', 'OPERATOR', 'VIEWER', name='org_role'), nullable=False)
#     is_default = db.Column(db.Boolean, server_default=db.text('false'), nullable=False)

#     __table_args__ = (db.UniqueConstraint('user_id', 'org_id', name='uq_user_org'),)

#     def serialize(self):
#         return {
#             'id': self.id,
#             'user_id': self.user_id,
#             'org_id': self.org_id,
#             'org_role': self.org_role,
#             'is_default': self.is_default,
#         }
