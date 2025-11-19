# run.py
from dotenv import load_dotenv
import os
import logging
from logging.handlers import RotatingFileHandler

# Cargar variables de entorno desde .env ANTES de importar config
load_dotenv()

from flask import Flask, request
from flask_cors import CORS
from app.config import Config
from flask_jwt_extended import JWTManager, get_jwt, verify_jwt_in_request
from app.db import db
from datetime import datetime

# Configurar logging
if not os.path.exists('logs'):
    os.mkdir('logs')

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(name)s: %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)

# File handler para todos los logs
file_handler = RotatingFileHandler('logs/mrp_app.log', maxBytes=10240000, backupCount=10)
file_handler.setFormatter(logging.Formatter(
    '%(asctime)s [%(levelname)s] %(name)s: %(message)s'
))
file_handler.setLevel(logging.INFO)

# File handler solo para errores
error_handler = RotatingFileHandler('logs/mrp_errors.log', maxBytes=10240000, backupCount=10)
error_handler.setFormatter(logging.Formatter(
    '%(asctime)s [%(levelname)s] %(name)s: %(message)s\n%(pathname)s:%(lineno)d\n'
))
error_handler.setLevel(logging.ERROR)

app = Flask(__name__)
app.config.from_object(Config)
CORS(app)
JWTManager(app)
db.init_app(app)

# Agregar handlers al logger de Flask
app.logger.addHandler(file_handler)
app.logger.addHandler(error_handler)
app.logger.setLevel(logging.INFO)

# Logger para toda la app
logger = logging.getLogger('mrp_backend')
logger.addHandler(file_handler)
logger.addHandler(error_handler)
logger.setLevel(logging.INFO)

# === Middleware de logging de requests ===
@app.before_request
def log_request():
    """Log todas las requests entrantes"""
    logger.info(f">> {request.method} {request.path} | IP: {request.remote_addr}")
    if request.is_json and request.method in ['POST', 'PUT', 'PATCH']:
        logger.debug(f"  Body: {request.get_json()}")

@app.after_request
def log_response(response):
    """Log todas las responses"""
    status_icon = "[OK]" if response.status_code < 400 else "[WARN]" if response.status_code < 500 else "[ERROR]"
    logger.info(f"<< {status_icon} {request.method} {request.path} | Status: {response.status_code}")
    return response

# === Middleware de auditoría (after_request) ===
@app.after_request
def audit_middleware(response):
    """Registra en system_log las peticiones exitosas a rutas protegidas"""
    try:
        # Solo registrar si status < 500 y ruta es /api (no public ni health)
        if response.status_code < 500 and request.path.startswith('/api/') and not request.path.startswith('/api/public'):
            try:
                verify_jwt_in_request(optional=True)
                jwt_data = get_jwt()
                user_id = jwt_data.get('sub') if jwt_data else None
                org_id = jwt_data.get('org_id') if jwt_data else None
            except:
                user_id = None
                org_id = None
            
            from app.models.system_log import SystemLog
            log = SystemLog(
                user_id=user_id,
                org_id=org_id,
                action=f"{request.method} {request.path}",
                path=request.path,
                method=request.method,
                ip=request.remote_addr or '',
                status_code=response.status_code
            )
            db.session.add(log)
            db.session.commit()
    except:
        db.session.rollback()
    
    return response

# === Error handlers ===
@app.errorhandler(Exception)
def handle_exception(e):
    """Capturar todas las excepciones no manejadas"""
    import traceback
    
    # Log detallado del error con separadores
    logger.error("="*80)
    logger.error(f"[EXCEPTION] UNCAUGHT: {type(e).__name__}")
    logger.error(f"   Message: {str(e)}")
    logger.error(f"   Path: {request.method} {request.path}")
    logger.error(f"   IP: {request.remote_addr}")
    if request.is_json:
        logger.error(f"   Body: {request.get_json()}")
    
    # Log stacktrace completo línea por línea
    logger.error("   Stacktrace:")
    for line in traceback.format_exc().split('\n'):
        if line.strip():
            logger.error(f"     {line}")
    logger.error("="*80)
    
    # Retornar respuesta de error
    from app.responses import Responses
    return Responses.error(f"Error interno del servidor: {str(e)}", http_code=500, code="INTERNAL_ERROR")

@app.errorhandler(404)
def not_found(e):
    """Handler para 404"""
    logger.warning(f"[404] NOT FOUND: {request.method} {request.path}")
    from app.responses import Responses
    return Responses.error("Recurso no encontrado", http_code=404, code="NOT_FOUND")

@app.errorhandler(500)
def internal_error(e):
    """Handler para 500"""
    logger.error(f"[500] INTERNAL ERROR: {str(e)}", exc_info=True)
    from app.responses import Responses
    return Responses.error("Error interno del servidor", http_code=500, code="INTERNAL_ERROR")

try: 
    # S1 controllers
    from app.controllers import (
        role_controller, 
        user_controller, 
        user_role_controller,
        resource_controller,
        subresource_controller,
        role_resource_controller,
        auth_controller,
        dashboard_controller,
        user_organization_controller,
        org_controller,
        supplier_controller,
        supplier_item_controller,
        stocks_controller,
        product_controller,
        product_warehouse_controller,
        warehouse_controller,
        movement_controller,
        unit_controller
    )
    
    # S2 controllers
    from app.controllers import (
        public_controller,
        log_controller,
        report_controller,
        backup_controller,
        health_controller,
        report_ai_controller,
        menu_controller,
        subscription_controller
    )
    
    # S3 controllers
    from app.controllers import (
        bom_controller,
        work_order_controller
    )
    
    # S4 controllers (Planning: Demand, MPS, MRP)
    from app.controllers import (
        demand_controller,
        mps_controller,
        mrp_controller
    )
    
    # S5 controllers (Alerts, Forecast, Dashboard Advanced)
    from app.controllers import (
        alert_controller,
        forecast_controller
    )
                        
    # S1 blueprints
    app.register_blueprint(role_controller.role_bp)
    app.register_blueprint(user_controller.user_bp)
    app.register_blueprint(user_role_controller.user_role_bp)
    app.register_blueprint(resource_controller.resource_bp)
    app.register_blueprint(subresource_controller.subresource_bp)
    app.register_blueprint(role_resource_controller.role_resource_bp)
    app.register_blueprint(auth_controller.auth_bp)

    app.register_blueprint(dashboard_controller.dashboard_bp)
    app.register_blueprint(user_organization_controller.user_org_bp)
    app.register_blueprint(org_controller.org_bp)
    app.register_blueprint(stocks_controller.stocks_bp)
    app.register_blueprint(supplier_controller.supplier_bp)
    app.register_blueprint(supplier_item_controller.supplier_item_bp)
    app.register_blueprint(product_controller.product_bp)
    app.register_blueprint(product_warehouse_controller.pw_bp)
    app.register_blueprint(warehouse_controller.warehouse_bp)
    app.register_blueprint(movement_controller.movement_bp)
    app.register_blueprint(unit_controller.unit_bp)
    
    # S2 blueprints
    app.register_blueprint(public_controller.public_bp)
    app.register_blueprint(log_controller.log_bp)
    app.register_blueprint(report_controller.report_bp)
    app.register_blueprint(backup_controller.backup_bp)
    app.register_blueprint(health_controller.health_bp)
    app.register_blueprint(report_ai_controller.report_ai_bp)
    app.register_blueprint(menu_controller.menu_bp)
    app.register_blueprint(subscription_controller.subscription_bp)
    
    # S3 blueprints
    app.register_blueprint(bom_controller.bom_bp, url_prefix='/api/boms')
    app.register_blueprint(work_order_controller.work_order_bp, url_prefix='/api/work-orders')
    
    # S4 blueprints (Planning)
    app.register_blueprint(demand_controller.demand_bp)
    app.register_blueprint(mps_controller.mps_bp)
    app.register_blueprint(mrp_controller.mrp_bp)
    
    # S5 blueprints (Alerts, Forecast, Dashboard)
    app.register_blueprint(alert_controller.alert_bp)
    app.register_blueprint(forecast_controller.forecast_bp)
    
    # === Error handlers globales ===
    from sqlalchemy.exc import IntegrityError
    
    @app.errorhandler(IntegrityError)
    def handle_integrity_error(e):
        db.session.rollback()
        from app.responses import Responses
        return Responses.error(f"Error de integridad en BD: {str(e.orig)}", 409)
    
    @app.errorhandler(ValueError)
    def handle_value_error(e):
        from app.responses import Responses
        return Responses.error(str(e), 400)
    
    @app.errorhandler(404)
    def handle_not_found(e):
        from app.responses import Responses
        return Responses.error("Recurso no encontrado", 404)
    
    @app.errorhandler(500)
    def handle_internal_error(e):
        db.session.rollback()
        from app.responses import Responses
        return Responses.error(f"Error interno del servidor: {str(e)}", 500)

    # crea las tablas de los modelos
    with app.app_context():
        db.create_all()

except Exception as e:
    print(f"Error al registrar el blueprint: {e}")
        


if __name__ == '__main__':
    #app=create_app()
    #app.run(port=8585, debug=True)
    app.run(host='0.0.0.0', port=4646, debug=True) 