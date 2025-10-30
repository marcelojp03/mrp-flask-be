# services/warehouse_service.py
from typing import Optional, List
from app.db import db
from app.models.warehouse import Warehouse

class WarehouseService:
    def list(self, org_id: int = None) -> List[dict]:
        q = Warehouse.query
        if org_id is not None:
            q = q.filter_by(org_id=org_id)
        return [w.serialize() for w in q.all()]

    def get(self, warehouse_id: int, org_id: int = None) -> Optional[dict]:
        w = Warehouse.query.get(warehouse_id)
        if not w:
            return None
        # Validar que pertenece a la org
        if org_id is not None and w.org_id != org_id:
            return None
        return w.serialize()

    def create(self, org_id: int, name: str, location: str = None, **kwargs) -> dict:
        # Ignorar org_id del body si viene
        kwargs.pop('org_id', None)
        w = Warehouse(name=name, location=location, org_id=org_id)
        db.session.add(w)
        db.session.commit()
        return w.serialize()

    def update(self, warehouse_id: int, org_id: int = None, **kwargs) -> Optional[dict]:
        w = Warehouse.query.get(warehouse_id)
        if not w:
            return None
        # Validar que pertenece a la org
        if org_id is not None and w.org_id != org_id:
            return None
        # Prevenir cambio de org_id
        kwargs.pop('org_id', None)
        for k in ('name', 'location'):
            if k in kwargs:
                setattr(w, k, kwargs[k])
        db.session.commit()
        return w.serialize()

    def delete(self, warehouse_id: int, org_id: int = None) -> bool:
        w = Warehouse.query.get(warehouse_id)
        if not w:
            return False
        # Validar que pertenece a la org
        if org_id is not None and w.org_id != org_id:
            return False
        db.session.delete(w)
        db.session.commit()
        return True
