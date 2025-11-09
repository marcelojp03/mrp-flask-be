"""
Script para depurar creación de Work Order
Muestra qué datos están llegando y qué validaciones fallan
"""
import sys
sys.path.insert(0, '.')

from app.db import db
from app.models.product import Product
from app.models.bom import BOM
from app.models.warehouse import Warehouse
from run import app

with app.app_context():
    org_id = 1
    
    print("=" * 70)
    print("DIAGNÓSTICO PARA CREAR WORK ORDER")
    print("=" * 70)
    
    # 1. Listar productos con BOM activa
    print("\n📦 PRODUCTOS CON BOM ACTIVA:")
    print("-" * 70)
    
    boms = BOM.query.filter_by(org_id=org_id, is_active=True).all()
    
    if not boms:
        print("❌ NO HAY BOMS ACTIVAS en la organización")
    else:
        for bom in boms:
            print(f"\n✅ BOM ID: {bom.id}")
            print(f"   Producto: {bom.product.name} (ID: {bom.product_id})")
            print(f"   Código: {bom.product.code}")
            print(f"   Versión: {bom.version}")
            print(f"   Componentes: {bom.components.count()}")
            
            # Datos para crear Work Order
            print(f"\n   📝 JSON para crear Work Order:")
            print(f"   {{")
            print(f'     "product_id": {bom.product_id},')
            print(f'     "quantity": 5,')
            print(f'     "warehouse_id": 1,  // Opcional')
            print(f'     "reference": "OP-TEST-001",  // Opcional')
            print(f'     "notes": "Orden de prueba"  // Opcional')
            print(f"   }}")
    
    # 2. Listar almacenes disponibles
    print("\n\n🏭 ALMACENES DISPONIBLES:")
    print("-" * 70)
    
    warehouses = Warehouse.query.filter_by(org_id=org_id).all()
    
    if not warehouses:
        print("❌ NO HAY ALMACENES")
    else:
        for wh in warehouses:
            print(f"  ✅ ID: {wh.id} - {wh.name}")
    
    # 3. Ejemplo completo
    print("\n\n💡 EJEMPLO COMPLETO - PETICIÓN POST:")
    print("-" * 70)
    print("""
POST http://localhost:4646/api/work-orders
Headers:
  Authorization: Bearer {tu_token}
  Content-Type: application/json

Body:
{
  "product_id": 8,           // ID del producto (debe tener BOM activa)
  "quantity": 10,            // Cantidad a producir (REQUERIDO)
  "warehouse_id": 1,         // ID del almacén (opcional pero recomendado)
  "reference": "OP-2025-003", // Referencia única (opcional)
  "notes": "Orden de prueba", // Notas (opcional)
  "assigned_to": 1,          // ID usuario asignado (opcional)
  "planned_start": "2025-11-01T08:00:00",  // Fecha inicio (opcional)
  "planned_end": "2025-11-03T18:00:00"     // Fecha fin (opcional)
}
    """)
    
    # 4. Errores comunes
    print("\n❌ ERRORES COMUNES Y SOLUCIONES:")
    print("-" * 70)
    print("""
1. "Campo requerido: product_id" o "quantity"
   → Asegúrate de enviar { "product_id": 8, "quantity": 10 }

2. "No existe una BOM activa para este producto"
   → El product_id debe tener una BOM con is_active=true
   → Verifica arriba qué productos tienen BOM activa

3. "Producto no encontrado"
   → El product_id no existe o no pertenece a tu organización

4. "Almacén no encontrado"
   → El warehouse_id no existe o no pertenece a tu organización
   → Puedes omitir warehouse_id si es opcional en tu caso

5. Error 400 genérico
   → Verifica que el JSON esté bien formado
   → Verifica que quantity sea un número > 0
    """)
    
    print("\n" + "=" * 70)
    print("CAMPOS REQUERIDOS: product_id, quantity")
    print("CAMPOS OPCIONALES: warehouse_id, reference, notes, assigned_to,")
    print("                   planned_start, planned_end")
    print("=" * 70)
