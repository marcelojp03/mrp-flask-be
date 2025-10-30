from flask import Blueprint, g
from app.responses import Responses
from auth.decorators import auth_required
from models.organization import Organization
from models.org_subscription import OrgSubscription
from models.plan import Plan
from models.product import Product
from models.warehouse import Warehouse
from models.movement import Movement
from sqlalchemy import func
from datetime import datetime, date
from app.db import db

subscription_bp = Blueprint('subscription', __name__, url_prefix='/api/subscription')

@subscription_bp.route('', methods=['GET'])
@auth_required
def get_subscription():
    """
    Obtener información de la suscripción de la organización actual
    Incluye: plan, límites, uso actual, días restantes de trial
    """
    org_id = g.org_id
    
    # Obtener organización
    org = Organization.query.get(org_id)
    if not org:
        return Responses.error("Organización no encontrada", http_code=404)
    
    # Obtener suscripción activa
    subscription = OrgSubscription.query.filter_by(
        org_id=org_id,
        status='active'
    ).first()
    
    if not subscription:
        return Responses.error("No hay suscripción activa", http_code=404)
    
    # Obtener plan
    plan = Plan.query.get(subscription.plan_id)
    if not plan:
        return Responses.error("Plan no encontrado", http_code=404)
    
    # Calcular uso actual
    total_products = Product.query.filter_by(org_id=org_id, status=True).count()
    total_warehouses = Warehouse.query.filter_by(org_id=org_id).count()
    
    # Movimientos de hoy
    today = date.today()
    start = datetime(today.year, today.month, today.day)
    movements_today = Movement.query.filter(
        Movement.org_id == org_id,
        Movement.created_at >= start
    ).count()
    
    # Calcular días restantes de trial
    trial_days_remaining = None
    if subscription.trial_until:
        delta = subscription.trial_until.date() - today
        trial_days_remaining = max(0, delta.days)
    
    # Verificar si está en trial
    is_trial = subscription.trial_until and subscription.trial_until.date() >= today
    
    result = {
        'organization': {
            'id': org.id,
            'name': org.name,
            'code': org.code
        },
        'subscription': {
            'id': subscription.id,
            'status': subscription.status,
            'started_at': subscription.started_at.isoformat() if subscription.started_at else None,
            'trial_until': subscription.trial_until.isoformat() if subscription.trial_until else None,
            'is_trial': is_trial,
            'trial_days_remaining': trial_days_remaining
        },
        'plan': {
            'id': plan.id,
            'code': plan.code,
            'name': plan.name,
            'is_active': plan.is_active,
            'limits': {
                'max_products': plan.max_products,
                'max_warehouses': plan.max_warehouses,
                'max_users': plan.max_users,
                'max_movements_per_day': plan.max_movements_per_day,
                'max_ai_reports_per_day': plan.max_ai_reports_per_day,
            },
            'features': {
                'allow_bom': plan.allow_bom,
                'allow_work_orders': plan.allow_work_orders,
                'allow_mrp': plan.allow_mrp,
                'allow_forecast': plan.allow_forecast,
            }
        },
        'usage': {
            'products': {
                'current': total_products,
                'limit': plan.max_products,
                'percentage': round((total_products / plan.max_products * 100), 2) if plan.max_products else 0
            },
            'warehouses': {
                'current': total_warehouses,
                'limit': plan.max_warehouses,
                'percentage': round((total_warehouses / plan.max_warehouses * 100), 2) if plan.max_warehouses else 0
            },
            'movements_today': {
                'current': movements_today,
                'limit': plan.max_movements_per_day,
                'percentage': round((movements_today / plan.max_movements_per_day * 100), 2) if plan.max_movements_per_day else 0
            }
        }
    }
    
    return Responses.success(result, message="Información de suscripción")
