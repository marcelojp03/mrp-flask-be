from flask import Blueprint, jsonify, g
from app.responses import Responses
from models.product import Product
from models.movement import Movement
from services.stock_service import StockService
from sqlalchemy import func
from datetime import datetime, timedelta
from myapp import db

dashboard_bp = Blueprint('dashboard', __name__, url_prefix='/api/dashboard')
stock = StockService()

def _get_ctx():
    # adapta a tu middleware/JWT: g.org_id, g.roles, g.user_id
    org_id = getattr(g, 'org_id', 1)
    roles = getattr(g, 'roles', [])
    user_id = getattr(g, 'user_id', None)
    return org_id, roles, user_id

@dashboard_bp.route('/kpis', methods=['GET'])
def kpis():
    org_id, roles, _ = _get_ctx()

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

    # mock de cumplimiento (S1–S2)
    kpis = {
        'total_products': total_products,
        'low_stock_count': low,
        'movements_today': movements_today,
        'plan_adherence': 0.92  # mock; reemplaza en S3–S4
    }

    # ejemplo de filtrado por rol: si no es Planner, ocultar ciertos KPIs
    if 'Planner' not in roles:
        kpis.pop('plan_adherence', None)

    return jsonify(Responses.success(kpis))

@dashboard_bp.route('/alerts', methods=['GET'])
def alerts():
    org_id, roles, _ = _get_ctx()
    # mock básico; en S3 puedes generar desde reglas reales
    data = [
        {'type': 'LOW_STOCK', 'message': 'SKU FG-001 por debajo de min_stock', 'severity': 'warning'},
        {'type': 'INFO', 'message': '3 movimientos registrados hoy', 'severity': 'info'},
    ]
    # si no es Supervisor/Admin, podrías reducir verbosidad
    return jsonify(Responses.success(data))
