from datetime import datetime, timedelta
from app.db import db

class OrgSubscription(db.Model):
    __tablename__ = 'org_subscription'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    org_id = db.Column(db.Integer, db.ForeignKey('organization.id'), nullable=False, unique=True)
    plan_id = db.Column(db.Integer, db.ForeignKey('plan.id'), nullable=False)

    status = db.Column(db.Enum('active', 'canceled', 'past_due', name='subscription_status'), nullable=False, server_default='active')
    started_at = db.Column(db.TIMESTAMP, nullable=False, default=datetime.utcnow)
    trial_until = db.Column(db.TIMESTAMP, nullable=True)  # ej. now()+14d para “disimular” trial

    # Overrides opcionales por organización (si quieres cambiar límites del plan para un cliente)
    max_users_override = db.Column(db.Integer, nullable=True)
    max_products_override = db.Column(db.Integer, nullable=True)
    max_warehouses_override = db.Column(db.Integer, nullable=True)
    max_movements_per_day_override = db.Column(db.Integer, nullable=True)
    # TODO: Agregar max_ai_reports_per_day_override en migración

    plan = db.relationship('Plan', lazy=True)

    def serialize(self):
        return {
            'id': self.id, 'org_id': self.org_id, 'plan': self.plan.serialize() if self.plan else None,
            'status': self.status, 'started_at': self.started_at, 'trial_until': self.trial_until,
            'overrides': {
                'max_users': self.max_users_override,
                'max_products': self.max_products_override,
                'max_warehouses': self.max_warehouses_override,
                'max_movements_per_day': self.max_movements_per_day_override,
            }
        }

    # Helpers para obtener límites efectivos (override > plan)
    def effective_limits(self):
        p = self.plan
        return {
            'max_users': self.max_users_override if self.max_users_override is not None else (p.max_users if p else None),
            'max_products': self.max_products_override if self.max_products_override is not None else (p.max_products if p else None),
            'max_warehouses': self.max_warehouses_override if self.max_warehouses_override is not None else (p.max_warehouses if p else None),
            'max_movements_per_day': self.max_movements_per_day_override if self.max_movements_per_day_override is not None else (p.max_movements_per_day if p else None),
            'max_ai_reports_per_day': (p.max_ai_reports_per_day if p else None),  # Sin override por ahora
        }
