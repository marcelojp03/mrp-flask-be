#!/usr/bin/env python
"""
Script para ejecutar migraciones de S3 (BOM y Work Orders)
"""
import sys
import os

# Agregar el directorio raíz al path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from run import app, db

def run_sql_file(filepath):
    """Ejecuta un archivo SQL"""
    print(f"\n{'='*60}")
    print(f"Ejecutando: {filepath}")
    print(f"{'='*60}")
    
    with open(filepath, 'r', encoding='utf-8') as f:
        sql = f.read()
    
    try:
        db.session.execute(db.text(sql))
        db.session.commit()
        print(f"✓ {filepath} ejecutado exitosamente")
        return True
    except Exception as e:
        print(f"✗ Error en {filepath}: {e}")
        db.session.rollback()
        return False

def main():
    """Ejecuta migraciones de S3"""
    with app.app_context():
        migrations = [
            'migrations/013_create_bom_tables.sql',
            'migrations/014_create_work_order_table.sql',
            'migrations/015_extend_movement_for_work_orders.sql'
        ]
        
        success_count = 0
        for migration in migrations:
            if os.path.exists(migration):
                if run_sql_file(migration):
                    success_count += 1
            else:
                print(f"⚠ Archivo no encontrado: {migration}")
        
        print(f"\n{'='*60}")
        print(f"Resumen: {success_count}/{len(migrations)} migraciones exitosas")
        print(f"{'='*60}\n")
        
        if success_count == len(migrations):
            print("✓ Todas las migraciones S3 completadas")
            return 0
        else:
            print("✗ Algunas migraciones fallaron")
            return 1

if __name__ == '__main__':
    sys.exit(main())
