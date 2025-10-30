# services/role_service.py
from typing import Optional, List
from app.db import db
from models.role import Role

class RoleService:
    def list(self) -> List[dict]:
        return [r.serialize() for r in Role.query.all()]

    def get(self, role_id: int) -> Optional[dict]:
        r = Role.query.get(role_id)
        return r.serialize() if r else None

    def create(self, name: str, description: str = None, status: bool = True) -> dict:
        r = Role(name=name, description=description, status=status)
        db.session.add(r)
        db.session.commit()
        return r.serialize()

    def update(self, role_id: int, name: str = None, description: str = None, status: bool = None) -> Optional[dict]:
        r = Role.query.get(role_id)
        if not r: return None
        if name is not None: r.name = name
        if description is not None: r.description = description
        if status is not None: r.status = status
        db.session.commit()
        return r.serialize()

    def delete(self, role_id: int) -> bool:
        r = Role.query.get(role_id)
        if not r: return False
        db.session.delete(r)
        db.session.commit()
        return True
