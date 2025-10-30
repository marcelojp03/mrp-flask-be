# services/organization_service.py
from typing import Optional, List
from app.db import db
from app.models.organization import Organization

class OrganizationService:
    def list(self) -> List[dict]:
        return [o.serialize() for o in Organization.query.all()]

    def get(self, org_id: int) -> Optional[dict]:
        o = Organization.query.get(org_id)
        return o.serialize() if o else None

    def create(self, name: str, code: str, is_active: bool = True) -> dict:
        o = Organization(name=name, code=code, is_active=is_active)
        db.session.add(o)
        db.session.commit()
        return o.serialize()

    def update(self, org_id: int, **kwargs) -> Optional[dict]:
        o = Organization.query.get(org_id)
        if not o: return None
        for k in ('name','code','is_active'):
            if k in kwargs:
                setattr(o, k, kwargs[k])
        db.session.commit()
        return o.serialize()
