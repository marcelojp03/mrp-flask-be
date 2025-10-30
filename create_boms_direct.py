"""
Script para crear BOMs y Work Orders directamente usando ORM
Más confiable que seeds SQL con múltiples JOINs
"""
from app.db import db
from run import app
from models.bom import BOM, BOMComponent
from models.work_order import WorkOrder
from models.product import Product
from models.warehouse import Warehouse
from models.user import User
from datetime import datetime, timedelta

def create_boms_and_work_orders():
    with app.app_context():
        print("=" * 60)
        print("CREANDO BOMs Y WORK ORDERS DIRECTAMENTE")
        print("=" * 60)
        
        # Verificar que existen los productos necesarios
        products = {
            'FG-MESA': Product.query.filter_by(code='FG-MESA', org_id=1).first(),
            'FG-SILLA': Product.query.filter_by(code='FG-SILLA', org_id=1).first(),
            'RM-MAD': Product.query.filter_by(code='RM-MAD', org_id=1).first(),
            'RM-TORN': Product.query.filter_by(code='RM-TORN', org_id=1).first(),
            'RM-PINT': Product.query.filter_by(code='RM-PINT', org_id=1).first(),
            'RM-ALU': Product.query.filter_by(code='RM-ALU', org_id=1).first(),
        }
        
        print("\nProductos encontrados:")
        for code, prod in products.items():
            if prod:
                print(f"  OK {code} (id={prod.id})")
            else:
                print(f"  ERROR {code} NO ENCONTRADO")
                return
        
        # Obtener warehouse y user
        warehouse = Warehouse.query.filter_by(name='Principal', org_id=1).first()
        # Usar el primer usuario disponible
        user = User.query.first()
        
        if not warehouse or not user:
            print("\nERROR: No se encontró warehouse o usuarios")
            return
        
        print(f"\nWarehouse: {warehouse.name} (id={warehouse.id})")
        print(f"Usuario: {user.email} (id={user.id})")
        
        # ============================================================================
        # 1. BOM para FG-MESA
        # ============================================================================
        print("\n" + "-" * 60)
        print("CREANDO BOM FG-MESA")
        print("-" * 60)
        
        bom_mesa = BOM.query.filter_by(
            org_id=1, 
            product_id=products['FG-MESA'].id, 
            version='1.0'
        ).first()
        
        if not bom_mesa:
            bom_mesa = BOM(
                org_id=1,
                product_id=products['FG-MESA'].id,
                version='1.0',
                is_active=True,
                description='BOM estándar para mesa de madera'
            )
            db.session.add(bom_mesa)
            db.session.flush()
            print(f"  BOM FG-MESA creada (id={bom_mesa.id})")
            
            # Componentes
            components_mesa = [
                {
                    'product': products['RM-MAD'],
                    'quantity': 4.0,
                    'scrap': 5.0,
                    'unit_id': 1,  # EA
                    'seq': 1,
                    'notes': 'Tableros de madera principal'
                },
                {
                    'product': products['RM-TORN'],
                    'quantity': 16.0,
                    'scrap': 3.0,
                    'unit_id': 1,  # EA
                    'seq': 2,
                    'notes': 'Tornillos de ensamblaje'
                },
                {
                    'product': products['RM-PINT'],
                    'quantity': 0.5,
                    'scrap': 8.0,
                    'unit_id': 3,  # L
                    'seq': 3,
                    'notes': 'Pintura de acabado'
                },
            ]
            
            for comp_data in components_mesa:
                comp = BOMComponent(
                    bom_id=bom_mesa.id,
                    component_id=comp_data['product'].id,
                    quantity=comp_data['quantity'],
                    scrap_percentage=comp_data['scrap'],
                    unit_id=comp_data['unit_id'],
                    sequence=comp_data['seq'],
                    notes=comp_data['notes']
                )
                db.session.add(comp)
                print(f"    + {comp_data['product'].code}: {comp_data['quantity']} (scrap {comp_data['scrap']}%)")
        else:
            print(f"  BOM FG-MESA ya existe (id={bom_mesa.id})")
        
        # ============================================================================
        # 2. BOM para FG-SILLA
        # ============================================================================
        print("\n" + "-" * 60)
        print("CREANDO BOM FG-SILLA")
        print("-" * 60)
        
        bom_silla = BOM.query.filter_by(
            org_id=1, 
            product_id=products['FG-SILLA'].id, 
            version='1.0'
        ).first()
        
        if not bom_silla:
            bom_silla = BOM(
                org_id=1,
                product_id=products['FG-SILLA'].id,
                version='1.0',
                is_active=True,
                description='BOM estándar para silla'
            )
            db.session.add(bom_silla)
            db.session.flush()
            print(f"  BOM FG-SILLA creada (id={bom_silla.id})")
            
            # Componentes
            components_silla = [
                {
                    'product': products['RM-MAD'],
                    'quantity': 2.0,
                    'scrap': 4.0,
                    'unit_id': 1,  # EA
                    'seq': 1,
                    'notes': 'Tableros para asiento y respaldo'
                },
                {
                    'product': products['RM-ALU'],
                    'quantity': 1.5,
                    'scrap': 6.0,
                    'unit_id': 2,  # KG
                    'seq': 2,
                    'notes': 'Estructura de aluminio'
                },
                {
                    'product': products['RM-TORN'],
                    'quantity': 12.0,
                    'scrap': 3.0,
                    'unit_id': 1,  # EA
                    'seq': 3,
                    'notes': 'Tornillos de ensamblaje'
                },
            ]
            
            for comp_data in components_silla:
                comp = BOMComponent(
                    bom_id=bom_silla.id,
                    component_id=comp_data['product'].id,
                    quantity=comp_data['quantity'],
                    scrap_percentage=comp_data['scrap'],
                    unit_id=comp_data['unit_id'],
                    sequence=comp_data['seq'],
                    notes=comp_data['notes']
                )
                db.session.add(comp)
                print(f"    + {comp_data['product'].code}: {comp_data['quantity']} (scrap {comp_data['scrap']}%)")
        else:
            print(f"  BOM FG-SILLA ya existe (id={bom_silla.id})")
        
        # Commit BOMs
        db.session.commit()
        print("\nOK BOMs guardadas en base de datos")
        
        # ============================================================================
        # 3. WORK ORDERS
        # ============================================================================
        print("\n" + "-" * 60)
        print("CREANDO WORK ORDERS")
        print("-" * 60)
        
        # WO 1: 5 Mesas
        wo1 = WorkOrder.query.filter_by(reference='OP-2025-001').first()
        if not wo1:
            wo1 = WorkOrder(
                org_id=1,
                product_id=products['FG-MESA'].id,
                bom_id=bom_mesa.id,
                quantity=5.0,
                status='Planificada',
                warehouse_id=warehouse.id,
                reference='OP-2025-001',
                notes='Orden inicial de mesas',
                planned_start=datetime.now() + timedelta(days=1),
                planned_end=datetime.now() + timedelta(days=3),
                created_by=user.id
            )
            db.session.add(wo1)
            print(f"  WO OP-2025-001 creada: 5 x FG-MESA")
        else:
            print(f"  WO OP-2025-001 ya existe (id={wo1.id})")
        
        # WO 2: 10 Sillas
        wo2 = WorkOrder.query.filter_by(reference='OP-2025-002').first()
        if not wo2:
            wo2 = WorkOrder(
                org_id=1,
                product_id=products['FG-SILLA'].id,
                bom_id=bom_silla.id,
                quantity=10.0,
                status='Planificada',
                warehouse_id=warehouse.id,
                reference='OP-2025-002',
                notes='Orden de sillas para stock',
                planned_start=datetime.now() + timedelta(days=2),
                planned_end=datetime.now() + timedelta(days=5),
                created_by=user.id,
                assigned_to=user.id
            )
            db.session.add(wo2)
            print(f"  WO OP-2025-002 creada: 10 x FG-SILLA (asignada a {user.email})")
        else:
            print(f"  WO OP-2025-002 ya existe (id={wo2.id})")
        
        # Commit WOs
        db.session.commit()
        print("\nOK Work Orders guardadas en base de datos")
        
        # ============================================================================
        # 4. VERIFICACIÓN FINAL
        # ============================================================================
        print("\n" + "=" * 60)
        print("VERIFICACION FINAL")
        print("=" * 60)
        
        total_boms = BOM.query.filter_by(org_id=1).count()
        total_components = BOMComponent.query.join(BOM).filter(BOM.org_id == 1).count()
        total_wos = WorkOrder.query.filter_by(org_id=1).count()
        
        print(f"\nOK BOMs creadas: {total_boms}")
        print(f"OK Componentes BOM: {total_components}")
        print(f"OK Work Orders: {total_wos}")
        
        # Detalles
        print("\nDetalles BOMs:")
        for bom in BOM.query.filter_by(org_id=1).all():
            components = BOMComponent.query.filter_by(bom_id=bom.id).count()
            print(f"  - {bom.product.code} v{bom.version}: {components} componentes (activa={bom.is_active})")
        
        print("\nDetalles Work Orders:")
        for wo in WorkOrder.query.filter_by(org_id=1).all():
            print(f"  - {wo.reference}: {wo.quantity} x {wo.product.code} ({wo.status})")
        
        print("\n" + "=" * 60)
        print("CREACION COMPLETADA EXITOSAMENTE")
        print("=" * 60)

if __name__ == "__main__":
    create_boms_and_work_orders()
