from run import app
from app.db import db
from app.models.plan import Plan

with app.app_context():
    # Actualizar plan FREE para desarrollo
    plan_free = Plan.query.filter_by(code='free').first()
    
    if plan_free:
        print(f'\n=== PLAN FREE ACTUAL ===')
        print(f'Max Users: {plan_free.max_users}')
        print(f'Max Products: {plan_free.max_products}')
        print(f'Max Warehouses: {plan_free.max_warehouses}')
        print(f'Max Movements/Day: {plan_free.max_movements_per_day}')
        print(f'Max AI Reports/Day: {plan_free.max_ai_reports_per_day}')
        
        # Actualizar límites para desarrollo
        plan_free.max_users = 10
        plan_free.max_products = 200
        plan_free.max_warehouses = 10
        plan_free.max_movements_per_day = 500
        plan_free.max_ai_reports_per_day = 50
        
        db.session.commit()
        
        print(f'\n=== PLAN FREE ACTUALIZADO ===')
        print(f'Max Users: {plan_free.max_users}')
        print(f'Max Products: {plan_free.max_products}')
        print(f'Max Warehouses: {plan_free.max_warehouses}')
        print(f'Max Movements/Day: {plan_free.max_movements_per_day}')
        print(f'Max AI Reports/Day: {plan_free.max_ai_reports_per_day}')
        
        print(f'\n✅ Límites actualizados exitosamente!')
    else:
        print('\n⚠️ Plan FREE no encontrado')
