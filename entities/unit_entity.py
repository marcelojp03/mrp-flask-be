# entities/unit_entity.py
from models.unit import Unit


class UnitEntity:
    def get_by_code(self, code):
        if code is None:
            return None
        u = Unit.query.filter_by(code=code).first()
        return u.serialize() if u else None

    def get_by_description(self, desc):
        if desc is None:
            return None
        u = Unit.query.filter_by(description=desc).first()
        return u.serialize() if u else None
