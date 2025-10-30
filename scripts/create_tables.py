# scripts/create_tables.py
"""
Script para crear todas las tablas del sistema automáticamente
Uso: python scripts/create_tables.py
"""
from run import app
from app.db import db
from sqlalchemy import inspect

def create_all_tables():
    """Crea todas las tablas definidas en los modelos SQLAlchemy"""
    with app.app_context():
        print("🔧 Creando tablas en la base de datos...")
        
        # Crear todas las tablas
        db.create_all()
        
        print("✅ Tablas creadas exitosamente\n")
        
        # Verificar tablas creadas
        inspector = inspect(db.engine)
        tables = inspector.get_table_names()
        
        print(f"📊 Total de tablas: {len(tables)}\n")
        print("📋 Listado de tablas:")
        print("="*50)
        
        # Categorizar tablas
        core_tables = ['organization', 'user', 'role', 'user_role', 'resource', 'subresource', 'role_resource']
        saas_tables = ['plan', 'org_subscription', 'user_organization', 'system_log', 'report_audit']
        inventory_tables = ['product', 'warehouse', 'product_warehouse', 'movement', 'unit']
        supply_tables = ['supplier', 'supplier_item']
        other_tables = ['category', 'drawer', 'purchase', 'purchase_detail']
        
        def print_category(name, table_list):
            print(f"\n{name}:")
            for table in sorted(table_list):
                if table in tables:
                    print(f"  ✓ {table}")
                else:
                    print(f"  ✗ {table} (no encontrada)")
        
        print_category("🏢 Core (Auth & ACL)", core_tables)
        print_category("💳 SaaS (Sprint 2)", saas_tables)
        print_category("📦 Inventory", inventory_tables)
        print_category("🚚 Supply Chain", supply_tables)
        print_category("🗂️  Other", other_tables)
        
        # Tablas no categorizadas
        all_categorized = set(core_tables + saas_tables + inventory_tables + supply_tables + other_tables)
        uncategorized = [t for t in tables if t not in all_categorized]
        if uncategorized:
            print("\n📌 Otras tablas:")
            for table in sorted(uncategorized):
                print(f"  • {table}")
        
        print("\n" + "="*50)
        print("✅ Base de datos lista para usar")

if __name__ == '__main__':
    create_all_tables()
