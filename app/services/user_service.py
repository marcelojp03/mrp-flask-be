# services/user_service.py
from typing import List, Optional
from app.db import db
from app.models.user import User
from app.models.user_role import UserRole
from app.models.role import Role
from app.models.user_organization import UserOrganization
from werkzeug.security import generate_password_hash

class UserService:
    def list(self) -> List[dict]:
        return [u.serialize() for u in User.query.all()]
    
    def list_by_org(self, org_id: int) -> List[dict]:
        """Listar usuarios que pertenecen a una organización específica"""
        user_ids = db.session.query(UserOrganization.user_id)\
            .filter_by(org_id=org_id)\
            .all()
        user_ids = [uid[0] for uid in user_ids]
        
        users = User.query.filter(User.id.in_(user_ids)).all() if user_ids else []
        return [u.serialize() for u in users]

    def get(self, user_id: int) -> Optional[dict]:
        u = User.query.get(user_id)
        return u.serialize() if u else None

    def create(self, name: str, email: str, password: str, photo: str = None, role_ids: List[int] = None) -> dict:
        pwd = generate_password_hash(password) if password and not password.startswith('pbkdf2:') else password
        u = User(name=name, email=email, password=pwd, photo=photo, status=True)
        db.session.add(u)
        db.session.flush()  # para tener u.id

        if role_ids:
            roles = Role.query.filter(Role.id.in_(role_ids)).all()
            for r in roles:
                db.session.add(UserRole(user_id=u.id, role_id=r.id))

        db.session.commit()
        return u.serialize()

    def update(self, user_id: int, **kwargs) -> Optional[dict]:
        u: User = User.query.get(user_id)
        if not u: return None
        name = kwargs.get('name'); email = kwargs.get('email'); password = kwargs.get('password')
        photo = kwargs.get('photo'); status = kwargs.get('status'); role_ids = kwargs.get('role_ids')

        if name is not None: u.name = name
        if email is not None: u.email = email
        if photo is not None or photo == None: u.photo = photo
        if status is not None: u.status = status
        if password:
            u.password = generate_password_hash(password) if not password.startswith('pbkdf2:') else password

        if role_ids is not None:
            # reset y reasignar
            UserRole.query.filter_by(user_id=u.id).delete()
            if role_ids:
                roles = Role.query.filter(Role.id.in_(role_ids)).all()
                for r in roles:
                    db.session.add(UserRole(user_id=u.id, role_id=r.id))

        db.session.commit()
        return u.serialize()

    def delete_soft(self, user_id: int) -> Optional[dict]:
        u = User.query.get(user_id)
        if not u: return None
        u.status = False
        db.session.commit()
        return u.serialize()

    def delete_hard(self, user_id: int) -> bool:
        u = User.query.get(user_id)
        if not u: return False
        db.session.delete(u)
        db.session.commit()
        return True
