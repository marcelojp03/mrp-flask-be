# services/movement_service.py
from typing import Optional, List
from decimal import Decimal
from myapp import db
from models.movement import Movement
from models.product_warehouse import ProductWarehouse

class MovementService:
    def list(self) -> List[dict]:
        return [m.serialize() for m in Movement.query.order_by(Movement.created_at.desc()).all()]

    def create(self, org_id: int, product_id: int, movement_type: str, reason: str,
               quantity, created_by: int = None,
               from_warehouse_id: int = None, to_warehouse_id: int = None,
               reference_type: str = None, reference_id: str = None, note: str = None) -> dict:
        qty = Decimal(str(quantity))
        if qty <= 0:
            raise ValueError("quantity debe ser > 0")

        # Aplica movimiento
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
            # Ajuste positivo: usar to_warehouse; negativo: usar from_warehouse
            if qty > 0:
                if not to_warehouse_id: raise ValueError("to_warehouse_id requerido para ADJUST (+)")
                self._add_stock(product_id, to_warehouse_id, qty)
            else:
                if not from_warehouse_id: raise ValueError("from_warehouse_id requerido para ADJUST (-)")
                self._remove_stock(product_id, from_warehouse_id, -qty)
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
            row = ProductWarehouse(product_id=product_id, warehouse_id=warehouse_id, current_stock=0)
            db.session.add(row)
            db.session.flush()
        row.current_stock = (row.current_stock or 0) + qty

    def _remove_stock(self, product_id: int, warehouse_id: int, qty: Decimal):
        row = ProductWarehouse.query.filter_by(product_id=product_id, warehouse_id=warehouse_id).first()
        if not row:
            raise ValueError("No hay stock en el almacén indicado")
        cur = row.current_stock or 0
        if cur < qty:
            # permite negativo? en S1: no
            raise ValueError("Stock insuficiente")
        row.current_stock = cur - qty
