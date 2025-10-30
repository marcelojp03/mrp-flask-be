# services/supplier_item_service.py
from typing import Optional, List
from app.db import db
from models.supplier_item import SupplierItem

class SupplierItemService:
    def list(self, product_id: int = None, supplier_id: int = None, org_id: int = None) -> List[dict]:
        q = SupplierItem.query
        if product_id is not None: q = q.filter_by(product_id=product_id)
        if supplier_id is not None: q = q.filter_by(supplier_id=supplier_id)
        if org_id is not None: q = q.filter_by(org_id=org_id)
        return [r.serialize() for r in q.all()]

    def get(self, supplier_item_id: int) -> Optional[dict]:
        si = SupplierItem.query.get(supplier_item_id)
        return si.serialize() if si else None

    def create(self, org_id: int, product_id: int, supplier_id: int,
               price=None, currency=None, lead_time_days: int = None,
               min_order_qty=None, pack_size=None, is_preferred: bool = False,
               is_active: bool = True) -> dict:
        si = SupplierItem(
            org_id=org_id, product_id=product_id, supplier_id=supplier_id,
            price=price, currency=currency, lead_time_days=lead_time_days,
            min_order_qty=min_order_qty, pack_size=pack_size,
            is_preferred=is_preferred, is_active=is_active
        )
        db.session.add(si)
        db.session.commit()
        return si.serialize()

    def update(self, supplier_item_id: int, **kwargs) -> Optional[dict]:
        si = SupplierItem.query.get(supplier_item_id)
        if not si: return None
        for k, v in kwargs.items():
            setattr(si, k, v)
        db.session.commit()
        return si.serialize()

    def delete(self, supplier_item_id: int) -> bool:
        si = SupplierItem.query.get(supplier_item_id)
        if not si: return False
        db.session.delete(si)
        db.session.commit()
        return True
