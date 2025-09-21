from decimal import Decimal

from myapp import db
from models.movement import Movement
from models.product import Product
from models.product_warehouse import ProductWarehouse


class MovementEntity:
    def _ensure_stock_row(self, product_id, warehouse_id):
        stock = ProductWarehouse.query.filter_by(product_id=product_id, warehouse_id=warehouse_id).first()
        if not stock:
            stock = ProductWarehouse(product_id=product_id, warehouse_id=warehouse_id, current_stock=0)
            db.session.add(stock)
            db.session.flush()
        return stock

    def _adjust_stock(self, product_id, warehouse_id, delta):
        stock = self._ensure_stock_row(product_id, warehouse_id)
        current = Decimal(str(stock.current_stock or 0))
        stock.current_stock = current + Decimal(str(delta))
        db.session.flush()
        return stock.current_stock

    def create(self, payload, user_id):
        quantity = payload.get('quantity')
        if quantity is None:
            raise ValueError('quantity is required')

        quantity = Decimal(str(quantity))
        if quantity == 0:
            raise ValueError('quantity cannot be 0')

        product_id = payload.get('product_id')
        movement_type = payload.get('movement_type') or payload.get('type')
        reason = payload.get('reason')

        if not all([product_id, movement_type, reason]):
            raise ValueError('product_id, movement_type and reason are required')

        product = Product.query.get(product_id)
        if not product:
            raise ValueError('Product not found')

        movement_data = {
            'org_id': payload.get('org_id', 1),
            'product_id': product_id,
            'from_warehouse_id': payload.get('from_warehouse_id'),
            'to_warehouse_id': payload.get('to_warehouse_id'),
            'movement_type': movement_type,
            'reason': reason,
            'quantity': quantity,
            'reference_id': payload.get('reference_id'),
            'reference_type': payload.get('reference_type'),
            'note': payload.get('note'),
            'created_by': user_id,
        }

        movement = Movement(**movement_data)
        db.session.add(movement)

        if movement_type == 'IN':
            to_wh = movement.to_warehouse_id
            if not to_wh:
                raise ValueError('to_warehouse_id required for IN')
            self._adjust_stock(product_id, to_wh, abs(quantity))
        elif movement_type == 'OUT':
            from_wh = movement.from_warehouse_id
            if not from_wh:
                raise ValueError('from_warehouse_id required for OUT')
            self._adjust_stock(product_id, from_wh, -abs(quantity))
        elif movement_type == 'TRANSFER':
            from_wh = movement.from_warehouse_id
            to_wh = movement.to_warehouse_id
            if not from_wh or not to_wh:
                raise ValueError('from_warehouse_id and to_warehouse_id required for TRANSFER')
            self._adjust_stock(product_id, from_wh, -abs(quantity))
            self._adjust_stock(product_id, to_wh, abs(quantity))
        elif movement_type == 'ADJUST':
            target_wh = movement.to_warehouse_id or movement.from_warehouse_id
            if not target_wh:
                raise ValueError('warehouse required for ADJUST')
            self._adjust_stock(product_id, target_wh, quantity)
        else:
            raise ValueError('movement_type inválido')

        db.session.commit()
        return movement.serialize()
