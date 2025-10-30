# services/movement_service.py
from typing import Optional, List
from decimal import Decimal
from app.db import db
from models.movement import Movement
from models.product_warehouse import ProductWarehouse

class MovementService:
    def list(
        self,
        org_id: Optional[int] = None,
        product_id: Optional[int] = None,
        from_warehouse_id: Optional[int] = None,
        to_warehouse_id: Optional[int] = None,
        movement_type: Optional[str] = None,
        reason: Optional[str] = None,
    ) -> List[dict]:
        q = Movement.query
        if org_id is not None:
            q = q.filter_by(org_id=org_id)
        if product_id is not None:
            q = q.filter_by(product_id=product_id)
        if from_warehouse_id is not None:
            q = q.filter_by(from_warehouse_id=from_warehouse_id)
        if to_warehouse_id is not None:
            q = q.filter_by(to_warehouse_id=to_warehouse_id)
        if movement_type:
            q = q.filter_by(movement_type=movement_type)
        if reason:
            q = q.filter_by(reason=reason)
        q = q.order_by(Movement.created_at.desc(), Movement.id.desc())
        return [m.serialize() for m in q.all()]

    def create(self, org_id: int, product_id: int, movement_type: str, reason: str,
               quantity, created_by: int = None,
               from_warehouse_id: int = None, to_warehouse_id: int = None,
               reference_type: str = None, reference_id: str = None, note: str = None) -> dict:
        qty = Decimal(str(quantity))
        if qty <= 0:
            raise ValueError("quantity debe ser > 0")

        # Stock ops (todos con qty positiva)
        if movement_type == 'IN':
            if not to_warehouse_id:
                raise ValueError("to_warehouse_id requerido para IN")
            self._add_stock(product_id, to_warehouse_id, qty)

        elif movement_type == 'OUT':
            if not from_warehouse_id:
                raise ValueError("from_warehouse_id requerido para OUT")
            self._remove_stock(product_id, from_warehouse_id, qty)

        elif movement_type == 'TRANSFER':
            if not from_warehouse_id or not to_warehouse_id:
                raise ValueError("from_warehouse_id y to_warehouse_id requeridos para TRANSFER")
            self._remove_stock(product_id, from_warehouse_id, qty)
            self._add_stock(product_id, to_warehouse_id, qty)

        elif movement_type == 'ADJUST':
            # Mantén qty > 0 por el CheckConstraint en DB.
            # Usa to_warehouse para ajuste positivo y from_warehouse para ajuste negativo conceptual:
            # - Ajuste + : enviar to_warehouse_id
            # - Ajuste - : enviar from_warehouse_id
            if to_warehouse_id and not from_warehouse_id:
                self._add_stock(product_id, to_warehouse_id, qty)      # ajuste +
            elif from_warehouse_id and not to_warehouse_id:
                self._remove_stock(product_id, from_warehouse_id, qty)  # ajuste -
            else:
                raise ValueError("Para ADJUST usa solo to_warehouse_id (positivo) o solo from_warehouse_id (negativo)")
        else:
            raise ValueError("movement_type inválido")

        m = Movement(
            org_id=org_id, product_id=product_id,
            from_warehouse_id=from_warehouse_id, to_warehouse_id=to_warehouse_id,
            movement_type=movement_type, reason=reason, quantity=qty,
            reference_id=reference_id, reference_type=reference_type,
            note=note, created_by=created_by
        )
        db.session.add(m)
        db.session.commit()
        return m.serialize()

    def _add_stock(self, product_id: int, warehouse_id: int, qty: Decimal):
        row = ProductWarehouse.query.filter_by(product_id=product_id, warehouse_id=warehouse_id).first()
        if not row:
            row = ProductWarehouse(product_id=product_id, warehouse_id=warehouse_id, current_stock=Decimal('0'))
            db.session.add(row)
            db.session.flush()
        cur = Decimal(str(row.current_stock or 0))
        row.current_stock = cur + qty

    def _remove_stock(self, product_id: int, warehouse_id: int, qty: Decimal):
        row = ProductWarehouse.query.filter_by(product_id=product_id, warehouse_id=warehouse_id).first()
        if not row:
            raise ValueError("No hay stock en el almacén indicado")
        cur = Decimal(str(row.current_stock or 0))
        if cur < qty:
            raise ValueError("Stock insuficiente")
        row.current_stock = cur - qty
