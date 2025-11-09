#!/usr/bin/env python3
"""
Script de limpieza y población masiva de datos para Sprint 3
- Elimina datos de test
- Crea datos realistas de producción
- Enfoque en proveedores y relaciones proveedor-producto
"""
import sys
sys.path.insert(0, '.')

from sqlalchemy import text
from app.db import db
from app.models.organization import Organization
from app.models.movement import Movement
from app.models.bom import BOM, BOMComponent
from app.models.work_order import WorkOrder
from app.models.product import Product
from app.models.warehouse import Warehouse
from app.models.supplier import Supplier
from app.models.supplier_item import SupplierItem
from app.models.unit import Unit
from app.models.user import User
from run import app
from datetime import datetime, timedelta
import random

def get_real_organization():
    """Obtiene la organización real (Acme S.A., ID=1), excluyendo organizaciones de test"""
    org = Organization.query.filter_by(id=1).first()  # Acme S.A.
    if not org:
        raise Exception("No se encontró la organización Acme S.A. (ID=1)")
    return org

def get_real_users():
    """Obtiene usuarios reales, excluyendo usuarios de test"""
    # IDs 1, 4, 5: Marcelo, Camila, Claudia (usuarios reales)
    # Excluye IDs 6, 7: test@test.com, admin_592@test.com
    users = User.query.filter(User.id.in_([1, 4, 5])).all()
    if not users:
        raise Exception("No se encontraron usuarios reales")
    return users

def cleanup_data():
    """Elimina todos los datos de test manteniendo estructura"""
    print("\n🗑️  Limpiando datos de test...")
    
    with app.app_context():
        try:
            # Usar TRUNCATE CASCADE RESTART IDENTITY para reset completo
            db.session.execute(text("TRUNCATE TABLE movement RESTART IDENTITY CASCADE"))
            db.session.execute(text("TRUNCATE TABLE work_order RESTART IDENTITY CASCADE"))
            db.session.execute(text("TRUNCATE TABLE bom_component RESTART IDENTITY CASCADE"))
            db.session.execute(text("TRUNCATE TABLE bom RESTART IDENTITY CASCADE"))
            db.session.execute(text("TRUNCATE TABLE supplier_item RESTART IDENTITY CASCADE"))
            db.session.execute(text("TRUNCATE TABLE supplier RESTART IDENTITY CASCADE"))
            db.session.execute(text("TRUNCATE TABLE product_warehouse RESTART IDENTITY CASCADE"))
            db.session.execute(text("TRUNCATE TABLE product RESTART IDENTITY CASCADE"))
            db.session.execute(text("TRUNCATE TABLE warehouse RESTART IDENTITY CASCADE"))
            
            # Categorias puede no existir
            try:
                db.session.execute(text("TRUNCATE TABLE categorias RESTART IDENTITY CASCADE"))
                print("  ✓ Todas las tablas truncadas con RESTART IDENTITY")
            except:
                print("  ✓ Tablas principales truncadas (categorías no existe)")
            
            db.session.commit()
            print("✅ Limpieza completada\n")
            
        except Exception as e:
            db.session.rollback()
            print(f"❌ Error en limpieza: {e}")
            raise

def populate_categories():
    """Crea categorías base (opcional, solo si existe la tabla)"""
    print("📦 Verificando categorías...")
    
    with app.app_context():
        # Categorías pueden no existir en este esquema
        try:
            result = db.session.execute(text("SELECT COUNT(*) FROM categorias"))
            count = result.scalar()
            print(f"  ℹ️  Tabla categorías existe ({count} registros)")
        except:
            db.session.rollback()
            print(f"  ℹ️  Tabla categorías no existe, continuando sin categorías\n")
            return
        
        # Si llegamos aquí, la tabla existe
        print("  ✓ Categorías verificadas\n")

def populate_warehouses():
    """Crea almacenes"""
    print("🏢 Creando almacenes...")
    
    warehouses_data = [
        ("Almacén Central", "Av. Principal 123, Santa Cruz"),
        ("Almacén Norte", "Zona Industrial Norte, Santa Cruz"),
        ("Almacén de Materia Prima", "Parque Industrial km 7, Santa Cruz"),
        ("Almacén de Producto Terminado", "Centro Logístico, Santa Cruz"),
        ("Almacén de Consumibles", "Depósito Central, Santa Cruz"),
    ]
    
    with app.app_context():
        org = get_real_organization()
        
        for name, location in warehouses_data:
            wh = Warehouse(
                name=name,
                location=location,
                org_id=org.id
            )
            db.session.add(wh)
        
        db.session.commit()
        print(f"  ✓ {len(warehouses_data)} almacenes creados\n")

def populate_products():
    """Crea productos variados - 130+ productos"""
    print("🛠️  Creando productos...")
    
    products_data = [
        # ==================== MATERIAS PRIMAS (30) ====================
        ("Acero Inoxidable 304", "ACER-304", "Lámina de acero inoxidable 1.5mm"),
        ("Acero Carbono 1020", "ACER-1020", "Barra redonda acero al carbono 1 pulgada"),
        ("Acero Galvanizado", "ACER-GALV", "Lámina galvanizada calibre 18"),
        ("Aluminio 6061", "ALU-6061", "Barra de aluminio extruido"),
        ("Aluminio 7075", "ALU-7075", "Placa de aluminio aeronáutico"),
        ("Bronce SAE 40", "BRON-40", "Barra de bronce fosforado"),
        ("Latón 60/40", "LAT-6040", "Tubo de latón 3/4 pulgada"),
        ("Cobre C110", "COB-C110", "Cable de cobre calibre 12"),
        ("Cobre Electrolítico", "COB-ELEC", "Barra de cobre puro 99.9%"),
        ("Plástico ABS", "PLAS-ABS", "Gránulos de plástico ABS"),
        ("Plástico HDPE", "PLAS-HDPE", "Polietileno alta densidad natural"),
        ("Plástico PVC", "PLAS-PVC", "PVC rígido en polvo"),
        ("Nylon 6", "NYL-6", "Barras de nylon 6 natural"),
        ("Teflón PTFE", "TEFL-PTFE", "Placa de teflón blanco"),
        ("Caucho Nitrilo", "CAU-NIT", "Lámina de caucho nitrilo"),
        ("Silicona Industrial", "SIL-IND", "Silicona líquida RTV"),
        ("PVC Rígido", "PVC-RIG", "Tubería PVC presión 1/2 pulgada"),
        ("Fibra de Vidrio", "FIB-VID", "Tela de fibra de vidrio"),
        ("Resina Epoxi", "RES-EPO", "Resina epoxi bicomponente"),
        ("Madera Pino", "MAD-PINO", "Tablón de pino 2x4 pulgadas"),
        ("MDF 15mm", "MDF-15", "Plancha MDF 15mm"),
        ("Triplay 12mm", "TRIP-12", "Plancha triplay 12mm"),
        ("Vidrio Templado", "VID-TEMP", "Vidrio templado 6mm"),
        ("Pintura Epóxica", "PINT-EPO", "Pintura epóxica industrial galón"),
        ("Thinner Acrílico", "THIN-ACR", "Diluyente acrílico galón"),
        ("Cemento Gris", "CEM-GRIS", "Cemento portland 50kg"),
        ("Arena Fina", "AREN-FIN", "Arena fina lavada m³"),
        ("Grava 3/4", "GRAV-34", "Grava chancada 3/4 pulgada"),
        ("Cal Hidratada", "CAL-HID", "Cal hidratada 25kg"),
        ("Yeso Blanco", "YES-BLAN", "Yeso blanco bolsa 25kg"),
        
        # ==================== COMPONENTES ELÉCTRICOS (30) ====================
        ("Motor Eléctrico 1HP", "MOT-1HP", "Motor monofásico 1HP 110V"),
        ("Motor Eléctrico 3HP", "MOT-3HP", "Motor trifásico 3HP 220V"),
        ("Motor Eléctrico 5HP", "MOT-5HP", "Motor trifásico 5HP 440V"),
        ("Motor Eléctrico 10HP", "MOT-10HP", "Motor trifásico 10HP 440V"),
        ("Transformador 500VA", "TRANS-500", "Transformador 220/110V 500VA"),
        ("Transformador 1KVA", "TRANS-1K", "Transformador trifásico 1KVA"),
        ("Transformador 5KVA", "TRANS-5K", "Transformador trifásico 5KVA"),
        ("Contactor 25A", "CONT-25A", "Contactor tripolar 25A"),
        ("Contactor 40A", "CONT-40A", "Contactor tripolar 40A"),
        ("Relé Térmico 10A", "RELE-10A", "Relé térmico 7-10A"),
        ("Relé Térmico 25A", "RELE-25A", "Relé térmico 18-25A"),
        ("Interruptor Termomagnético 20A", "ITM-20A", "Breaker 1P 20A"),
        ("Interruptor Termomagnético 50A", "ITM-50A", "Breaker 3P 50A"),
        ("Interruptor Termomagnético 100A", "ITM-100A", "Breaker 3P 100A"),
        ("Cable NYY 3x10", "CAB-NYY-10", "Cable NYY 3x10mm²"),
        ("Cable THW 12 AWG", "CAB-THW-12", "Cable THW calibre 12"),
        ("Cable THW 8 AWG", "CAB-THW-8", "Cable THW calibre 8"),
        ("Tablero Eléctrico 24 Polos", "TAB-24P", "Tablero embutir 24 módulos"),
        ("Tablero Eléctrico 36 Polos", "TAB-36P", "Tablero embutir 36 módulos"),
        ("Pulsador Verde", "PULS-VER", "Pulsador NA verde"),
        ("Pulsador Rojo", "PULS-ROJO", "Pulsador NC rojo seta"),
        ("Lámpara Piloto Amarilla", "LAMP-AMA", "Luz piloto amarilla LED"),
        ("Lámpara Piloto Roja", "LAMP-ROJA", "Luz piloto roja LED"),
        ("Sensor Inductivo", "SENS-IND", "Sensor proximidad inductivo NPN"),
        ("Sensor Capacitivo", "SENS-CAP", "Sensor capacitivo PNP"),
        ("Fotosensor Infrarrojo", "FOTO-IR", "Fotocélula infrarroja"),
        ("Relé Temporizador", "RELE-TMP", "Relé retardo 0-60s"),
        ("PLC S7-200", "PLC-S7", "PLC Siemens S7-200 CPU 224"),
        ("Variador Frecuencia 2HP", "VFD-2HP", "Variador velocidad 2HP 220V"),
        ("Electroválvula 1/2\"", "ELEC-VAL", "Electroválvula solenoide 1/2 pulgada"),
        
        # ==================== COMPONENTES MECÁNICOS (30) ====================
        ("Rodamiento 6204", "ROD-6204", "Rodamiento de bolas 6204-2RS"),
        ("Rodamiento 6205", "ROD-6205", "Rodamiento de bolas 6205-2RS"),
        ("Rodamiento 6206", "ROD-6206", "Rodamiento de bolas 6206-2RS"),
        ("Rodamiento 6207", "ROD-6207", "Rodamiento de bolas 6207-2RS"),
        ("Rodamiento Cónico", "ROD-CON", "Rodamiento cónico 30205"),
        ("Retenedor 25x40", "RET-2540", "Retenedor labio 25x40x7"),
        ("Retenedor 30x47", "RET-3047", "Retenedor labio 30x47x7"),
        ("Chaveta 6x6x20", "CHAV-6", "Chaveta cuadrada 6x6x20mm"),
        ("Chaveta 8x7x25", "CHAV-8", "Chaveta cuadrada 8x7x25mm"),
        ("Eje Acero 25mm", "EJE-25", "Eje acero calibrado 25mm x 1m"),
        ("Eje Acero 30mm", "EJE-30", "Eje acero calibrado 30mm x 1m"),
        ("Polea Tipo A 3\"", "POL-A3", "Polea trapecial tipo A 3 pulgadas"),
        ("Polea Tipo B 6\"", "POL-B6", "Polea trapecial tipo B 6 pulgadas"),
        ("Correa Tipo A48", "COR-A48", "Correa trapecial A48"),
        ("Correa Tipo B60", "COR-B60", "Correa trapecial B60"),
        ("Cadena 40-1", "CAD-40", "Cadena transmisión 40-1"),
        ("Piñón 40-20T", "PIN-4020", "Piñón cadena 40 paso 20 dientes"),
        ("Engranaje Recto Z20", "ENG-Z20", "Engranaje recto módulo 2 Z20"),
        ("Resorte Compresión", "RES-COMP", "Resorte de compresión 50mm"),
        ("Resorte Tracción", "RES-TRAC", "Resorte de tracción 40mm"),
        ("Amortiguador Neumático", "AMOR-NEU", "Amortiguador neumático ajustable"),
        ("Cilindro Neumático 50mm", "CIL-50", "Cilindro doble efecto 50mm stroke"),
        ("Válvula Neumática 5/2", "VAL-52", "Válvula 5/2 vías piloto neumático"),
        ("Manómetro 0-10bar", "MAN-10B", "Manómetro glicerina 0-10bar"),
        ("Racor Rápido 1/4\"", "RAC-14", "Racor rápido neumático 1/4 pulgada"),
        ("Manguera Neumática", "MANG-NEU", "Manguera poliuretano 6mm"),
        ("Filtro Regulador", "FILT-REG", "Unidad FRL 1/4 pulgada"),
        ("Silenciador Neumático", "SIL-NEU", "Silenciador escape 1/8 pulgada"),
        
        # ==================== TORNILLERÍA Y FIJACIÓN (15) ====================
        ("Tornillo M6x20", "TOR-M6-20", "Tornillo hexagonal M6x20 acero"),
        ("Tornillo M8x50", "TOR-M8-50", "Tornillo hexagonal M8x50 acero"),
        ("Tornillo M10x60", "TOR-M10-60", "Tornillo hexagonal M10x60 acero"),
        ("Tornillo M12x80", "TOR-M12-80", "Tornillo hexagonal M12x80 acero"),
        ("Arandela M6", "ARN-M6", "Arandela plana M6 zincada"),
        ("Arandela M8", "ARN-M8", "Arandela plana M8 zincada"),
        ("Arandela M10", "ARN-M10", "Arandela plana M10 zincada"),
        ("Arandela Presión M8", "ARP-M8", "Arandela presión M8"),
        ("Tuerca M8", "TUE-M8", "Tuerca hexagonal M8"),
        ("Tuerca M10", "TUE-M10", "Tuerca hexagonal M10"),
        ("Perno Anclaje", "PERN-ANC", "Perno expansión 3/8x3 pulgadas"),
        ("Remache Pop 4mm", "REM-4", "Remache pop aluminio 4mm"),
        ("Grapa Omega", "GRAP-OME", "Grapa omega para tubería"),
        ("Abrazadera 2\"", "ABRAZ-2", "Abrazadera tipo gusano 2 pulgadas"),
        ("Prisionero M6", "PRIS-M6", "Tornillo prisionero M6x10 punta copa"),
        
        # ==================== HERRAMIENTAS (10) ====================
        ("Taladro Industrial", "TAL-IND", "Taladro de banco 1/2 pulgada"),
        ("Amoladora 7\"", "AMOL-7", "Amoladora angular 7 pulgadas 2000W"),
        ("Sierra Circular", "SIER-CIR", "Sierra circular 7 1/4 pulgadas"),
        ("Soldadora Inverter", "SOLD-INV", "Soldadora inverter 200A"),
        ("Llave Inglesa 12\"", "LLA-12", "Llave ajustable 12 pulgadas"),
        ("Destornillador Set", "DES-SET", "Set de destornilladores 6 piezas"),
        ("Calibrador Digital", "CAL-DIG", "Calibrador vernier digital 6 pulgadas"),
        ("Micrómetro 0-25mm", "MIC-25", "Micrómetro exterior 0-25mm"),
        ("Prensa Banco 6\"", "PREN-6", "Prensa tornillo banco 6 pulgadas"),
        ("Compresor 50L", "COMP-50L", "Compresor aire 2HP tanque 50L"),
        
        # ==================== CONSUMIBLES (10) ====================
        ("Soldadura Estaño", "SOL-EST", "Soldadura estaño-plomo 60/40"),
        ("Electrodo 3/32", "ELEC-332", "Electrodo 6013 3/32 pulgada"),
        ("Disco Corte Metal 7\"", "DISC-MET", "Disco corte metal 7 pulgadas"),
        ("Disco Desbaste 7\"", "DISC-DES", "Disco desbaste 7 pulgadas"),
        ("Aceite Lubricante", "ACE-LUB", "Aceite lubricante industrial 1L"),
        ("Grasa Multiuso", "GRAS-MUL", "Grasa litio multiuso 500g"),
        ("Lija Grano 120", "LIJ-120", "Lija de papel grano 120"),
        ("Cinta Aislante", "CIN-AIS", "Cinta aislante negra 20m"),
        ("Guantes Nitrilo", "GUA-NIT", "Guantes nitrilo talla M (caja 100)"),
        ("Guantes Cuero", "GUA-CUER", "Guantes carnaza soldador"),
        
        # ==================== PRODUCTOS TERMINADOS (15) ====================
        ("Válvula Check 1/2\"", "VAL-CHK-12", "Válvula check bronce 1/2 pulgada"),
        ("Válvula Bola 3/4\"", "VAL-BOL-34", "Válvula bola latón 3/4 pulgada"),
        ("Válvula Mariposa 2\"", "VAL-MAR-2", "Válvula mariposa hierro 2 pulgadas"),
        ("Bomba Centrífuga 1HP", "BOM-CEN-1", "Bomba centrífuga 1HP monofásica"),
        ("Bomba Periférica 0.5HP", "BOM-PER", "Bomba periférica 0.5HP"),
        ("Panel de Control", "PAN-CTL", "Panel de control eléctrico 220V"),
        ("Caja Distribución", "CAJ-DIS", "Caja distribución eléctrica 12 módulos"),
        ("Ventilador Industrial", "VEN-IND", "Ventilador industrial 24 pulgadas"),
        ("Extractor Aire", "EXT-AIRE", "Extractor axial 12 pulgadas"),
        ("Reductor Velocidad", "RED-VEL", "Reductor velocidad 1:40"),
        ("Filtro Agua 10\"", "FILT-AG", "Filtro agua cartucho 10 pulgadas"),
        ("Tanque Hidroneumático", "TANQ-HID", "Tanque hidroneumático 24L"),
        ("Compresor Portátil", "COMP-PORT", "Compresor portátil 6L sin aceite"),
        ("Esmeril Banco", "ESM-BANC", "Esmeril de banco 6 pulgadas"),
        ("Hidrolavadora", "HIDR-LAV", "Hidrolavadora 1800PSI"),
    ]
    
    with app.app_context():
        org = get_real_organization()
        
        for name, code, desc in products_data:
            product = Product(
                code=code,
                name=name,
                description=desc,
                org_id=org.id,
                min_stock=10
            )
            db.session.add(product)
        
        db.session.commit()
        print(f"  ✓ {len(products_data)} productos creados\n")

def populate_suppliers():
    """Crea proveedores nacionales e internacionales"""
    print("🏭 Creando proveedores...")
    
    suppliers_data = [
        # Proveedores Nacionales (Bolivia)
        ("Aceros Bolivia S.A.", "aceros.bolivia@email.com", "+591-3-3334455", "+591-70000001", "Av. Industrial 456", "Santa Cruz"),
        ("Distribuidora Industrial SCZ", "ventas@disindustrial.bo", "+591-3-3556677", "+591-70000002", "Zona Norte", "Santa Cruz"),
        ("Importadora La Paz", "info@implp.com.bo", "+591-2-2445566", "+591-70000003", "Calle Comercio 789", "La Paz"),
        ("Suministros Industriales Cochabamba", "suministros@sicbba.bo", "+591-4-4223344", "+591-70000004", "Av. América 123", "Cochabamba"),
        ("Ferretería Industrial del Sur", "ventas@fersur.bo", "+591-3-3778899", "+591-70000005", "Radial 26", "Santa Cruz"),
        
        # Proveedores Internacionales
        ("Steel Suppliers USA Inc.", "sales@steelusa.com", "+1-713-555-0123", "+1-713-555-0124", "Houston, TX 77001", "Houston"),
        ("German Tools GmbH", "export@germantools.de", "+49-89-12345678", "+49-89-12345679", "Munich, Bavaria", "Munich"),
        ("Shanghai Industrial Co.", "info@shanghaiind.cn", "+86-21-98765432", "+86-21-98765433", "Pudong District", "Shanghai"),
        ("Brasil Componentes Ltda", "vendas@brasilcomp.com.br", "+55-11-3456-7890", "+55-11-3456-7891", "São Paulo, SP", "São Paulo"),
        ("Argentina Metales S.A.", "exportacion@argmetales.com.ar", "+54-11-4567-8901", "+54-11-4567-8902", "Buenos Aires", "Buenos Aires"),
        
        # Proveedores adicionales Bolivia
        ("Eléctrica Industrial Santa Cruz", "electrica@eisc.bo", "+591-3-3112233", "+591-70000006", "3er Anillo", "Santa Cruz"),
        ("Plásticos del Oriente", "plasticos@oriente.bo", "+591-3-3445566", "+591-70000007", "Parque Industrial", "Santa Cruz"),
        ("Herramientas Profesionales Bolivia", "herramientas@hpbolivia.bo", "+591-2-2667788", "+591-70000008", "El Alto", "El Alto"),
    ]
    
    with app.app_context():
        org = get_real_organization()
        
        for name, email, phone, mobile, address, city in suppliers_data:
            supplier = Supplier(
                name=name,
                email=email,
                phone=phone,
                mobile=mobile,
                address=address,
                city=city,
                org_id=org.id,
                status=True
            )
            db.session.add(supplier)
        
        db.session.commit()
        print(f"  ✓ {len(suppliers_data)} proveedores creados\n")

def populate_supplier_items():
    """Crea relaciones proveedor-producto con múltiples proveedores por producto"""
    print("🔗 Creando relaciones proveedor-producto...")
    
    with app.app_context():
        org = get_real_organization()
        products = Product.query.all()
        suppliers = Supplier.query.all()
        
        # Proveedores nacionales (city bolivianas)
        nacional_cities = ["Santa Cruz", "La Paz", "Cochabamba", "El Alto"]
        nacional = [s for s in suppliers if s.city in nacional_cities]
        internacional = [s for s in suppliers if s.city not in nacional_cities]
        
        count = 0
        for idx, product in enumerate(products):
            # Cada producto tendrá 2-3 proveedores
            num_suppliers = 3 if idx % 2 == 0 else 2
            
            # Seleccionar proveedores
            selected = []
            if num_suppliers >= 2 and len(nacional) > 0 and len(internacional) > 0:
                selected.append(nacional[idx % len(nacional)])
                selected.append(internacional[idx % len(internacional)])
            if num_suppliers >= 3 and len(nacional) > 1:
                selected.append(nacional[(idx + 1) % len(nacional)])
            
            # Crear relaciones
            for sup_idx, supplier in enumerate(selected):
                # Variación de precio: ±20%
                price_variation = 1.0 + (sup_idx * 0.1) - 0.1
                unit_price = 10.00 * price_variation  # Precio base
                
                # Lead time: nacionales 3-15 días, internacionales 15-45 días
                is_nacional = supplier.city in nacional_cities
                if is_nacional:
                    lead_time = 3 + (sup_idx * 4)
                else:
                    lead_time = 15 + (sup_idx * 10)
                
                # MOQ: depende del tipo de producto
                if "Tornillo" in product.name or "Arandela" in product.name or "Resistencia" in product.name:
                    moq = 100 + (sup_idx * 50)
                elif "Motor" in product.name or "Panel" in product.name or "Bomba" in product.name:
                    moq = 1 + sup_idx
                else:
                    moq = 10 + (sup_idx * 5)
                
                supplier_item = SupplierItem(
                    supplier_id=supplier.id,
                    product_id=product.id,
                    org_id=org.id,
                    price=round(unit_price, 2),
                    currency='BOB',
                    lead_time_days=lead_time,
                    min_order_qty=moq,
                    is_preferred=(sup_idx == 0),  # Primer proveedor es preferido
                    is_active=True
                )
                db.session.add(supplier_item)
                count += 1
        
        db.session.commit()
        print(f"  ✓ {count} relaciones proveedor-producto creadas\n")

def populate_stock():
    """Crea stock inicial en almacenes"""
    print("📊 Creando stock inicial...")
    
    with app.app_context():
        from app.models.product_warehouse import ProductWarehouse
        
        products = Product.query.all()
        warehouses = Warehouse.query.all()
        
        count = 0
        for idx, product in enumerate(products):
            # Distribuir stock entre 2-3 almacenes por producto
            num_warehouses = 2 if idx % 3 == 0 else 3
            
            for wh_idx in range(num_warehouses):
                warehouse = warehouses[wh_idx % len(warehouses)]
                
                # Cantidad según tipo de producto
                if "Tornillo" in product.name or "Arandela" in product.name:
                    qty = 500 + (wh_idx * 200)
                elif "Motor" in product.name or "Taladro" in product.name:
                    qty = 5 + (wh_idx * 2)
                else:
                    qty = 50 + (wh_idx * 20)
                
                stock = ProductWarehouse(
                    product_id=product.id,
                    warehouse_id=warehouse.id,
                    current_stock=qty
                )
                db.session.add(stock)
                count += 1
        
        db.session.commit()
        print(f"  ✓ {count} registros de stock creados\n")

def populate_boms():
    """Crea BOMs (Listas de Materiales) para productos terminados - 10 BOMs"""
    print("🔧 Creando BOMs...")
    
    with app.app_context():
        org = get_real_organization()
        
        # Obtener unidades
        unit_kg = Unit.query.filter_by(code='KG').first()
        unit_ea = Unit.query.filter_by(code='EA').first()
        unit_m = Unit.query.filter_by(code='M').first()
        
        count = 0
        
        # ========== BOM 1: Válvula Check 1/2" ==========
        valvula_chk = Product.query.filter_by(org_id=org.id, code='VAL-CHK-12').first()
        if valvula_chk:
            bom = BOM(org_id=org.id, product_id=valvula_chk.id, version='1.0', is_active=True,
                     description='Válvula check bronce con asiento')
            db.session.add(bom)
            db.session.flush()
            
            bronce = Product.query.filter_by(org_id=org.id, code='BRON-40').first()
            tornillos = Product.query.filter_by(org_id=org.id, code='TOR-M6-20').first()
            if bronce:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=bronce.id, quantity=0.3,
                    unit_id=unit_kg.id, scrap_percentage=5.0, sequence=1, notes='Cuerpo bronce'))
            if tornillos:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=tornillos.id, quantity=4,
                    unit_id=unit_ea.id, scrap_percentage=2.0, sequence=2, notes='Fijación tapa'))
            count += 1
        
        # ========== BOM 2: Válvula Bola 3/4" ==========
        valvula_bola = Product.query.filter_by(org_id=org.id, code='VAL-BOL-34').first()
        if valvula_bola:
            bom = BOM(org_id=org.id, product_id=valvula_bola.id, version='1.0', is_active=True,
                     description='Válvula de bola latón paso total')
            db.session.add(bom)
            db.session.flush()
            
            laton = Product.query.filter_by(org_id=org.id, code='LAT-6040').first()
            if laton:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=laton.id, quantity=0.4,
                    unit_id=unit_kg.id, scrap_percentage=4.0, sequence=1, notes='Cuerpo y bola latón'))
            count += 1
        
        # ========== BOM 3: Bomba Centrífuga 1HP ==========
        bomba = Product.query.filter_by(org_id=org.id, code='BOM-CEN-1').first()
        if bomba:
            bom = BOM(org_id=org.id, product_id=bomba.id, version='1.0', is_active=True,
                     description='Bomba centrífuga con motor monofásico')
            db.session.add(bom)
            db.session.flush()
            
            motor = Product.query.filter_by(org_id=org.id, code='MOT-1HP').first()
            aluminio = Product.query.filter_by(org_id=org.id, code='ALU-6061').first()
            rodamiento = Product.query.filter_by(org_id=org.id, code='ROD-6204').first()
            retenedor = Product.query.filter_by(org_id=org.id, code='RET-2540').first()
            tornillos_m8 = Product.query.filter_by(org_id=org.id, code='TOR-M8-50').first()
            
            if motor:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=motor.id, quantity=1,
                    unit_id=unit_ea.id, sequence=1, notes='Motor eléctrico'))
            if aluminio:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=aluminio.id, quantity=3.5,
                    unit_id=unit_kg.id, scrap_percentage=8.0, sequence=2, notes='Carcasa fundida'))
            if rodamiento:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=rodamiento.id, quantity=2,
                    unit_id=unit_ea.id, sequence=3, notes='Rodamientos eje'))
            if retenedor:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=retenedor.id, quantity=1,
                    unit_id=unit_ea.id, sequence=4, notes='Sello mecánico'))
            if tornillos_m8:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=tornillos_m8.id, quantity=12,
                    unit_id=unit_ea.id, scrap_percentage=2.0, sequence=5, notes='Ensamble'))
            count += 1
        
        # ========== BOM 4: Panel de Control ==========
        panel = Product.query.filter_by(org_id=org.id, code='PAN-CTL').first()
        if panel:
            bom = BOM(org_id=org.id, product_id=panel.id, version='1.0', is_active=True,
                     description='Panel control eléctrico con PLC')
            db.session.add(bom)
            db.session.flush()
            
            tablero = Product.query.filter_by(org_id=org.id, code='TAB-24P').first()
            plc = Product.query.filter_by(org_id=org.id, code='PLC-S7').first()
            contactor = Product.query.filter_by(org_id=org.id, code='CONT-25A').first()
            pulsador_v = Product.query.filter_by(org_id=org.id, code='PULS-VER').first()
            pulsador_r = Product.query.filter_by(org_id=org.id, code='PULS-ROJO').first()
            cable = Product.query.filter_by(org_id=org.id, code='CAB-THW-12').first()
            
            if tablero:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=tablero.id, quantity=1,
                    unit_id=unit_ea.id, sequence=1, notes='Gabinete metálico'))
            if plc:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=plc.id, quantity=1,
                    unit_id=unit_ea.id, sequence=2, notes='PLC Siemens'))
            if contactor:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=contactor.id, quantity=3,
                    unit_id=unit_ea.id, sequence=3, notes='Contactores potencia'))
            if pulsador_v:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=pulsador_v.id, quantity=2,
                    unit_id=unit_ea.id, sequence=4, notes='Pulsadores marcha'))
            if pulsador_r:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=pulsador_r.id, quantity=1,
                    unit_id=unit_ea.id, sequence=5, notes='Pulsador paro emergencia'))
            if cable:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=cable.id, quantity=50,
                    unit_id=unit_m.id, scrap_percentage=10.0, sequence=6, notes='Cableado interno'))
            count += 1
        
        # ========== BOM 5: Ventilador Industrial ==========
        ventilador = Product.query.filter_by(org_id=org.id, code='VEN-IND').first()
        if ventilador:
            bom = BOM(org_id=org.id, product_id=ventilador.id, version='1.0', is_active=True,
                     description='Ventilador axial industrial 24 pulgadas')
            db.session.add(bom)
            db.session.flush()
            
            motor_3hp = Product.query.filter_by(org_id=org.id, code='MOT-3HP').first()
            acero = Product.query.filter_by(org_id=org.id, code='ACER-GALV').first()
            rodamiento_05 = Product.query.filter_by(org_id=org.id, code='ROD-6205').first()
            
            if motor_3hp:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=motor_3hp.id, quantity=1,
                    unit_id=unit_ea.id, sequence=1, notes='Motor ventilador'))
            if acero:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=acero.id, quantity=15,
                    unit_id=unit_kg.id, scrap_percentage=5.0, sequence=2, notes='Hélice y carcasa'))
            if rodamiento_05:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=rodamiento_05.id, quantity=2,
                    unit_id=unit_ea.id, sequence=3, notes='Rodamientos soporte'))
            count += 1
        
        # ========== BOM 6: Reductor Velocidad ==========
        reductor = Product.query.filter_by(org_id=org.id, code='RED-VEL').first()
        if reductor:
            bom = BOM(org_id=org.id, product_id=reductor.id, version='1.0', is_active=True,
                     description='Reductor velocidad relación 1:40')
            db.session.add(bom)
            db.session.flush()
            
            acero_1020 = Product.query.filter_by(org_id=org.id, code='ACER-1020').first()
            engranaje = Product.query.filter_by(org_id=org.id, code='ENG-Z20').first()
            rodamiento_06 = Product.query.filter_by(org_id=org.id, code='ROD-6206').first()
            aceite = Product.query.filter_by(org_id=org.id, code='ACE-LUB').first()
            
            if acero_1020:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=acero_1020.id, quantity=25,
                    unit_id=unit_kg.id, scrap_percentage=3.0, sequence=1, notes='Carcasa fundida'))
            if engranaje:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=engranaje.id, quantity=4,
                    unit_id=unit_ea.id, sequence=2, notes='Tren de engranajes'))
            if rodamiento_06:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=rodamiento_06.id, quantity=4,
                    unit_id=unit_ea.id, sequence=3, notes='Rodamientos ejes'))
            if aceite:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=aceite.id, quantity=2,
                    unit_id=unit_ea.id, sequence=4, notes='Aceite lubricante'))
            count += 1
        
        # ========== BOM 7: Caja Distribución ==========
        caja = Product.query.filter_by(org_id=org.id, code='CAJ-DIS').first()
        if caja:
            bom = BOM(org_id=org.id, product_id=caja.id, version='1.0', is_active=True,
                     description='Caja distribución eléctrica residencial')
            db.session.add(bom)
            db.session.flush()
            
            plastico_pvc = Product.query.filter_by(org_id=org.id, code='PLAS-PVC').first()
            breaker_20 = Product.query.filter_by(org_id=org.id, code='ITM-20A').first()
            
            if plastico_pvc:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=plastico_pvc.id, quantity=1.5,
                    unit_id=unit_kg.id, scrap_percentage=5.0, sequence=1, notes='Caja plástica moldeada'))
            if breaker_20:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=breaker_20.id, quantity=6,
                    unit_id=unit_ea.id, sequence=2, notes='Breakers monopolares'))
            count += 1
        
        # ========== BOM 8: Extractor Aire ==========
        extractor = Product.query.filter_by(org_id=org.id, code='EXT-AIRE').first()
        if extractor:
            bom = BOM(org_id=org.id, product_id=extractor.id, version='1.0', is_active=True,
                     description='Extractor axial para baño/cocina')
            db.session.add(bom)
            db.session.flush()
            
            motor_1hp = Product.query.filter_by(org_id=org.id, code='MOT-1HP').first()
            plastico_abs = Product.query.filter_by(org_id=org.id, code='PLAS-ABS').first()
            
            if motor_1hp:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=motor_1hp.id, quantity=1,
                    unit_id=unit_ea.id, sequence=1, notes='Motor extractor'))
            if plastico_abs:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=plastico_abs.id, quantity=0.8,
                    unit_id=unit_kg.id, scrap_percentage=8.0, sequence=2, notes='Hélice y carcasa plástica'))
            count += 1
        
        # ========== BOM 9: Compresor Portátil ==========
        compresor_port = Product.query.filter_by(org_id=org.id, code='COMP-PORT').first()
        if compresor_port:
            bom = BOM(org_id=org.id, product_id=compresor_port.id, version='1.0', is_active=True,
                     description='Compresor portátil 6L sin aceite')
            db.session.add(bom)
            db.session.flush()
            
            motor_1hp = Product.query.filter_by(org_id=org.id, code='MOT-1HP').first()
            acero_galv = Product.query.filter_by(org_id=org.id, code='ACER-GALV').first()
            manometro = Product.query.filter_by(org_id=org.id, code='MAN-10B').first()
            
            if motor_1hp:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=motor_1hp.id, quantity=1,
                    unit_id=unit_ea.id, sequence=1, notes='Motor compresor'))
            if acero_galv:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=acero_galv.id, quantity=3,
                    unit_id=unit_kg.id, scrap_percentage=4.0, sequence=2, notes='Tanque 6L'))
            if manometro:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=manometro.id, quantity=1,
                    unit_id=unit_ea.id, sequence=3, notes='Manómetro presión'))
            count += 1
        
        # ========== BOM 10: Filtro Agua 10" ==========
        filtro = Product.query.filter_by(org_id=org.id, code='FILT-AG').first()
        if filtro:
            bom = BOM(org_id=org.id, product_id=filtro.id, version='1.0', is_active=True,
                     description='Filtro agua con cartucho 10 pulgadas')
            db.session.add(bom)
            db.session.flush()
            
            plastico_hdpe = Product.query.filter_by(org_id=org.id, code='PLAS-HDPE').first()
            
            if plastico_hdpe:
                db.session.add(BOMComponent(bom_id=bom.id, component_id=plastico_hdpe.id, quantity=0.5,
                    unit_id=unit_kg.id, scrap_percentage=5.0, sequence=1, notes='Carcasa plástica'))
            count += 1
        
        db.session.commit()
        print(f"  ✓ {count} BOMs creadas\n")

def populate_work_orders():
    """Crea órdenes de producción en diferentes estados - 15 Work Orders"""
    print("📋 Creando Work Orders...")
    
    with app.app_context():
        org = get_real_organization()
        
        # Obtener BOMs activas
        boms = BOM.query.filter_by(org_id=org.id, is_active=True).all()
        if not boms:
            print("  ⚠️  No hay BOMs activas")
            return
        
        # Obtener almacén y usuarios reales
        warehouse_pt = Warehouse.query.filter_by(org_id=org.id, name='Producto Terminado').first()
        warehouse_central = Warehouse.query.filter_by(org_id=org.id, name='Almacén Central').first()
        users = get_real_users()
        
        count = 0
        now = datetime.utcnow()
        
        # Generar 15 Work Orders con diferentes estados y fechas
        work_orders_config = [
            # Órdenes FINALIZADAS (pasado reciente)
            {'bom_idx': 0, 'qty': 10, 'status': WorkOrder.STATUS_FINISHED, 'ref': 'WO-2025-001', 
             'notes': 'Orden finalizada - Cliente XYZ', 'days_start': -7, 'days_end': -3, 'user_idx': 0},
            {'bom_idx': 1, 'qty': 5, 'status': WorkOrder.STATUS_FINISHED, 'ref': 'WO-2025-002',
             'notes': 'Producción completada', 'days_start': -10, 'days_end': -5, 'user_idx': 1},
            {'bom_idx': 2, 'qty': 8, 'status': WorkOrder.STATUS_FINISHED, 'ref': 'WO-2025-003',
             'notes': 'Orden urgente completada', 'days_start': -6, 'days_end': -2, 'user_idx': 0},
            
            # Órdenes EN PROGRESO (actuales)
            {'bom_idx': 3, 'qty': 12, 'status': WorkOrder.STATUS_IN_PROGRESS, 'ref': 'WO-2025-004',
             'notes': 'En producción - Cliente ABC', 'days_start': -2, 'days_end': 3, 'user_idx': 1},
            {'bom_idx': 4, 'qty': 6, 'status': WorkOrder.STATUS_IN_PROGRESS, 'ref': 'WO-2025-005',
             'notes': 'Orden en proceso', 'days_start': -1, 'days_end': 2, 'user_idx': 2},
            {'bom_idx': 5, 'qty': 15, 'status': WorkOrder.STATUS_IN_PROGRESS, 'ref': 'WO-2025-006',
             'notes': 'Producción prioritaria', 'days_start': 0, 'days_end': 4, 'user_idx': 0},
            
            # Órdenes PLANIFICADAS (futuro)
            {'bom_idx': 6, 'qty': 20, 'status': WorkOrder.STATUS_PLANNED, 'ref': 'WO-2025-007',
             'notes': 'Orden programada próxima semana', 'days_start': 5, 'days_end': 9, 'user_idx': 1},
            {'bom_idx': 7, 'qty': 10, 'status': WorkOrder.STATUS_PLANNED, 'ref': 'WO-2025-008',
             'notes': 'Producción stock', 'days_start': 3, 'days_end': 7, 'user_idx': 0},
            {'bom_idx': 8, 'qty': 25, 'status': WorkOrder.STATUS_PLANNED, 'ref': 'WO-2025-009',
             'notes': 'Orden gran volumen', 'days_start': 7, 'days_end': 14, 'user_idx': 2},
            {'bom_idx': 9, 'qty': 8, 'status': WorkOrder.STATUS_PLANNED, 'ref': 'WO-2025-010',
             'notes': 'Cliente preferencial', 'days_start': 10, 'days_end': 15, 'user_idx': 1},
            {'bom_idx': 0, 'qty': 12, 'status': WorkOrder.STATUS_PLANNED, 'ref': 'WO-2025-011',
             'notes': 'Reposición stock', 'days_start': 14, 'days_end': 20, 'user_idx': 0},
            
            # Órdenes CANCELADAS
            {'bom_idx': 1, 'qty': 5, 'status': WorkOrder.STATUS_CANCELLED, 'ref': 'WO-2025-012',
             'notes': 'Cancelada por cliente', 'days_start': 1, 'days_end': 5, 'user_idx': 1},
            {'bom_idx': 2, 'qty': 3, 'status': WorkOrder.STATUS_CANCELLED, 'ref': 'WO-2025-013',
             'notes': 'Falta de material', 'days_start': 2, 'days_end': 6, 'user_idx': 0},
            
            # Más órdenes planificadas
            {'bom_idx': 3, 'qty': 18, 'status': WorkOrder.STATUS_PLANNED, 'ref': 'WO-2025-014',
             'notes': 'Orden próximo mes', 'days_start': 21, 'days_end': 28, 'user_idx': 2},
            {'bom_idx': 4, 'qty': 30, 'status': WorkOrder.STATUS_PLANNED, 'ref': 'WO-2025-015',
             'notes': 'Producción futura - Cliente Premium', 'days_start': 30, 'days_end': 40, 'user_idx': 1},
        ]
        
        for config in work_orders_config:
            # Usar índice modular para BOMs
            bom = boms[config['bom_idx'] % len(boms)]
            user = users[config['user_idx'] % len(users)] if users else None
            warehouse = warehouse_pt if count % 2 == 0 else warehouse_central
            
            # Calcular fechas
            planned_start = now + timedelta(days=config['days_start'])
            planned_end = now + timedelta(days=config['days_end'])
            
            # Fechas reales según estado
            actual_start = None
            actual_end = None
            if config['status'] == WorkOrder.STATUS_FINISHED:
                actual_start = planned_start
                actual_end = planned_end - timedelta(hours=random.randint(0, 24))
            elif config['status'] == WorkOrder.STATUS_IN_PROGRESS:
                actual_start = planned_start
            
            wo = WorkOrder(
                org_id=org.id,
                product_id=bom.product_id,
                bom_id=bom.id,
                quantity=config['qty'],
                status=config['status'],
                warehouse_id=warehouse.id if warehouse else None,
                assigned_to=user.id if user else None,
                reference=config['ref'],
                notes=config['notes'],
                planned_start=planned_start,
                planned_end=planned_end,
                actual_start=actual_start,
                actual_end=actual_end,
                created_by=user.id if user else None
            )
            db.session.add(wo)
            count += 1
        
        db.session.commit()
        print(f"  ✓ {count} Work Orders creadas\n")

def populate_movements():
    """Crea movimientos de inventario (entradas, salidas, transferencias) - 60+ movements"""
    print("📦 Creando Movements...")
    
    with app.app_context():
        org = get_real_organization()
        
        # Obtener productos, almacenes y usuarios reales
        products = Product.query.filter_by(org_id=org.id).all()
        warehouses = Warehouse.query.filter_by(org_id=org.id).all()
        users = get_real_users()
        
        if not products or not warehouses:
            print("  ⚠️  Faltan productos o almacenes")
            return
        
        count = 0
        now = datetime.utcnow()
        
        # ========== COMPRAS - Entradas de material (20 movimientos) ==========
        for i in range(20):
            product = products[i % len(products)]
            warehouse = warehouses[i % len(warehouses)]
            user = users[i % len(users)] if users else None
            
            qty = random.randint(50, 500) if 'TOR' in product.code or 'ARN' in product.code else random.randint(10, 100)
            
            mov = Movement(
                org_id=org.id,
                product_id=product.id,
                to_warehouse_id=warehouse.id,
                movement_type='IN',
                reason='PURCHASE',
                quantity=qty,
                reference_id=f'PO-2025-{str(i+1).zfill(3)}',
                reference_type='PO',
                note=f'Compra proveedor - Lote {i+1}',
                created_by=user.id if user else None,
                created_at=now - timedelta(days=random.randint(1, 30))
            )
            db.session.add(mov)
            count += 1
        
        # ========== CONSUMOS - Salidas para producción (15 movimientos) ==========
        for i in range(15):
            product = products[i % min(30, len(products))]  # Usar primeros 30 productos (materias primas/componentes)
            warehouse = warehouses[(i % 2) + 2] if len(warehouses) > 2 else warehouses[0]  # Almacén Materia Prima
            user = users[i % len(users)] if users else None
            
            qty = random.randint(10, 50)
            wo_ref = f'{(i % 15) + 1}'  # Referencias a Work Orders 1-15
            
            mov = Movement(
                org_id=org.id,
                product_id=product.id,
                from_warehouse_id=warehouse.id,
                movement_type='OUT',
                reason='CONSUMPTION',
                quantity=qty,
                reference_id=wo_ref,
                reference_type='WO',
                note=f'Consumo para WO-2025-{str(i+1).zfill(3)}',
                created_by=user.id if user else None,
                created_at=now - timedelta(days=random.randint(0, 10))
            )
            db.session.add(mov)
            count += 1
        
        # ========== PRODUCCIÓN - Entradas de productos terminados (10 movimientos) ==========
        finished_products = [p for p in products if any(x in p.code for x in ['VAL-', 'BOM-', 'PAN-', 'CAJ-', 'VEN-'])]
        for i in range(min(10, len(finished_products))):
            product = finished_products[i]
            warehouse_pt = Warehouse.query.filter_by(org_id=org.id, name='Producto Terminado').first()
            user = users[i % len(users)] if users else None
            
            qty = random.randint(5, 25)
            
            mov = Movement(
                org_id=org.id,
                product_id=product.id,
                to_warehouse_id=warehouse_pt.id if warehouse_pt else warehouses[0].id,
                movement_type='IN',
                reason='PRODUCTION',
                quantity=qty,
                reference_id=f'{i+1}',
                reference_type='WO',
                note=f'Producción WO-2025-{str(i+1).zfill(3)} completada',
                created_by=user.id if user else None,
                created_at=now - timedelta(days=random.randint(1, 7))
            )
            db.session.add(mov)
            count += 1
        
        # ========== TRANSFERENCIAS - Entre almacenes (10 movimientos) ==========
        for i in range(10):
            product = products[(i * 3) % len(products)]
            from_wh = warehouses[i % len(warehouses)]
            to_wh = warehouses[(i + 1) % len(warehouses)]
            user = users[i % len(users)] if users else None
            
            if from_wh.id != to_wh.id:
                qty = random.randint(20, 100)
                
                mov = Movement(
                    org_id=org.id,
                    product_id=product.id,
                    from_warehouse_id=from_wh.id,
                    to_warehouse_id=to_wh.id,
                    movement_type='TRANSFER',
                    reason='TRANSFER',
                    quantity=qty,
                    reference_id=f'TRANS-{str(i+1).zfill(3)}',
                    reference_type='TRANSFER',
                    note=f'Transferencia de {from_wh.name} a {to_wh.name}',
                    created_by=user.id if user else None,
                    created_at=now - timedelta(days=random.randint(1, 15))
                )
                db.session.add(mov)
                count += 1
        
        # ========== AJUSTES - Inventario (5 movimientos) ==========
        for i in range(5):
            product = products[(i * 5) % len(products)]
            warehouse = warehouses[i % len(warehouses)]
            user = users[i % len(users)] if users else None
            
            qty = random.randint(1, 20)
            
            mov = Movement(
                org_id=org.id,
                product_id=product.id,
                to_warehouse_id=warehouse.id,
                movement_type='ADJUST',
                reason='ADJUSTMENT',
                quantity=qty,
                reference_id=f'ADJ-{str(i+1).zfill(3)}',
                reference_type='ADJ',
                note=f'Ajuste por inventario físico - Diferencia detectada',
                created_by=user.id if user else None,
                created_at=now - timedelta(days=random.randint(1, 5))
            )
            db.session.add(mov)
            count += 1
        
        # ========== DEVOLUCIONES (5 movimientos) ==========
        for i in range(5):
            product = products[(i * 7) % len(products)]
            warehouse = warehouses[i % len(warehouses)]
            user = users[i % len(users)] if users else None
            
            qty = random.randint(5, 15)
            
            mov = Movement(
                org_id=org.id,
                product_id=product.id,
                to_warehouse_id=warehouse.id,
                movement_type='IN',
                reason='RETURN',
                quantity=qty,
                reference_id=f'DEV-{str(i+1).zfill(3)}',
                reference_type='RETURN',
                note=f'Devolución de material no utilizado',
                created_by=user.id if user else None,
                created_at=now - timedelta(days=random.randint(1, 10))
            )
            db.session.add(mov)
            count += 1
        
        db.session.commit()
        print(f"  ✓ {count} movimientos creados\n")

def main():
    """Ejecuta el proceso completo"""
    print("\n" + "="*60)
    print("🚀 REINICIO Y POBLACIÓN DE DATOS PARA SPRINT 3")
    print("="*60)
    
    try:
        # Solo ejecutar cleanup si hay datos (evita duplicados en misma sesión)
        with app.app_context():
            product_count = Product.query.count()
            if product_count > 0:
                print(f"\n⚠️  Encontrados {product_count} productos existentes")
                print("Ejecute primero: python -c \"import sys; sys.path.insert(0, '.'); from run import app; from app.db import db; from sqlalchemy import text; app.app_context().push(); db.session.execute(text('TRUNCATE TABLE movement, work_order, bom_component, bom, supplier_item, supplier, product_warehouse, product, warehouse RESTART IDENTITY CASCADE')); db.session.commit(); print('Limpiado')\"")
                return 1
        
        # populate_categories()  # Tabla no existe
        populate_warehouses()
        populate_products()
        populate_suppliers()
        populate_supplier_items()
        populate_stock()
        populate_boms()
        populate_work_orders()
        populate_movements()
        
        print("="*60)
        print("✅ PROCESO COMPLETADO EXITOSAMENTE")
        print("="*60)
        
        # Resumen
        with app.app_context():
            wh_count = Warehouse.query.count()
            prod_count = Product.query.count()
            sup_count = Supplier.query.count()
            sup_item_count = SupplierItem.query.count()
            bom_count = BOM.query.count()
            wo_count = WorkOrder.query.count()
            mov_count = Movement.query.count()
            
            from app.models.product_warehouse import ProductWarehouse
            stock_count = ProductWarehouse.query.count()
            
            print(f"\n📊 Resumen:")
            print(f"  • Almacenes: {wh_count}")
            print(f"  • Productos: {prod_count}")
            print(f"  • Proveedores: {sup_count}")
            print(f"  • Relaciones proveedor-producto: {sup_item_count}")
            print(f"  • Registros de stock: {stock_count}")
            print(f"  • BOMs (Listas de Materiales): {bom_count}")
            print(f"  • Work Orders (Órdenes de Producción): {wo_count}")
            print(f"  • Movements (Movimientos): {mov_count}")
            print()
            
    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()
        return 1
    
    return 0

if __name__ == "__main__":
    exit(main())
