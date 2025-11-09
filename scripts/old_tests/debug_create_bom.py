"""
Script para ver qué datos se necesitan para crear una BOM
"""
import sys
sys.path.insert(0, '.')

from app.db import db
from app.models.product import Product
from app.models.unit import Unit
from run import app

with app.app_context():
    org_id = 1
    
    print("=" * 70)
    print("DATOS PARA CREAR BOM")
    print("=" * 70)
    
    # 1. Productos terminados (para la BOM)
    print("\n📦 PRODUCTOS TERMINADOS (para crear BOM):")
    print("-" * 70)
    
    finished_products = Product.query.filter(
        Product.org_id == org_id,
        Product.code.like('FG-%')
    ).all()
    
    if not finished_products:
        print("❌ No hay productos terminados")
    else:
        for p in finished_products:
            print(f"  ✅ ID: {p.id} - {p.name} ({p.code})")
    
    # 2. Componentes/Materias primas
    print("\n\n🔧 COMPONENTES/MATERIAS PRIMAS:")
    print("-" * 70)
    
    raw_materials = Product.query.filter(
        Product.org_id == org_id,
        Product.code.like('RM-%')
    ).all()
    
    if not raw_materials:
        print("❌ No hay materias primas")
    else:
        for p in raw_materials:
            print(f"  ✅ ID: {p.id} - {p.name} ({p.code})")
    
    # 3. Unidades disponibles
    print("\n\n📏 UNIDADES DISPONIBLES:")
    print("-" * 70)
    
    units = Unit.query.all()
    if not units:
        print("❌ No hay unidades")
    else:
        for u in units:
            print(f"  ✅ ID: {u.id} - {u.description} ({u.code})")
    
    # 4. Ejemplo completo
    print("\n\n💡 EJEMPLO COMPLETO - CREAR BOM:")
    print("-" * 70)
    
    if finished_products and raw_materials:
        fg = finished_products[0]
        rm1 = raw_materials[0] if len(raw_materials) > 0 else None
        rm2 = raw_materials[1] if len(raw_materials) > 1 else None
        
        print(f"""
POST http://localhost:4646/api/boms
Headers:
  Authorization: Bearer {{tu_token}}
  Content-Type: application/json

Body:
{{
  "product_id": {fg.id},           // {fg.name}
  "version": "1.0",
  "description": "BOM de prueba",
  "is_active": true,
  "components": [
    {{
      "component_id": {rm1.id if rm1 else 'X'},      // {rm1.name if rm1 else 'Componente 1'}
      "quantity": 2.0,
      "unit_id": 1,
      "scrap_percentage": 5.0,
      "sequence": 1,
      "notes": "Material principal"
    }}{"," if rm2 else ""}
    {"".join([f'''
    {{
      "component_id": {rm2.id},      // {rm2.name}
      "quantity": 1.5,
      "unit_id": 2,
      "scrap_percentage": 3.0,
      "sequence": 2,
      "notes": "Material secundario"
    }}''' if rm2 else ""])}
  ]
}}
        """)
    
    print("\n" + "=" * 70)
    print("CAMPOS REQUERIDOS:")
    print("  - product_id (número)")
    print("  - version (string)")
    print("  - components (array con al menos 1 elemento)")
    print("\nCAMPOS DE CADA COMPONENTE:")
    print("  - component_id (número, requerido)")
    print("  - quantity (número, requerido)")
    print("  - unit_id (número, opcional)")
    print("  - scrap_percentage (número, opcional, default: 0)")
    print("  - sequence (número, opcional)")
    print("  - notes (string, opcional)")
    print("=" * 70)
