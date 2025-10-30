# services/supplier_service.py
from typing import Optional, List
from app.db import db
from app.models.supplier import Supplier

class SupplierService:
    def list(self, org_id: int = None, only_active: bool = False) -> List[dict]:
        q = Supplier.query
        if org_id is not None: q = q.filter_by(org_id=org_id)
        if only_active: q = q.filter_by(status=True)
        return [s.serialize() for s in q.all()]

    def get(self, supplier_id: int, org_id: int = None) -> Optional[dict]:
        s = Supplier.query.get(supplier_id)
        if not s:
            return None
        # Validar que pertenece a la org
        if org_id is not None and s.org_id != org_id:
            return None
        return s.serialize()

    def create(self, org_id: int, name: str, **kwargs) -> dict:
        # Ignorar org_id del body si viene
        kwargs.pop('org_id', None)
        s = Supplier(name=name, org_id=org_id, status=True, **{k: v for k, v in kwargs.items() if v is not None})
        db.session.add(s)
        db.session.commit()
        return s.serialize()

    def update(self, supplier_id: int, org_id: int = None, **kwargs) -> Optional[dict]:
        s = Supplier.query.get(supplier_id)
        if not s:
            return None
        # Validar que pertenece a la org
        if org_id is not None and s.org_id != org_id:
            return None
        # Prevenir cambio de org_id
        kwargs.pop('org_id', None)
        for k, v in kwargs.items():
            setattr(s, k, v)
        db.session.commit()
        return s.serialize()

    def delete(self, supplier_id: int, org_id: int = None) -> bool:
        s = Supplier.query.get(supplier_id)
        if not s:
            return False
        # Validar que pertenece a la org
        if org_id is not None and s.org_id != org_id:
            return False
        s.status = False
        db.session.commit()
        return True
