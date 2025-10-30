from typing import List
from app.db import db
from app.models.role_resource import RoleResource
from app.models.role import Role
from app.models.resource import Resource
from app.models.subresource import Subresource

class RoleResourceService:
    def list(self, role_id: int = None) -> List[dict]:
        q = RoleResource.query
        if role_id is not None:
            q = q.filter_by(role_id=role_id)
        return [rr.serialize() for rr in q.all()]

    def assign(self, role_id: int, resource_id: int, subresource_id: int) -> dict:
        if not Role.query.get(role_id): raise ValueError("role_id inválido")
        if not Resource.query.get(resource_id): raise ValueError("resource_id inválido")
        if not Subresource.query.get(subresource_id): raise ValueError("subresource_id inválido")

        exists = RoleResource.query.filter_by(
            role_id=role_id, resource_id=resource_id, subresource_id=subresource_id
        ).first()
        if exists:
            return exists.serialize()

        rr = RoleResource(role_id=role_id, resource_id=resource_id, subresource_id=subresource_id)
        db.session.add(rr)
        db.session.commit()
        return rr.serialize()

    def unassign(self, role_id: int, resource_id: int, subresource_id: int) -> bool:
        rr = RoleResource.query.filter_by(
            role_id=role_id, resource_id=resource_id, subresource_id=subresource_id
        ).first()
        if not rr: return False
        db.session.delete(rr)
        db.session.commit()
        return True
