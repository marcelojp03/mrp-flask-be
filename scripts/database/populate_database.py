#!/usr/bin/env python
"""
Script para poblar base de datos con todos los datos (S1, S2, S3)
Ejecuta en orden: clean → full_database_seeds → s3_bom_work_orders
"""
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from run import app, db

def run_sql_file(filepath, description=""):
    """Ejecuta un archivo SQL"""
    print(f"\n{'='*60}")
    print(f"{'Ejecutando: ' + description if description else filepath}")
    print(f"Archivo: {filepath}")
    print(f"{'='*60}")
    
    if not os.path.exists(filepath):
        print(f"⚠ Archivo no encontrado: {filepath}")
        return False
    
    with open(filepath, 'r', encoding='utf-8') as f:
        sql = f.read()
    
    try:
        # Ejecutar el SQL dividido por declaraciones si es necesario
        statements = [s.strip() for s in sql.split(';') if s.strip()]
        for stmt in statements:
            if stmt:
                db.session.execute(db.text(stmt))
        db.session.commit()
        print(f"✓ Completado exitosamente")
        return True
    except Exception as e:
        print(f"✗ Error: {e}")
        db.session.rollback()
        return False

def main():
    """Ejecuta población completa de la base de datos"""
    print("\n" + "="*60)
    print("POBLACIÓN COMPLETA DE BASE DE DATOS MRP")
    print("Sprints: S1 (Inventario) + S2 (SaaS/Logs) + S3 (BOM/OP)")
    print("="*60)
    
    with app.app_context():
        steps = [
            {
                'file': 'seeds/clean_database.sql',
                'desc': 'PASO 1: Limpiar base de datos',
                'critical': False  # No critical, puede que no existan datos
            },
            {
                'file': 'seeds/full_database_seeds.sql',
                'desc': 'PASO 2: Poblar datos base (S1+S2)',
                'critical': True
            },
            {
                'file': 'seeds/s3_bom_work_orders.sql',
                'desc': 'PASO 3: Poblar BOMs y Work Orders (S3)',
                'critical': True
            }
        ]
        
        success_count = 0
        total_critical = sum(1 for s in steps if s['critical'])
        
        for step in steps:
            result = run_sql_file(step['file'], step['desc'])
            if result:
                success_count += 1
            elif step['critical']:
                print(f"\n✗ FALLO CRÍTICO en: {step['desc']}")
                print("Abortando población de base de datos")
                return 1
        
        print(f"\n{'='*60}")
        print(f"RESUMEN FINAL")
        print(f"{'='*60}")
        print(f"Pasos completados: {success_count}/{len(steps)}")
        
        if success_count >= total_critical:
            print("\n✓ BASE DE DATOS POBLADA EXITOSAMENTE")
            print("\nDatos creados:")
            print("  - 2 Organizaciones (ACME, GLOBEX)")
            print("  - 4 Usuarios (admin, planner, super, op)")
            print("  - 4 Roles con permisos configurados")
            print("  - 10 Productos (5 RM, 2 FG, 2 Consumibles, 1 Servicio)")
            print("  - 3 Almacenes con stock inicial")
            print("  - 5 Proveedores con catálogo de precios")
            print("  - 2 BOMs activas (Mesa, Silla)")
            print("  - 3 Work Orders de ejemplo (2 Planificadas, 1 En Progreso)")
            print("\nCredenciales de acceso:")
            print("  - admin@acme.com / admin123")
            print("  - planner@acme.com / planner123")
            print("  - super@acme.com / super123")
            print("  - op@acme.com / op123")
            print("\nEndpoints S3 disponibles:")
            print("  - GET/POST /api/boms")
            print("  - PUT /api/boms/:id/activate")
            print("  - GET/POST /api/work-orders")
            print("  - PUT /api/work-orders/:id/start")
            print("  - PUT /api/work-orders/:id/finish")
            print("  - GET /api/dashboard/kpis (incluye métricas de producción)")
            print("\n" + "="*60)
            return 0
        else:
            print("\n✗ FALLO EN LA POBLACIÓN")
            print("Revise los errores anteriores")
            return 1

if __name__ == '__main__':
    sys.exit(main())
