# services/saas_guard_service.py
from myapp import db
from sqlalchemy import func
from models.user import User
from models.product import Product
from models.warehouse import Warehouse
from models.movement import Movement
from services.subscription_service import SubscriptionService

class SaasGuardService:
    def __init__(self):
        self.subs = SubscriptionService()

    def _check_limit(self, used: int, limit_value: int, label: str):
        if limit_value is None:
            return  # sin límite
        if used >= limit_value:
            raise ValueError(f"Límite de {label} alcanzado ({used}/{limit_value}). Mejora tu plan.")

    def assert_can_add_user(self, org_id: int):
        # Usuario por org: si aún no tienes multi-org en user, puedes omitir y validar por total
        used = db.session.query(func.count(User.id)).scalar()
        limits = self.subs.get_effective_limits(org_id)
        self._check_limit(used, limits['max_users'], 'usuarios')

    def assert_can_add_product(self, org_id: int):
        used = db.session.query(func.count(Product.id)).filter(Product.org_id == org_id, Product.status == True).scalar()
        limits = self.subs.get_effective_limits(org_id)
        self._check_limit(used, limits['max_products'], 'productos')

    def assert_can_add_warehouse(self, org_id: int):
        used = db.session.query(func.count(Warehouse.id)).filter(Warehouse.org_id == org_id).scalar()
        limits = self.subs.get_effective_limits(org_id)
        self._check_limit(used, limits['max_warehouses'], 'almacenes')

    def assert_can_register_movement_today(self, org_id: int):
        # Contar movimientos del día (UTC simple)
        from datetime import datetime, timedelta
        today = datetime.utcnow().date()
        start = datetime(today.year, today.month, today.day)
        end = start + timedelta(days=1)

        used = (db.session.query(func.count(Movement.id))
                .filter(Movement.org_id == org_id, Movement.created_at >= start, Movement.created_at < end)
                .scalar())
        limits = self.subs.get_effective_limits(org_id)
        self._check_limit(used, limits['max_movements_per_day'], 'movimientos por día')
