# services/supplier_service.py
from typing import Optional, List
from myapp import db
from models.supplier import Supplier

class SupplierService:
    def list(self, org_id: int = None, only_active: bool = False) -> List[dict]:
        q = Supplier.query
        if org_id is not None: q = q.filter_by(org_id=org_id)
        if only_active: q = q.filter_by(status=True)
        return [s.serialize() for s in q.all()]

    def get(self, supplier_id: int) -> Optional[dict]:
        s = Supplier.query.get(supplier_id)
        return s.serialize() if s else None

    def create(self, name: str, org_id: int = 1, **kwargs) -> dict:
        s = Supplier(name=name, org_id=org_id, status=True, **{k: v for k, v in kwargs.items() if v is not None})
        db.session.add(s)
        db.session.commit()
        return s.serialize()

    def update(self, supplier_id: int, **kwargs) -> Optional[dict]:
        s = Supplier.query.get(supplier_id)
        if not s: return None
        for k, v in kwargs.items():
            setattr(s, k, v)
        db.session.commit()
        return s.serialize()

    def delete(self, supplier_id: int) -> bool:
        s = Supplier.query.get(supplier_id)
        if not s: return False
        s.status = False
        db.session.commit()
        return True
