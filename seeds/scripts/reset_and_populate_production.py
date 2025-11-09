#!/usr/bin/env python3
"""
Script de limpieza y población masiva de datos para Sprint 3
- Elimina datos de test
- Crea datos realistas de producción
- Enfoque en proveedores y relaciones proveedor-producto
"""
import sys
import os
sys.path.insert(0, os.path.dirname(__file__))

from dotenv import load_dotenv
load_dotenv()

from app.db import db
from app.models.user import User
from app.models.organization import Organization
from app.models.product import Product
from app.models.warehouse import Warehouse
from app.models.product_warehouse import ProductWarehouse
from app.models.supplier import Supplier
from app.models.supplier_item import SupplierItem
from app.models.movement import Movement
from app.models.bom import BOM
from app.models.work_order import WorkOrder
from flask import Flask
from app.config import Config
from datetime import datetime, timedelta
import random

app = Flask(__name__)
app.config.from_object(Config)
db.init_app(app)

def cleanup_data():
    """Elimina datos de test manteniendo estructura base"""
    print("\n🗑️  LIMPIANDO DATOS DE TEST...")
    print("=" * 70)
    
    with app.app_context():
        # Orden de eliminación respetando foreign keys
        tables_to_clean = [
            (Movement, "Movimientos"),
            (WorkOrder, "Órdenes de trabajo"),
            (BOM, "BOMs"),
            (SupplierItem, "Catálogo proveedor-producto"),
            (Supplier, "Proveedores"),
            (ProductWarehouse, "Stock en almacenes"),
            (Product, "Productos"),
            (Category, "Categorías"),
            (Warehouse, "Almacenes"),
        ]
        
        for model, name in tables_to_clean:
            count = model.query.delete()
            print(f"  ✓ {name}: {count} registros eliminados")
        
        db.session.commit()
        print("\n✅ Limpieza completada")

def populate_categories():
    """Crea categorías realistas"""
    print("\n📁 CREANDO CATEGORÍAS...")
    
    categories_data = [
        ("Materia Prima", "Metales, plásticos, químicos, madera, vidrio"),
        ("Componentes Electrónicos", "Semiconductores, resistencias, capacitores, conectores"),
        ("Herramientas", "Manuales, eléctricas, neumáticas, medición, corte"),
        ("Consumibles", "Lubricantes, adhesivos, limpieza, protección, papelería"),
        ("Productos Terminados", "Electrónicos, mobiliario, maquinaria, accesorios"),
    ]
    
    cats = {}
    for cat_name, description in categories_data:
        cat = Category(
            name=cat_name,
            code=f"CAT-{cat_name[:3].upper()}",
            description=description,
            status=1
        )
        db.session.add(cat)
        db.session.flush()
        cats[cat_name] = cat
        print(f"  ✓ {cat_name}")
    
    db.session.commit()
    return cats

def populate_warehouses():
    """Crea almacenes"""
    print("\n🏭 CREANDO ALMACENES...")
    
    warehouses_data = [
        ("Almacén Principal", "Santa Cruz - Zona Norte"),
        ("Almacén Secundario", "Santa Cruz - Zona Este"),
        ("Almacén de Materia Prima", "Parque Industrial"),
        ("Almacén de Productos Terminados", "Zona Franca"),
        ("Almacén de Consumibles", "Oficina Central")
    ]
    
    warehouses = []
    for name, location in warehouses_data:
        wh = Warehouse(
            name=name,
            location=location,
            org_id=1
        )
        db.session.add(wh)
        warehouses.append(wh)
        print(f"  ✓ {name}")
    
    db.session.commit()
    return warehouses

def populate_products(categories):
    """Crea productos variados"""
    print("\n📦 CREANDO PRODUCTOS...")
    
    products_data = {
        "Materia Prima": [
            ("Acero Inoxidable 304", "STEEL-304", "BUY", "RM", 15.50, 100, 500),
            ("Aluminio 6061-T6", "ALU-6061", "BUY", "RM", 12.30, 80, 400),
            ("PVC Flexible", "PVC-FLEX", "BUY", "RM", 8.75, 200, 1000),
            ("Resina Epoxi", "RESIN-EP", "BUY", "RM", 25.00, 50, 200),
            ("Madera MDF 18mm", "MDF-18", "BUY", "RM", 18.50, 30, 150),
            ("Vidrio Templado 6mm", "GLASS-6", "BUY", "RM", 35.00, 20, 100),
        ],
        "Componentes Electrónicos": [
            ("Microcontrolador ATmega328", "MCU-328", "BUY", "RM", 4.50, 100, 500),
            ("Resistencia 10K Ohm", "RES-10K", "BUY", "RM", 0.05, 1000, 5000),
            ("Capacitor 100uF", "CAP-100", "BUY", "RM", 0.15, 500, 2000),
            ("Conector USB-C", "CONN-USBC", "BUY", "RM", 1.20, 200, 1000),
            ("Display LCD 16x2", "LCD-16X2", "BUY", "RM", 8.50, 50, 250),
            ("LED RGB 5mm", "LED-RGB", "BUY", "RM", 0.30, 1000, 3000),
        ],
        "Herramientas": [
            ("Destornillador Phillips", "TOOL-PH", "BUY", "CONSUMABLE", 5.50, 10, 50),
            ("Taladro Eléctrico 600W", "DRILL-600", "BUY", "CONSUMABLE", 85.00, 5, 20),
            ("Sierra Circular", "SAW-CIRC", "BUY", "CONSUMABLE", 120.00, 3, 15),
            ("Multímetro Digital", "MULTI-DIG", "BUY", "CONSUMABLE", 35.00, 10, 30),
            ("Llave Inglesa 12\"", "WRENCH-12", "BUY", "CONSUMABLE", 15.00, 20, 50),
        ],
        "Consumibles": [
            ("Aceite Lubricante 3-1", "OIL-31", "BUY", "CONSUMABLE", 6.50, 50, 200),
            ("Adhesivo Epoxi", "GLUE-EP", "BUY", "CONSUMABLE", 8.00, 30, 150),
            ("Limpiador Electrónico", "CLEAN-E", "BUY", "CONSUMABLE", 12.00, 40, 200),
            ("Guantes Nitrilo (100u)", "GLOVE-NIT", "BUY", "CONSUMABLE", 15.00, 20, 100),
            ("Papel Bond A4 (500h)", "PAPER-A4", "BUY", "CONSUMABLE", 4.50, 50, 200),
        ],
        "Productos Terminados": [
            ("Controlador Automático", "CTRL-AUTO", "MAKE", "FG", 150.00, 10, 50),
            ("Mesa Ejecutiva", "DESK-EXEC", "MAKE", "FG", 450.00, 5, 20),
            ("Panel Solar 100W", "SOLAR-100", "MAKE", "FG", 180.00, 8, 40),
            ("Sistema de Riego", "IRRIG-SYS", "MAKE", "FG", 320.00, 6, 30),
            ("Caja Organizadora", "BOX-ORG", "MAKE", "FG", 25.00, 50, 200),
        ]
    }
    
    products = []
    counter = 1
    
    for cat_name, items in products_data.items():
        cat = categories[cat_name]
        
        for name, code, proc_type, item_type, price, min_stock, max_stock in items:
            product = Product(
                name=name,
                code=code,
                description=f"{name} - Material de alta calidad",
                item_type=item_type,
                procurement_type=proc_type,
                unit_of_measure="UND",
                standard_cost=price,
                min_stock=min_stock,
                max_stock=max_stock,
                status=True,
                category_id=cat.id,
                org_id=1
            )
            db.session.add(product)
            products.append(product)
            counter += 1
    
    db.session.commit()
    print(f"  ✓ {len(products)} productos creados")
    return products

def populate_suppliers():
    """Crea proveedores realistas"""
    print("\n🚚 CREANDO PROVEEDORES...")
    
    suppliers_data = [
        # Proveedores nacionales
        ("Metalúrgica Santa Cruz", "La Guardia Km 8", "Santa Cruz", "Bolivia", "7612-3456", "7712-3456", "ventas@metalurgica.bo", "METAL-SC", "77.12345.678", True),
        ("Plásticos del Norte", "Av. Cristo Redentor 234", "Santa Cruz", "Bolivia", "3345-6789", "7723-4567", "contacto@plasticosnorte.bo", "PLAST-N", "77.23456.789", True),
        ("Distribuidora Eléctrica", "Calle Junín 456", "Santa Cruz", "Bolivia", "3367-8901", "7734-5678", "info@diselec.bo", "DISELEC", "77.34567.890", True),
        ("Maderas Tropicales", "Parque Industrial", "Santa Cruz", "Bolivia", "3389-0123", "7745-6789", "ventas@maderastrop.bo", "MAD-TROP", "77.45678.901", True),
        ("Químicos Industriales", "Zona Franca", "Santa Cruz", "Bolivia", "3390-1234", "7756-7890", "contacto@quimica.bo", "QUIM-IND", "77.56789.012", True),
        
        # Proveedores internacionales
        ("TechComponents USA", "123 Silicon Valley", "California", "USA", "+1-408-555-0100", "+1-408-555-0101", "sales@techcomp.com", "TECH-USA", "US-12345", True),
        ("European Electronics", "Berliner Str. 45", "Munich", "Germany", "+49-89-555-0100", "+49-89-555-0101", "info@euroelec.de", "EURO-E", "DE-67890", True),
        ("Asian Hardware Co", "Shenzhen Tech Park", "Shenzhen", "China", "+86-755-555-0100", "+86-755-555-0101", "export@asianhw.cn", "ASIA-HW", "CN-54321", True),
        ("Brazilian Tools", "Av. Paulista 1000", "São Paulo", "Brazil", "+55-11-555-0100", "+55-11-555-0101", "vendas@braztools.br", "BRAZ-T", "BR-98765", True),
        ("Argentine Supplies", "Av. Corrientes 500", "Buenos Aires", "Argentina", "+54-11-555-0100", "+54-11-555-0101", "ventas@argsupply.ar", "ARG-SUP", "AR-13579", True),
        
        # Más proveedores nacionales
        ("Ferretería El Tornillo", "Av. Beni 789", "Santa Cruz", "Bolivia", "3401-2345", "7767-8901", "ventas@tornillo.bo", "FERR-TOR", "77.67890.123", True),
        ("Importadora Global", "Zona Este Calle 12", "Santa Cruz", "Bolivia", "3412-3456", "7778-9012", "info@impglobal.bo", "IMP-GLOB", "77.78901.234", True),
        ("Suministros Industriales", "Parque Industrial Lote 5", "Santa Cruz", "Bolivia", "3423-4567", "7789-0123", "ventas@sumind.bo", "SUM-IND", "77.89012.345", True),
    ]
    
    suppliers = []
    for name, addr, city, country, phone, mobile, email, code, tax_id, active in suppliers_data:
        supplier = Supplier(
            name=name,
            address=addr,
            city=city,
            country=country,
            phone=phone,
            mobile=mobile,
            email=email,
            code=code,
            tax_id=tax_id,
            status=active,
            payment_terms="Net 30",
            org_id=1
        )
        db.session.add(supplier)
        suppliers.append(supplier)
    
    db.session.commit()
    print(f"  ✓ {len(suppliers)} proveedores creados")
    return suppliers

def populate_supplier_items(products, suppliers):
    """Crea relaciones proveedor-producto (Sprint 3 focus)"""
    print("\n🔗 CREANDO CATÁLOGO PROVEEDOR-PRODUCTO...")
    
    # Mapear proveedores por especialidad
    supplier_map = {
        "metal": [s for s in suppliers if "Metalúrgica" in s.name or "Metal" in s.code],
        "plastic": [s for s in suppliers if "Plástico" in s.name],
        "electronic": [s for s in suppliers if "Electronic" in s.name or "TechComp" in s.name or "Eléctrica" in s.name],
        "wood": [s for s in suppliers if "Madera" in s.name],
        "chemical": [s for s in suppliers if "Químico" in s.name],
        "tools": [s for s in suppliers if "Ferretería" in s.name or "Tools" in s.name or "Hardware" in s.name],
        "general": [s for s in suppliers if "Import" in s.name or "Global" in s.name or "Suministros" in s.name]
    }
    
    supplier_items = []
    
    for product in products:
        # Determinar qué proveedores pueden suministrar este producto
        possible_suppliers = []
        
        if "Acero" in product.name or "Aluminio" in product.name or "Metal" in product.name:
            possible_suppliers = supplier_map["metal"] + supplier_map["general"]
        elif "PVC" in product.name or "Plástico" in product.name or "Resina" in product.name:
            possible_suppliers = supplier_map["plastic"] + supplier_map["general"]
        elif any(x in product.name for x in ["Microcontrolador", "Resistencia", "Capacitor", "LED", "Display", "Conector"]):
            possible_suppliers = supplier_map["electronic"] + supplier_map["general"]
        elif "Madera" in product.name or "MDF" in product.name:
            possible_suppliers = supplier_map["wood"] + supplier_map["general"]
        elif "Químico" in product.name or "Resina" in product.name or "Adhesivo" in product.name:
            possible_suppliers = supplier_map["chemical"] + supplier_map["general"]
        elif any(x in product.name for x in ["Herramienta", "Destornillador", "Taladro", "Sierra", "Llave"]):
            possible_suppliers = supplier_map["tools"] + supplier_map["general"]
        else:
            possible_suppliers = supplier_map["general"]
        
        if not possible_suppliers:
            possible_suppliers = random.sample(suppliers, min(3, len(suppliers)))
        
        # Crear 2-4 opciones de proveedores por producto
        num_suppliers = random.randint(2, min(4, len(possible_suppliers)))
        selected_suppliers = random.sample(possible_suppliers, num_suppliers)
        
        for idx, supplier in enumerate(selected_suppliers):
            base_price = product.standard_cost if product.standard_cost else 10.0
            
            # Variar precios entre proveedores
            price_variation = random.uniform(0.85, 1.20)
            unit_price = round(base_price * price_variation, 2)
            
            # Lead time varía según tipo de proveedor
            if supplier.country != "Bolivia":
                lead_time = random.randint(15, 45)  # Internacional
            else:
                lead_time = random.randint(3, 15)   # Nacional
            
            # Cantidad mínima de pedido
            if product.item_type == "RM":
                min_order = random.choice([10, 20, 50, 100])
            else:
                min_order = random.choice([1, 5, 10])
            
            # Solo el primer proveedor es preferido
            is_preferred = (idx == 0)
            
            supplier_item = SupplierItem(
                supplier_id=supplier.id,
                product_id=product.id,
                supplier_sku=f"{supplier.code}-{product.code}",
                unit_price=unit_price,
                currency="USD" if supplier.country != "Bolivia" else "BOB",
                lead_time_days=lead_time,
                min_order_qty=min_order,
                is_preferred=is_preferred,
                is_active=True,
                org_id=1
            )
            db.session.add(supplier_item)
            supplier_items.append(supplier_item)
    
    db.session.commit()
    print(f"  ✓ {len(supplier_items)} relaciones proveedor-producto creadas")
    print(f"  ✓ Promedio: {len(supplier_items) / len(products):.1f} proveedores por producto")
    return supplier_items

def populate_stock(products, warehouses):
    """Pobla stock inicial en almacenes"""
    print("\n📊 CREANDO STOCK INICIAL...")
    
    stock_items = []
    
    for product in products:
        # Determinar en qué almacenes debe estar
        if product.item_type == "RM":
            target_warehouses = [wh for wh in warehouses if "Materia Prima" in wh.name or "Principal" in wh.name]
        elif product.item_type == "FG":
            target_warehouses = [wh for wh in warehouses if "Productos Terminados" in wh.name or "Principal" in wh.name]
        elif product.item_type == "CONSUMABLE":
            target_warehouses = [wh for wh in warehouses if "Consumibles" in wh.name or "Secundario" in wh.name]
        else:
            target_warehouses = [random.choice(warehouses)]
        
        for warehouse in target_warehouses:
            # Stock aleatorio pero realista
            if product.min_stock and product.max_stock:
                stock = random.randint(
                    int(product.min_stock * 0.5),
                    int(product.max_stock * 0.8)
                )
            else:
                stock = random.randint(10, 100)
            
            pw = ProductWarehouse(
                product_id=product.id,
                warehouse_id=warehouse.id,
                stock=stock,
                org_id=1
            )
            db.session.add(pw)
            stock_items.append(pw)
    
    db.session.commit()
    print(f"  ✓ {len(stock_items)} registros de stock creados")
    return stock_items

def main():
    print("=" * 70)
    print("🚀 LIMPIEZA Y POBLACIÓN MASIVA - SPRINT 3")
    print("=" * 70)
    
    with app.app_context():
        # 1. Limpiar datos existentes
        cleanup_data()
        
        # 2. Crear estructura base
        categories = populate_categories()
        warehouses = populate_warehouses()
        
        # 3. Crear productos
        products = populate_products(categories)
        
        # 4. Crear proveedores (SPRINT 3 FOCUS)
        suppliers = populate_suppliers()
        
        # 5. Crear catálogo proveedor-producto (SPRINT 3 FOCUS)
        supplier_items = populate_supplier_items(products, suppliers)
        
        # 6. Poblar stock inicial
        stock_items = populate_stock(products, warehouses)
        
        print("\n" + "=" * 70)
        print("✅ POBLACIÓN COMPLETADA")
        print("=" * 70)
        print(f"\n📊 RESUMEN:")
        print(f"  • Categorías: {len(categories)}")
        print(f"  • Almacenes: {len(warehouses)}")
        print(f"  • Productos: {len(products)}")
        print(f"  • Proveedores: {len(suppliers)} (5 nacionales + 5 internacionales + 3 extras)")
        print(f"  • Catálogo Proveedor-Producto: {len(supplier_items)}")
        print(f"  • Registros de Stock: {len(stock_items)}")
        
        print(f"\n💡 DATOS LISTOS PARA:")
        print(f"  ✓ Sprint 3: Gestión de proveedores completa")
        print(f"  ✓ Reportes IA: Consultas sobre productos y proveedores")
        print(f"  ✓ Testing: Relaciones múltiples proveedor-producto")
        print("=" * 70)

if __name__ == '__main__':
    main()
