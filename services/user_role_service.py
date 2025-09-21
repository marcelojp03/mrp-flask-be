from typing import Optional, List
from myapp import db
from models.user_role import UserRole
from models.user import User
from models.role import Role

class UserRoleService:
    def list(self) -> List[dict]:
        return [ur.serialize() for ur in UserRole.query.all()]

    def by_user(self, user_id: int) -> List[dict]:
        return [ur.serialize() for ur in UserRole.query.filter_by(user_id=user_id).all()]

    def assign(self, role_id: int, user_id: int) -> dict:
        if not Role.query.get(role_id):
            raise ValueError("role_id inválido")
        if not User.query.get(user_id):
            raise ValueError("user_id inválido")

        exists = UserRole.query.filter_by(role_id=role_id, user_id=user_id).first()
        if exists:
            return exists.serialize()

        ur = UserRole(role_id=role_id, user_id=user_id)
        db.session.add(ur)
        db.session.commit()
        return ur.serialize()

    def upsert(self, role_id: int, user_id: int) -> dict:
        # si el user ya tiene otro rol, lo reemplaza (política S1 simple)
        UserRole.query.filter_by(user_id=user_id).delete()
        db.session.add(UserRole(role_id=role_id, user_id=user_id))
        db.session.commit()
        return {'role_id': role_id, 'user_id': user_id}

    def unassign(self, role_id: int, user_id: int) -> bool:
        ur = UserRole.query.filter_by(role_id=role_id, user_id=user_id).first()
        if not ur: return False
        db.session.delete(ur)
        db.session.commit()
        return True
