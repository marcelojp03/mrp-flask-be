# controllers/log_controller.py
from flask import Blueprint, request, jsonify
from app.db import db
from app.responses import Responses
from models.system_log import SystemLog
from flask_jwt_extended import jwt_required, get_jwt

log_bp = Blueprint('logs', __name__, url_prefix='/api/logs')

@log_bp.route('', methods=['GET'])
@jwt_required()
def list_logs():
    """
    Listado de logs del sistema (solo Admin)
    Query params: ?limit=100&page=1&user_id=X&org_id=Y
    """
    try:
        # Verificar permisos (ejemplo simple: solo admin)
        jwt_data = get_jwt()
        # TODO: validar rol Admin aquí si tienes decorator personalizado
        
        limit = int(request.args.get('limit', 100))
        page = int(request.args.get('page', 1))
        user_id = request.args.get('user_id', type=int)
        org_id = request.args.get('org_id', type=int)

        query = SystemLog.query
        
        if user_id:
            query = query.filter_by(user_id=user_id)
        if org_id:
            query = query.filter_by(org_id=org_id)
        
        query = query.order_by(SystemLog.ts.desc())
        
        # Paginación
        offset = (page - 1) * limit
        logs = query.limit(limit).offset(offset).all()
        total = query.count()
        
        return jsonify(Responses.success({
            'logs': [l.serialize() for l in logs],
            'total': total,
            'page': page,
            'limit': limit
        })), 200
        
    except Exception as ex:
        return jsonify(Responses.error(f'Error al obtener logs: {ex}', 500)), 500
