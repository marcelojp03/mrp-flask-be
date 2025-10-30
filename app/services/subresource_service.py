from typing import Optional, List
from app.db import db
from app.models.subresource import Subresource
from app.models.resource import Resource

class SubresourceService:
    def list(self, resource_id: int = None) -> List[dict]:
        q = Subresource.query
        if resource_id is not None:
            q = q.filter_by(resource_id=resource_id)
        return [s.serialize() for s in q.all()]

    def get(self, subresource_id: int) -> Optional[dict]:
        s = Subresource.query.get(subresource_id)
        return s.serialize() if s else None

    def create(self, data: dict) -> dict:
        resource_id = data.get('resource_id')
        name = data.get('name')
        if not resource_id or not name:
            raise ValueError("resource_id y name son obligatorios")
        if not Resource.query.get(resource_id):
            raise ValueError("resource_id inválido")

        s = Subresource(
            resource_id=resource_id, name=name,
            description=data.get('description'),
            url=data.get('url'), icon=data.get('icon')
        )
        db.session.add(s)
        db.session.commit()
        return s.serialize()

    def update(self, subresource_id: int, data: dict) -> Optional[dict]:
        s = Subresource.query.get(subresource_id)
        if not s: return None
        for k in ('resource_id','name','description','url','icon'):
            if k in data: setattr(s, k, data[k])
        db.session.commit()
        return s.serialize()

    def delete(self, subresource_id: int) -> bool:
        s = Subresource.query.get(subresource_id)
        if not s: return False
        db.session.delete(s)
        db.session.commit()
        return True
