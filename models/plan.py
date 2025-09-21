from myapp import db

class Plan(db.Model):
    __tablename__ = 'plan'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    code = db.Column(db.String(40), unique=True, nullable=False)   # 'free', 'pro'
    name = db.Column(db.String(80), nullable=False)
    is_active = db.Column(db.Boolean, server_default=db.text('true'), nullable=False)

    # Límites por defecto (puedes ajustar números)
    max_users = db.Column(db.Integer, nullable=False, server_default='3')
    max_products = db.Column(db.Integer, nullable=False, server_default='200')
    max_warehouses = db.Column(db.Integer, nullable=False, server_default='2')
    max_movements_per_day = db.Column(db.Integer, nullable=False, server_default='500')

    # Feature flags (para “disimular” ventajas del Pro sin implementarlas aún)
    allow_bom = db.Column(db.Boolean, server_default=db.text('false'), nullable=False)
    allow_work_orders = db.Column(db.Boolean, server_default=db.text('false'), nullable=False)
    allow_mrp = db.Column(db.Boolean, server_default=db.text('false'), nullable=False)
    allow_forecast = db.Column(db.Boolean, server_default=db.text('false'), nullable=False)

    def serialize(self):
        return {
            'id': self.id, 'code': self.code, 'name': self.name, 'is_active': self.is_active,
            'limits': {
                'max_users': self.max_users,
                'max_products': self.max_products,
                'max_warehouses': self.max_warehouses,
                'max_movements_per_day': self.max_movements_per_day,
            },
            'features': {
                'allow_bom': self.allow_bom,
                'allow_work_orders': self.allow_work_orders,
                'allow_mrp': self.allow_mrp,
                'allow_forecast': self.allow_forecast,
            }
        }
