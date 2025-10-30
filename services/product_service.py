# services/product_service.py
from typing import Optional, List
from datetime import datetime
from app.db import db
from models.product import Product

class ProductService:
    def list(self, org_id: int = None, only_active: Optional[bool] = None) -> List[dict]:
        """
        - only_active is None  -> sin filtro por status (trae todos)
        - only_active is True  -> solo activos
        - only_active is False -> solo inactivos
        """
        q = Product.query
        if org_id is not None:
            q = q.filter_by(org_id=org_id)
        if only_active is True:
            q = q.filter_by(status=True)
        elif only_active is False:
            q = q.filter_by(status=False)
        return [p.serialize() for p in q.all()]

    def get(self, product_id: int, org_id: int = None) -> Optional[dict]:
        """Devuelve el producto si existe y pertenece a la org (si org_id es proporcionado)"""
        p = Product.query.get(product_id)
        if not p:
            return None
        # Validar que pertenece a la organización
        if org_id is not None and p.org_id != org_id:
            return None
        return p.serialize()

    def create(self, org_id: int, code: str, name: str, description: str = None,
               item_type: str = 'FG', procurement_type: str = 'BUY', min_stock=0,
               unit_id: int = None, status: bool = True) -> dict:
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

    def update(self, product_id: int, org_id: int = None, **kwargs) -> Optional[dict]:
        p = Product.query.get(product_id)
        if not p:
            return None
        # Validar que pertenece a la organización
        if org_id is not None and p.org_id != org_id:
            return None
            
        # No permitir cambiar org_id
        kwargs.pop('org_id', None)
        
        for k in ('code','name','description','min_stock','procurement_type','item_type','unit_id','status'):
            if k in kwargs:
                setattr(p, k, kwargs[k])

        if 'item_type' in kwargs or 'unit_id' in kwargs:
            if p.requires_unit() and not p.unit_id:
                raise ValueError(f"unit_id es requerido para item_type '{p.item_type}'")

        p.updated_at = datetime.utcnow()
        db.session.commit()
        return p.serialize()

    def delete_soft(self, product_id: int, org_id: int = None) -> bool:
        p = Product.query.get(product_id)
        if not p:
            return False
        # Validar que pertenece a la organización
        if org_id is not None and p.org_id != org_id:
            return False
        if not p.status:
            return True
        p.status = False
        p.updated_at = datetime.utcnow()
        db.session.commit()
        return True

    def reactivate(self, product_id: int, org_id: int = None) -> Optional[dict]:
        p = Product.query.get(product_id)
        if not p:
            return None
        # Validar que pertenece a la organización
        if org_id is not None and p.org_id != org_id:
            return None
        if p.status:
            return p.serialize()
        p.status = True
        p.updated_at = datetime.utcnow()
        db.session.commit()
        return p.serialize()
