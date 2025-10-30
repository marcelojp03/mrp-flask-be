from flask import Blueprint, request, g
from app.responses import Responses
from auth.decorators import auth_required
from app.services.stock_service import StockService

stocks_bp = Blueprint('stocks', __name__, url_prefix='/api/stocks')
svc = StockService()

@stocks_bp.route('', methods=['GET'])
@auth_required
def get_stock():
    org_id = g.org_id
    
    product_id = request.args.get('product_id', type=int)
    warehouse_id = request.args.get('warehouse_id', type=int)
    try:
        res = svc.get_stock(org_id=org_id, product_id=product_id, warehouse_id=warehouse_id)
        return Responses.success(res)
    except ValueError as ve:
        return Responses.error(str(ve), 422)

@stocks_bp.route('/low', methods=['GET'])
@auth_required
def low_stock():
    org_id = g.org_id
    
    items = svc.low_stock(org_id=org_id)
    return Responses.success(items)

@stocks_bp.route('/reorder-suggestions', methods=['GET'])
@auth_required
def reorder_suggestions():
    org_id = g.org_id
    
    res = svc.reorder_suggestions(org_id=org_id)
    return Responses.success(res)
