# services/subscription_service.py
from datetime import datetime, timedelta
from app.db import db
from models.plan import Plan
from models.org_subscription import OrgSubscription

class SubscriptionService:
    def get_or_create_free(self, org_id: int, trial_days: int = 14):
        # Busca plan FREE
        free = Plan.query.filter_by(code='free', is_active=True).first()
        if not free:
            free = Plan(code='free', name='Free', is_active=True)
            db.session.add(free)
            db.session.commit()

        sub = OrgSubscription.query.filter_by(org_id=org_id).first()
        if sub:
            return sub.serialize()

        sub = OrgSubscription(
            org_id=org_id,
            plan_id=free.id,
            status='active',
            trial_until=(datetime.utcnow() + timedelta(days=trial_days)) if trial_days else None
        )
        db.session.add(sub)
        db.session.commit()
        return sub.serialize()

    def get_effective_limits(self, org_id: int):
        sub = OrgSubscription.query.filter_by(org_id=org_id).first()
        if not sub:
            return None
        return sub.effective_limits()

    def switch_plan(self, org_id: int, plan_code: str):
        plan = Plan.query.filter_by(code=plan_code, is_active=True).first()
        if not plan:
            raise ValueError("Plan inválido")
        sub = OrgSubscription.query.filter_by(org_id=org_id).first()
        if not sub:
            sub = OrgSubscription(org_id=org_id, plan_id=plan.id, status='active')
            db.session.add(sub)
        else:
            sub.plan_id = plan.id
            sub.status = 'active'
        db.session.commit()
        return sub.serialize()
