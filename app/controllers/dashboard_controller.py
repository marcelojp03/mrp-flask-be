from flask import Blueprint, jsonify, g
from app.responses import Responses
from app.models.product import Product
from app.models.movement import Movement
from app.models.work_order import WorkOrder
from app.services.stock_service import StockService
from sqlalchemy import func
from datetime import datetime, timedelta
from app.db import db
from auth.decorators import auth_required

dashboard_bp = Blueprint('dashboard', __name__, url_prefix='/api/dashboard')
stock = StockService()

def _get_ctx():
    # adapta a tu middleware/JWT: g.org_id, g.roles, g.user_id
    org_id = getattr(g, 'org_id', 1)
    roles = getattr(g, 'roles', [])
    user_id = getattr(g, 'user_id', None)
    return org_id, roles, user_id

@dashboard_bp.route('/kpis', methods=['GET'])
@auth_required
def kpis(org_id, user_id):
    roles = getattr(g, 'roles', [])

    total_products = db.session.query(func.count(Product.id)).filter_by(org_id=org_id, status=True).scalar()

    # low stock (simple)
    low = 0
    for p in Product.query.filter_by(org_id=org_id, status=True).all():
        if p.min_stock and stock.stock_by_product(p.id) < float(p.min_stock):
            low += 1

    # movimientos de hoy
    today = datetime.utcnow().date()
    start = datetime(today.year, today.month, today.day)
    end = start + timedelta(days=1)
    movements_today = (db.session.query(func.count(Movement.id))
                       .filter(Movement.org_id == org_id,
                               Movement.created_at >= start,
                               Movement.created_at < end)
                       .scalar())

    # S3 - KPIs de Producción (Work Orders)
    work_orders_active = (db.session.query(func.count(WorkOrder.id))
                          .filter(WorkOrder.org_id == org_id,
                                  WorkOrder.status == WorkOrder.STATUS_IN_PROGRESS)
                          .scalar())
    
    work_orders_finished_today = (db.session.query(func.count(WorkOrder.id))
                                  .filter(WorkOrder.org_id == org_id,
                                          WorkOrder.status == WorkOrder.STATUS_FINISHED,
                                          WorkOrder.actual_end >= start,
                                          WorkOrder.actual_end < end)
                                  .scalar())
    
    # Materiales consumidos hoy (movimientos OUT con referencia WO)
    materials_consumed_today = (db.session.query(func.sum(Movement.quantity))
                                .filter(Movement.org_id == org_id,
                                        Movement.movement_type == 'OUT',
                                        Movement.reference_type == 'WO',
                                        Movement.created_at >= start,
                                        Movement.created_at < end)
                                .scalar()) or 0

    # mock de cumplimiento (S1–S2)
    kpis = {
        'total_products': total_products,
        'low_stock_count': low,
        'movements_today': movements_today,
        'work_orders_active': work_orders_active,
        'work_orders_finished_today': work_orders_finished_today,
        'materials_consumed_today': float(materials_consumed_today),
        'plan_adherence': 0.92  # mock; reemplaza en S4 con MPS/MRP real
    }

    # ejemplo de filtrado por rol: si no es Planner, ocultar ciertos KPIs
    if 'Planner' not in roles:
        kpis.pop('plan_adherence', None)

    return Responses.success(kpis)

@dashboard_bp.route('/alerts', methods=['GET'])
@auth_required
def alerts(org_id, user_id):
    roles = getattr(g, 'roles', [])
    # mock básico; en S3 puedes generar desde reglas reales
    data = [
        {'type': 'LOW_STOCK', 'message': 'SKU FG-001 por debajo de min_stock', 'severity': 'warning'},
        {'type': 'INFO', 'message': '3 movimientos registrados hoy', 'severity': 'info'},
    ]
    # si no es Supervisor/Admin, podrías reducir verbosidad
    return Responses.success(data)


# ========== Sprint 5: Advanced Dashboard Endpoints ==========

@dashboard_bp.route('/planning', methods=['GET'])
@auth_required
def planning_kpis(org_id, user_id):
    """
    GET /api/dashboard/planning
    KPIs de planificación (Demand, MPS, MRP)
    
    Response:
    {
        "demand": {
            "total_confirmed": 150,
            "total_draft": 25,
            "periods_covered": 3
        },
        "mps": {
            "plans_published": 45,
            "plans_draft": 12,
            "total_planned_qty": 5000.50
        },
        "mrp": {
            "proposals_pending": 30,
            "proposals_approved": 15,
            "proposals_buy": 20,
            "proposals_make": 10,
            "total_estimated_cost": 125000.00
        }
    }
    """
    try:
        from app.models.demand import Demand
        from app.models.mps_plan import MPSPlan
        from app.models.mrp_proposal import MRPProposal
        
        # Demand KPIs
        demand_confirmed = Demand.query.filter_by(org_id=org_id, status='confirmed').count()
        demand_draft = Demand.query.filter_by(org_id=org_id, status='draft').count()
        demand_periods = db.session.query(func.count(func.distinct(Demand.period))).filter_by(org_id=org_id, status='confirmed').scalar()
        
        # MPS KPIs
        mps_published = MPSPlan.query.filter_by(org_id=org_id, status='published').count()
        mps_draft = MPSPlan.query.filter_by(org_id=org_id, status='draft').count()
        mps_total_qty = db.session.query(func.sum(MPSPlan.planned_qty)).filter_by(org_id=org_id, status='published').scalar() or 0
        
        # MRP KPIs
        mrp_pending = MRPProposal.query.filter_by(org_id=org_id, status='proposed').count()
        mrp_approved = MRPProposal.query.filter_by(org_id=org_id, status='approved').count()
        mrp_buy = MRPProposal.query.filter_by(org_id=org_id, type='BUY').filter(MRPProposal.status.in_(['proposed', 'approved'])).count()
        mrp_make = MRPProposal.query.filter_by(org_id=org_id, type='MAKE').filter(MRPProposal.status.in_(['proposed', 'approved'])).count()
        mrp_cost = db.session.query(func.sum(MRPProposal.estimated_cost)).filter_by(org_id=org_id).filter(MRPProposal.status.in_(['proposed', 'approved'])).scalar() or 0
        
        data = {
            'demand': {
                'total_confirmed': demand_confirmed,
                'total_draft': demand_draft,
                'periods_covered': demand_periods or 0
            },
            'mps': {
                'plans_published': mps_published,
                'plans_draft': mps_draft,
                'total_planned_qty': float(mps_total_qty)
            },
            'mrp': {
                'proposals_pending': mrp_pending,
                'proposals_approved': mrp_approved,
                'proposals_buy': mrp_buy,
                'proposals_make': mrp_make,
                'total_estimated_cost': float(mrp_cost)
            }
        }
        
        return Responses.success(data)
    
    except Exception as e:
        return Responses.error(str(e), 500)


@dashboard_bp.route('/forecast-summary', methods=['GET'])
@auth_required
def forecast_summary(org_id, user_id):
    """
    GET /api/dashboard/forecast-summary
    Resumen de pronósticos AI
    
    Response:
    {
        "total_forecasts": 50,
        "by_status": {
            "draft": 30,
            "published": 20
        },
        "by_method": {
            "ai": 45,
            "manual": 5
        },
        "avg_confidence": 82.5,
        "products_forecasted": 15,
        "periods_covered": 3
    }
    """
    try:
        from app.models.forecast import Forecast
        
        total = Forecast.query.filter_by(org_id=org_id).count()
        
        # Por status
        by_status = db.session.query(
            Forecast.status,
            func.count(Forecast.id)
        ).filter_by(org_id=org_id).group_by(Forecast.status).all()
        
        # Por método
        by_method = db.session.query(
            Forecast.method,
            func.count(Forecast.id)
        ).filter_by(org_id=org_id).group_by(Forecast.method).all()
        
        # Confianza promedio
        avg_conf = db.session.query(func.avg(Forecast.confidence_score)).filter_by(org_id=org_id).scalar() or 0
        
        # Productos con pronóstico
        products_count = db.session.query(func.count(func.distinct(Forecast.product_id))).filter_by(org_id=org_id).scalar()
        
        # Periodos cubiertos
        periods_count = db.session.query(func.count(func.distinct(Forecast.period))).filter_by(org_id=org_id).scalar()
        
        data = {
            'total_forecasts': total,
            'by_status': {status: count for status, count in by_status},
            'by_method': {method: count for method, count in by_method},
            'avg_confidence': float(avg_conf),
            'products_forecasted': products_count or 0,
            'periods_covered': periods_count or 0
        }
        
        return Responses.success(data)
    
    except Exception as e:
        return Responses.error(str(e), 500)


@dashboard_bp.route('/alerts-summary', methods=['GET'])
@auth_required
def alerts_summary(org_id, user_id):
    """
    GET /api/dashboard/alerts-summary
    Resumen de alertas del sistema
    
    Response:
    {
        "total_unread": 15,
        "by_severity": {
            "critical": 3,
            "warning": 8,
            "info": 4
        },
        "by_type": {
            "low_stock": 5,
            "wo_delay": 3,
            "mrp_pending": 7
        },
        "recent_alerts": [...]
    }
    """
    try:
        from app.services.alert_service import AlertService
        alert_service = AlertService()
        
        # Usar el método de resumen del servicio
        summary = alert_service.get_summary(org_id)
        
        # Obtener alertas recientes (últimas 5)
        recent = alert_service.list(org_id, is_read=False, limit=5)
        
        summary['recent_alerts'] = recent
        
        return Responses.success(summary)
    
    except Exception as e:
        return Responses.error(str(e), 500)
