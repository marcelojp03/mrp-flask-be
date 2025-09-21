from flask import Blueprint, request
from app.responses import Responses
from services.stock_service import StockService

stocks_bp = Blueprint('stocks', __name__, url_prefix='/api/stocks')
svc = StockService()

@stocks_bp.route('', methods=['GET'])
def get_stock():
    product_id = request.args.get('product_id', type=int)
    warehouse_id = request.args.get('warehouse_id', type=int)
    try:
        res = svc.get_stock(product_id=product_id, warehouse_id=warehouse_id)
        return Responses.success(res)
    except ValueError as ve:
        return Responses.error(str(ve), 422)

@stocks_bp.route('/low', methods=['GET'])
def low_stock():
    org_id = request.args.get('org_id', type=int) or 1
    items = svc.low_stock(org_id=org_id)
    return Responses.success(items)

@stocks_bp.route('/reorder-suggestions', methods=['GET'])
def reorder_suggestions():
    org_id = request.args.get('org_id', type=int) or 1
    res = svc.reorder_suggestions(org_id=org_id)
    return Responses.success(res)
