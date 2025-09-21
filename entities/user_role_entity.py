# entities/user_role_entity.py
from models.user_role import UserRole
from myapp import db


class UserRoleEntity:
    def get_all(self):
        user_roles = UserRole.query.all()
        return [user_role.serialize() for user_role in user_roles]

    def get_by_id(self, role_id, user_id):
        user_role = UserRole.query.filter_by(role_id=role_id, user_id=user_id).first()
        return user_role.serialize() if user_role else None

    def get_by_user_id(self, user_id):
        user_roles = UserRole.query.filter_by(user_id=user_id).all()
        return [user_role.serialize() for user_role in user_roles]

    def create(self, role_id, user_id):
        user_role = UserRole(role_id=role_id, user_id=user_id)
        db.session.add(user_role)
        db.session.commit()
        return user_role.serialize()

    def update(self, role_id, user_id):
        user_role = UserRole.query.filter_by(user_id=user_id).first()
        if user_role:
            user_role.role_id = role_id
        else:
            user_role = UserRole(role_id=role_id, user_id=user_id)
            db.session.add(user_role)
        db.session.commit()
        return user_role.serialize()
