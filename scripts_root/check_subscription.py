from run import app
from app.db import db
from app.models.organization import Organization
from app.models.org_subscription import OrgSubscription
from app.models.plan import Plan
from app.models.user import User
from app.models.product import Product
from app.models.warehouse import Warehouse

with app.app_context():
    # Buscar organización
    org = Organization.query.filter_by(code='VPAY').first() or Organization.query.first()
    
    print(f'\n=== ORGANIZACIÓN ===')
    print(f'ID: {org.id}')
    print(f'Nombre: {org.name}')
    print(f'Code: {org.code}')
    
    # Buscar suscripción
    sub = OrgSubscription.query.filter_by(org_id=org.id).first()
    
    if sub:
        plan = Plan.query.get(sub.plan_id)
        
        print(f'\n=== SUSCRIPCIÓN ===')
        print(f'ID: {sub.id}')
        print(f'Status: {sub.status}')
        print(f'Plan ID: {sub.plan_id}')
        
        print(f'\n=== PLAN ===')
        print(f'Code: {plan.code}')
        print(f'Name: {plan.name}')
        print(f'Max Users: {plan.max_users}')
        print(f'Max Products: {plan.max_products}')
        print(f'Max Warehouses: {plan.max_warehouses}')
        print(f'Max Movements/Day: {plan.max_movements_per_day}')
        print(f'Max AI Reports/Day: {plan.max_ai_reports_per_day}')
        
        # Calcular uso actual
        total_users = User.query.filter_by(status=True).count()
        total_products = Product.query.filter_by(org_id=org.id, status=True).count()
        total_warehouses = Warehouse.query.filter_by(org_id=org.id).count()
        
        print(f'\n=== USO ACTUAL ===')
        print(f'Usuarios: {total_users} / {plan.max_users}')
        print(f'Productos: {total_products} / {plan.max_products}')
        print(f'Almacenes: {total_warehouses} / {plan.max_warehouses}')
        
    else:
        print('\n⚠️ NO HAY SUSCRIPCIÓN ACTIVA')
        print('\nPlanes disponibles:')
        plans = Plan.query.all()
        for p in plans:
            print(f'  - {p.code}: {p.name} (ID: {p.id})')
