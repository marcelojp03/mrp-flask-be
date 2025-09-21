# myapp.py
from flask import Flask
from flask_cors import CORS
from app.config import Config
from flask_jwt_extended import JWTManager
from app.utils import db


app = Flask(__name__)
app.config.from_object(Config)
CORS(app)
JWTManager(app)
db.init_app(app)

try: 
    # Registrar Blueprint
    from controllers import (
        role_controller, 
        user_controller, 
        user_role_controller,
        resource_controller,
        subresource_controller,
        role_resource_controller,
        auth_controller,

        org_controller,
        supplier_controller,
        stocks_controller,
        product_controller,
        product_warehouse_controller,
        warehouse_controller,
        movement_controller,
        unit_controller
        )
                        
    app.register_blueprint(role_controller.role_bp)
    app.register_blueprint(user_controller.user_bp)
    app.register_blueprint(user_role_controller.user_role_bp)
    app.register_blueprint(resource_controller.resource_bp)
    app.register_blueprint(subresource_controller.subresource_bp)
    app.register_blueprint(role_resource_controller.role_resource_bp)
    app.register_blueprint(auth_controller.auth_bp)

    app.register_blueprint(org_controller.org_bp)
    app.register_blueprint(stocks_controller.stocks_bp)
    app.register_blueprint(supplier_controller.supplier_bp)
    app.register_blueprint(product_controller.product_bp)
    app.register_blueprint(product_warehouse_controller.pw_bp)
    app.register_blueprint(warehouse_controller.warehouse_bp)
    app.register_blueprint(movement_controller.movement_bp)
    app.register_blueprint(unit_controller.unit_bp)

    # crea las tablas de los modelos
    with app.app_context():
        db.create_all()

except Exception as e:
    print(f"Error al registrar el blueprint: {e}")
        


if __name__ == '__main__':
    #app=create_app()
    #app.run(port=8585, debug=True)
    app.run(host='0.0.0.0', port=8585, debug=True) 