from myapp import db
from models.product_warehouse import ProductWarehouse
from models.movement import Movement
from models.product import Product


class InventoryEntity:
    def _get_stock(self, product_id, warehouse_id):
        st = ProductWarehouse.query.filter_by(product_id=product_id, warehouse_id=warehouse_id).first()
        if not st:
            st = ProductWarehouse(product_id=product_id, warehouse_id=warehouse_id, current_stock=0)
            db.session.add(st)
        return st

    def _sum_stock(self, product_id, warehouse_id, delta):
        st = self._get_stock(product_id, warehouse_id)
        st.current_stock = (st.current_stock or 0) + delta
        db.session.flush()
        return float(st.current_stock or 0)

    def apply_movement(self, payload, user_id):
        qty = payload.get("quantity")
        if qty is None or float(qty) == 0.0:
            raise ValueError("quantity cannot be 0")

        movement = Movement(created_by=user_id, **payload)
        db.session.add(movement)

        product = Product.query.get(payload.get("product_id"))
        if not product:
            raise ValueError("Product not found")

        if movement.type == 'IN':
            if not movement.to_warehouse_id:
                raise ValueError("to_warehouse_id required for IN")
            self._sum_stock(movement.product_id, movement.to_warehouse_id, abs(qty))
        elif movement.type == 'OUT':
            if not movement.from_warehouse_id:
                raise ValueError("from_warehouse_id required for OUT")
            self._sum_stock(movement.product_id, movement.from_warehouse_id, -abs(qty))
        elif movement.type == 'TRANSFER':
            if not (movement.from_warehouse_id and movement.to_warehouse_id):
                raise ValueError("from_warehouse_id and to_warehouse_id required for TRANSFER")
            self._sum_stock(movement.product_id, movement.from_warehouse_id, -abs(qty))
            self._sum_stock(movement.product_id, movement.to_warehouse_id, abs(qty))
        elif movement.type == 'ADJUST':
            target = movement.to_warehouse_id or movement.from_warehouse_id
            if not target:
                raise ValueError("warehouse required for ADJUST")
            self._sum_stock(movement.product_id, target, qty)

        db.session.commit()
        return {"movement_id": movement.id}


