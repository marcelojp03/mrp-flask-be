# services/user_org_service.py
from typing import List, Optional
from app.db import db
from app.models.user_organization import UserOrganization

class UserOrganizationService:
    def list_by_user(self, user_id: int) -> List[dict]:
        return [m.serialize() for m in UserOrganization.query.filter_by(user_id=user_id).all()]

    def get_default_org_id(self, user_id: int) -> Optional[int]:
        m = UserOrganization.query.filter_by(user_id=user_id, is_default=True).first()
        if m: return m.org_id
        m = UserOrganization.query.filter_by(user_id=user_id).first()
        return m.org_id if m else None

    def add_membership(self, user_id: int, org_id: int, make_default: bool = False) -> dict:
        # upsert simple
        m = UserOrganization.query.filter_by(user_id=user_id, org_id=org_id).first()
        if not m:
            m = UserOrganization(user_id=user_id, org_id=org_id, is_default=False)
            db.session.add(m)
        if make_default:
            # Quitar default previo del usuario
            UserOrganization.query.filter_by(user_id=user_id, is_default=True).update({'is_default': False})
            m.is_default = True
        db.session.commit()
        return m.serialize()

    def set_default(self, user_id: int, org_id: int) -> Optional[dict]:
        m = UserOrganization.query.filter_by(user_id=user_id, org_id=org_id).first()
        if not m: return None
        UserOrganization.query.filter_by(user_id=user_id, is_default=True).update({'is_default': False})
        m.is_default = True
        db.session.commit()
        return m.serialize()

    def remove_membership(self, user_id: int, org_id: int) -> bool:
        m = UserOrganization.query.filter_by(user_id=user_id, org_id=org_id).first()
        if not m: return False
        was_default = m.is_default
        db.session.delete(m)
        db.session.commit()
        # Si borraste el default, promueve cualquiera restante como default
        if was_default:
            any_left = UserOrganization.query.filter_by(user_id=user_id).first()
            if any_left:
                any_left.is_default = True
                db.session.commit()
        return True
