from run import app
from app.db import db
from app.models.plan import Plan

with app.app_context():
    # Obtener plan FREE
    free_plan = Plan.query.filter_by(code='free').first()
    
    if free_plan:
        print(f'\n=== PLAN ACTUAL: {free_plan.name} ===')
        print(f'Max Users: {free_plan.max_users}')
        print(f'Max Products: {free_plan.max_products}')
        print(f'Max Warehouses: {free_plan.max_warehouses}')
        print(f'Max Movements/Day: {free_plan.max_movements_per_day}')
        
        # Actualizar límites para cubrir el uso actual + margen
        free_plan.max_users = 10           # 5 actuales + margen
        free_plan.max_products = 200       # 138 actuales + margen
        free_plan.max_warehouses = 10      # 5 actuales + margen
        free_plan.max_movements_per_day = 500  # Ya está bien
        free_plan.max_ai_reports_per_day = 50  # Aumentar también
        
        db.session.commit()
        
        print(f'\n=== PLAN ACTUALIZADO: {free_plan.name} ===')
        print(f'Max Users: {free_plan.max_users}')
        print(f'Max Products: {free_plan.max_products}')
        print(f'Max Warehouses: {free_plan.max_warehouses}')
        print(f'Max Movements/Day: {free_plan.max_movements_per_day}')
        print(f'Max AI Reports/Day: {free_plan.max_ai_reports_per_day}')
        
        print(f'\n✅ Plan FREE actualizado correctamente')
        
    else:
        print('⚠️ Plan FREE no encontrado')
