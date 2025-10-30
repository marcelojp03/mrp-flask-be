# controllers/health_controller.py
from flask import Blueprint, jsonify
from datetime import datetime

health_bp = Blueprint('health', __name__, url_prefix='')

@health_bp.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint público (sin JWT)"""
    return jsonify({
        'status': 'ok',
        'timestamp': datetime.utcnow().isoformat(),
        'service': 'mrp-flask-be'
    }), 200
