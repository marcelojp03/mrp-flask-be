# services/product_service.py
from typing import Optional, List
from myapp import db
from models.product import Product

class ProductService:
    def list(self, org_id: int = None, only_active: bool = False) -> List[dict]:
        q = Product.query
        if org_id is not None: q = q.filter_by(org_id=org_id)
        if only_active: q = q.filter_by(status=True)
        return [p.serialize() for p in q.all()]

    def get(self, product_id: int) -> Optional[dict]:
        p = Product.query.get(product_id)
        return p.serialize() if p else None

    def create(self, org_id: int, code: str, name: str, description: str = None,
               item_type: str = 'FG', procurement_type: str = 'BUY', min_stock=0,
               unit_id: int = None, status: bool = True) -> dict:
        # Validación simple S1
        tmp = Product(item_type=item_type)
        if tmp.requires_unit() and not unit_id:
            raise ValueError(f"unit_id es requerido para item_type '{item_type}'")
        if not tmp.is_stockable():
            unit_id = None

        p = Product(org_id=org_id, code=code, name=name, description=description,
                    item_type=item_type, procurement_type=procurement_type,
                    min_stock=min_stock, unit_id=unit_id, status=status)
        db.session.add(p)
        db.session.commit()
        return p.serialize()

    def update(self, product_id: int, **kwargs) -> Optional[dict]:
        p = Product.query.get(product_id)
        if not p: return None
        for k in ('org_id','code','name','description','min_stock','procurement_type','item_type','unit_id','status'):
            if k in kwargs:
                setattr(p, k, kwargs[k])

        if 'item_type' in kwargs or 'unit_id' in kwargs:
            if p.requires_unit() and not p.unit_id:
                raise ValueError(f"unit_id es requerido para item_type '{p.item_type}'")

        db.session.commit()
        return p.serialize()

    def delete_soft(self, product_id: int) -> Optional[dict]:
        p = Product.query.get(product_id)
        if not p: return None
        p.status = False
        db.session.commit()
        return p.serialize()

    def delete_hard(self, product_id: int) -> bool:
        p = Product.query.get(product_id)
        if not p: return False
        db.session.delete(p)
        db.session.commit()
        return True
