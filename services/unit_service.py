from typing import Optional, List
from myapp import db
from models.unit import Unit

class UnitService:
    def list(self) -> List[dict]:
        return [u.serialize() for u in Unit.query.all()]

    def get(self, unit_id: int) -> Optional[dict]:
        u = Unit.query.get(unit_id)
        return u.serialize() if u else None

    def create(self, data: dict) -> dict:
        code = data.get('code')
        description = data.get('description')
        if not code:
            raise ValueError("code es obligatorio")
        u = Unit(code=code, description=description)
        db.session.add(u)
        db.session.commit()
        return u.serialize()

    def update(self, unit_id: int, data: dict) -> Optional[dict]:
        u = Unit.query.get(unit_id)
        if not u:
            return None
        if 'code' in data: u.code = data['code']
        if 'description' in data: u.description = data['description']
        db.session.commit()
        return u.serialize()

    def delete(self, unit_id: int) -> bool:
        u = Unit.query.get(unit_id)
        if not u: return False
        db.session.delete(u)
        db.session.commit()
        return True
