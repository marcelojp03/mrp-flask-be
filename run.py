# run.py
from dotenv import load_dotenv
import os

# Cargar variables de entorno desde .env ANTES de importar config
load_dotenv()

from flask import Flask, request
from flask_cors import CORS
from app.config import Config
from flask_jwt_extended import JWTManager, get_jwt, verify_jwt_in_request
from app.db import db
from datetime import datetime


app = Flask(__name__)
app.config.from_object(Config)
CORS(app)
JWTManager(app)
db.init_app(app)

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