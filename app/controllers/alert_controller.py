# controllers/alert_controller.py
from flask import Blueprint, request, g
from datetime import datetime
from app.services.alert_service import AlertService
from app.responses import Responses
from auth.decorators import auth_required

alert_bp = Blueprint('alert', __name__, url_prefix='/api/alerts')
alert_service = AlertService()

@alert_bp.route('', methods=['GET'])
@auth_required
def list_alerts(org_id, user_id):
    """
    GET /api/alerts
    Listar alertas con filtros
    
    Query params:
    - is_read: boolean (true/false)
    - type: str (low_stock, wo_delay, mrp_pending, etc.)
    - severity: str (info, warning, critical)
    - limit: int (default 50)
    """
    try:
        is_read = request.args.get('is_read')
        if is_read is not None:
            is_read = is_read.lower() == 'true'
        
        type = request.args.get('type')
        severity = request.args.get('severity')
        limit = request.args.get('limit', 50, type=int)
        
        alerts = alert_service.list(
            org_id=org_id,
            is_read=is_read,
            type=type,
            severity=severity,
            limit=limit
        )
        
        return Responses.success(
            data=alerts,
            message=f'{len(alerts)} alertas encontradas'
        )
    
    except Exception as e:
        return Responses.error(str(e), 500)


@alert_bp.route('/<int:alert_id>', methods=['GET'])
@auth_required
def get_alert(org_id, user_id, alert_id):
    """GET /api/alerts/:id - Obtener alerta por ID"""
    try:
        alert = alert_service.get(alert_id, org_id)
        
        if not alert:
            return Responses.error('Alerta no encontrada', 404)
        
        return Responses.success(data=alert)
    
    except Exception as e:
        return Responses.error(str(e), 500)


@alert_bp.route('', methods=['POST'])
@auth_required
def create_alert(org_id, user_id):
    """
    POST /api/alerts
    Crear alerta manualmente (uso administrativo)
    
    Body:
    {
        "type": "custom",
        "severity": "warning",
        "title": "Título de la alerta",
        "message": "Mensaje detallado",
        "reference_type": "product",  // opcional
        "reference_id": 123,  // opcional
        "metadata": {}  // opcional
    }
    """
    try:
        data = request.get_json()
        
        required_fields = ['type', 'title', 'message']
        for field in required_fields:
            if field not in data:
                return Responses.error(f'Campo requerido: {field}', 400)
        
        alert = alert_service.create(
            org_id=org_id,
            type=data['type'],
            title=data['title'],
            message=data['message'],
            severity=data.get('severity', 'info'),
            reference_type=data.get('reference_type'),
            reference_id=data.get('reference_id'),
            metadata=data.get('metadata')
        )
        
        return Responses.success(
            data=alert,
            message='Alerta creada exitosamente',
            http_code=201
        )
    
    except Exception as e:
        return Responses.error(str(e), 500)


@alert_bp.route('/<int:alert_id>/read', methods=['PUT'])
@auth_required
def mark_alert_read(org_id, user_id, alert_id):
    """
    PUT /api/alerts/:id/read
    Marcar alerta como leída
    """
    try:
        alert = alert_service.mark_read(alert_id, org_id, user_id)
        
        if not alert:
            return Responses.error('Alerta no encontrada', 404)
        
        return Responses.success(
            data=alert,
            message='Alerta marcada como leída'
        )
    
    except Exception as e:
        return Responses.error(str(e), 500)


@alert_bp.route('/read-all', methods=['PUT'])
@auth_required
def mark_all_read(org_id, user_id):
    """
    PUT /api/alerts/read-all
    Marcar todas las alertas como leídas
    
    Query params opcionales:
    - type: str (marcar solo de un tipo específico)
    """
    try:
        type = request.args.get('type')
        
        count = alert_service.mark_all_read(org_id, user_id, type=type)
        
        return Responses.success(
            data={'marked_read': count},
            message=f'{count} alertas marcadas como leídas'
        )
    
    except Exception as e:
        return Responses.error(str(e), 500)


@alert_bp.route('/<int:alert_id>', methods=['DELETE'])
@auth_required
def delete_alert(org_id, user_id, alert_id):
    """DELETE /api/alerts/:id - Eliminar alerta"""
    try:
        deleted = alert_service.delete(alert_id, org_id)
        
        if not deleted:
            return Responses.error('Alerta no encontrada', 404)
        
        return Responses.success(message='Alerta eliminada exitosamente')
    
    except Exception as e:
        return Responses.error(str(e), 500)


@alert_bp.route('/summary', methods=['GET'])
@auth_required
def get_summary(org_id, user_id):
    """
    GET /api/alerts/summary
    Obtener resumen de alertas no leídas
    
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
        }
    }
    """
    try:
        summary = alert_service.get_summary(org_id)
        return Responses.success(data=summary)
    
    except Exception as e:
        return Responses.error(str(e), 500)


@alert_bp.route('/check', methods=['POST'])
@auth_required
def check_alerts(org_id, user_id):
    """
    POST /api/alerts/check
    Ejecutar verificación de todas las alertas automáticas
    (low_stock, wo_delay, mrp_pending)
    
    Response:
    {
        "low_stock": 5,
        "wo_delay": 2,
        "mrp_pending": 3,
        "total": 10
    }
    """
    try:
        results = alert_service.check_all(org_id)
        
        return Responses.success(
            data=results,
            message=f'{results["total"]} nuevas alertas generadas'
        )
    
    except Exception as e:
        return Responses.error(str(e), 500)
