"""
Agregar stock inicial de componentes para poder producir
"""
import sys
sys.path.insert(0, '.')

from app.db import db
from app.models.product import Product
from app.models.warehouse import Warehouse
from app.models.product_warehouse import ProductWarehouse
from app.models.movement import Movement
from run import app
from decimal import Decimal

with app.app_context():
    print("=" * 60)
    print("AGREGANDO STOCK INICIAL DE COMPONENTES")
    print("=" * 60)
    
    org_id = 1
    warehouse = Warehouse.query.filter_by(org_id=org_id).first()
    
    if not warehouse:
        print("❌ No hay almacenes disponibles")
        exit(1)
    
    print(f"\n📦 Almacén: {warehouse.name} (ID: {warehouse.id})\n")
    
    # Productos componentes que necesitamos
    components_to_stock = {
        'RM-MAD': 500,    # Madera Cedro - 500 unidades
        'RM-TORN': 1000,  # Tornillos M6 - 1000 unidades
        'RM-ALU': 200,    # Aluminio 6061 - 200 kg
        'RM-PINT': 100,   # Pintura Epoxi - 100 litros
    }
    
    for code, quantity in components_to_stock.items():
        product = Product.query.filter_by(code=code, org_id=org_id).first()
        
        if not product:
            print(f"⚠️  Producto {code} no encontrado")
            continue
        
        # Verificar si ya existe la relación product-warehouse
        pw = ProductWarehouse.query.filter_by(
            product_id=product.id,
            warehouse_id=warehouse.id
        ).first()
        
        if pw:
            # Ya existe, actualizar stock
            old_stock = float(pw.current_stock)
            pw.current_stock = Decimal(str(quantity))
            action = "Actualizado"
        else:
            # No existe, crear
            pw = ProductWarehouse(
                product_id=product.id,
                warehouse_id=warehouse.id,
                current_stock=Decimal(str(quantity))
            )
            db.session.add(pw)
            old_stock = 0
            action = "Creado"
        
        # Crear movimiento de entrada (ADJUSTMENT)
        if quantity > old_stock:
            movement = Movement(
                org_id=org_id,
                product_id=product.id,
                to_warehouse_id=warehouse.id,
                movement_type='IN',
                reason='ADJUSTMENT',
                quantity=Decimal(str(quantity - old_stock)),
                reference_id='INIT-STOCK',
                note=f'Stock inicial de componente para producción'
            )
            db.session.add(movement)
        
        print(f"✅ {action}: {product.name} ({code})")
        print(f"   Stock anterior: {old_stock} → Nuevo: {quantity}")
    
    db.session.commit()
    
    print("\n" + "=" * 60)
    print("STOCK ACTUALIZADO EXITOSAMENTE")
    print("=" * 60)
    
    # Mostrar stock actual de todos los componentes
    print("\n📊 Stock actual de componentes:")
    print("-" * 60)
    
    for code in components_to_stock.keys():
        product = Product.query.filter_by(code=code, org_id=org_id).first()
        if product:
            pw = ProductWarehouse.query.filter_by(
                product_id=product.id,
                warehouse_id=warehouse.id
            ).first()
            stock = float(pw.current_stock) if pw else 0
            print(f"  {product.name:30s} | Stock: {stock:8.2f}")
    
    print("-" * 60)
