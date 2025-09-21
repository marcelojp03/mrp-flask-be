# services/warehouse_service.py
from typing import Optional, List
from myapp import db
from models.warehouse import Warehouse

class WarehouseService:
    def list(self) -> List[dict]:
        return [w.serialize() for w in Warehouse.query.all()]

    def get(self, warehouse_id: int) -> Optional[dict]:
        w = Warehouse.query.get(warehouse_id)
        return w.serialize() if w else None

    def create(self, name: str, location: str = None, org_id: int = 1) -> dict:
        w = Warehouse(name=name, location=location, org_id=org_id)
        db.session.add(w)
        db.session.commit()
        return w.serialize()

    def update(self, warehouse_id: int, **kwargs) -> Optional[dict]:
        w = Warehouse.query.get(warehouse_id)
        if not w: return None
        for k in ('name','location','org_id'):
            if k in kwargs:
                setattr(w, k, kwargs[k])
        db.session.commit()
        return w.serialize()

    def delete(self, warehouse_id: int) -> bool:
        w = Warehouse.query.get(warehouse_id)
        if not w: return False
        db.session.delete(w)
        db.session.commit()
        return True
