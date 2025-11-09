"""
Script para verificar y crear datos de prueba para movements, BOMs y Work Orders
"""
import sys
sys.path.insert(0, '.')

from app.db import db
from app.models.movement import Movement
from app.models.bom import BOM, BOMComponent
from app.models.work_order import WorkOrder
from app.models.product import Product
from app.models.warehouse import Warehouse
from app.models.organization import Organization
from run import app

with app.app_context():
    print("=" * 60)
    print("VERIFICANDO DATOS DE PRUEBA")
    print("=" * 60)
    
    # 1. Verificar Movements
    movements_count = Movement.query.count()
    print(f"\n📦 Movements: {movements_count}")
    
    if movements_count == 0:
        print("⚠️  No hay movements. Creando ejemplos...")
        
        # Obtener primer producto y almacén
        org = Organization.query.first()
        product = Product.query.filter_by(org_id=org.id).first()
        warehouse = Warehouse.query.filter_by(org_id=org.id).first()
        
        if product and warehouse:
            # Crear movimiento de entrada
            mov1 = Movement(
                org_id=org.id,
                product_id=product.id,
                to_warehouse_id=warehouse.id,
                movement_type='IN',
                reason='PURCHASE',
                quantity=100,
                reference_id='PO-2025-001',
                note='Compra inicial de prueba'
            )
            db.session.add(mov1)
            
            # Crear movimiento de salida
            mov2 = Movement(
                org_id=org.id,
                product_id=product.id,
                from_warehouse_id=warehouse.id,
                movement_type='OUT',
                reason='CONSUMPTION',
                quantity=25,
                reference_id='WO-001',
                note='Consumo para producción'
            )
            db.session.add(mov2)
            
            db.session.commit()
            print(f"✅ Creados 2 movements de ejemplo para {product.name}")
        else:
            print("❌ No hay productos o almacenes para crear movements")
    
    # 2. Verificar BOMs
    boms_count = BOM.query.count()
    print(f"\n🔧 BOMs: {boms_count}")
    
    if boms_count > 0:
        print("✅ Ya existen BOMs")
    else:
        print("⚠️  No hay BOMs en la base de datos")
    
    # 3. Verificar Work Orders
    wo_count = WorkOrder.query.count()
    print(f"\n📋 Work Orders: {wo_count}")
    
    if wo_count > 0:
        print("✅ Ya existen Work Orders")
        
        # Mostrar los estados
        for status in ['Planificada', 'En Progreso', 'Finalizada', 'Cancelada']:
            count = WorkOrder.query.filter_by(status=status).count()
            print(f"   - {status}: {count}")
    else:
        print("⚠️  No hay Work Orders en la base de datos")
    
    print("\n" + "=" * 60)
    print("RESUMEN:")
    print(f"  Movements:    {Movement.query.count()}")
    print(f"  BOMs:         {BOM.query.count()}")
    print(f"  Work Orders:  {WorkOrder.query.count()}")
    print("=" * 60)
