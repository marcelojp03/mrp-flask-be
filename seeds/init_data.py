# seeds/init_data.py
"""
Script de bootstrap para inicializar datos del sistema (planes, roles, resources)
Ejecutar: python seeds/init_data.py
"""
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from run import app
from app.db import db
from models.plan import Plan
from models.role import Role
from models.resource import Resource
from models.subresource import Subresource
from models.role_resource import RoleResource
from models.unit import Unit

def seed_plans():
    """Crear planes FREE/STARTER/PRO si no existen"""
    plans_data = [
        {
            'code': 'free',
            'name': 'Free',
            'max_users': 3,
            'max_products': 50,
            'max_warehouses': 1,
            'max_movements_per_day': 50,
            'max_ai_reports_per_day': 10,
            'allow_bom': False,
            'allow_work_orders': False,
            'allow_mrp': False,
            'allow_forecast': False
        },
        {
            'code': 'starter',
            'name': 'Starter',
            'max_users': 10,
            'max_products': 500,
            'max_warehouses': 3,
            'max_movements_per_day': 500,
            'max_ai_reports_per_day': 100,
            'allow_bom': False,
            'allow_work_orders': False,
            'allow_mrp': False,
            'allow_forecast': False
        },
        {
            'code': 'pro',
            'name': 'Pro',
            'max_users': 99999,
            'max_products': 99999,
            'max_warehouses': 99999,
            'max_movements_per_day': 99999,
            'max_ai_reports_per_day': 500,
            'allow_bom': True,
            'allow_work_orders': True,
            'allow_mrp': True,
            'allow_forecast': True
        }
    ]
    
    for pd in plans_data:
        existing = Plan.query.filter_by(code=pd['code']).first()
        if not existing:
            plan = Plan(**pd, is_active=True)
            db.session.add(plan)
            print(f"✓ Plan '{pd['name']}' creado")
        else:
            print(f"- Plan '{pd['name']}' ya existe")
    
    db.session.commit()


def seed_roles():
    """Crear roles básicos si no existen"""
    roles_data = ['Admin', 'Gerente', 'Almacenero', 'Consultor']
    
    for rname in roles_data:
        existing = Role.query.filter(db.func.lower(Role.name) == rname.lower()).first()
        if not existing:
            role = Role(name=rname)
            db.session.add(role)
            print(f"✓ Rol '{rname}' creado")
        else:
            print(f"- Rol '{rname}' ya existe")
    
    db.session.commit()


def seed_resources():
    """Crear recursos y subrecursos básicos"""
    # Estructura: {Recurso: [(subrecurso, url, icon, description)]}
    resources_data = {
        'Inicio': [
            ('Dashboard', '/dashboard', 'pi pi-home', 'Indicadores y KPIs')
        ],
        'Inventario': [
            ('Productos', '/dashboard/products', 'pi pi-box', 'ABM de productos'),
            ('Almacenes', '/dashboard/warehouses', 'pi pi-building', 'ABM de almacenes'),
            ('Movimientos', '/dashboard/movements', 'pi pi-exchange', 'Entradas/Salidas/Transferencias/Ajustes'),
            ('Stock Bajo', '/dashboard/stocks/low', 'pi pi-exclamation-triangle', 'Alertas de stock bajo'),
            ('Sugerencias', '/dashboard/stocks/reorder-suggestions', 'pi pi-refresh', 'Sugerencias de reposición')
        ],
        'Producción': [
            ('Órdenes (demo)', '/dashboard/work-orders', 'pi pi-cog', 'Órdenes de producción (demo)')
        ],
        'Proveedores': [
            ('Proveedores', '/dashboard/suppliers', 'pi pi-truck', 'ABM de proveedores'),
            ('Catálogo Proveedor', '/dashboard/suppliers/supplier-items', 'pi pi-link', 'Relación proveedor–producto')
        ],
        'Planificación': [
            ('Demanda', '/dashboard/demand', 'pi pi-database', 'Carga de demanda'),
            ('MPS', '/dashboard/mps', 'pi pi-calendar', 'Plan Maestro de Producción'),
            ('MRP', '/dashboard/mrp', 'pi pi-sitemap', 'Requerimientos de Materiales')
        ],
        'Administración': [
            ('Usuarios', '/dashboard/users', 'pi pi-user', 'ABM usuarios'),
            ('Roles', '/dashboard/roles', 'pi pi-shield', 'ABM roles'),
            ('Recursos/ACL', '/dashboard/acl', 'pi pi-list', 'ABM recursos y subrecursos')
        ],
        'Reportes': [
            ('Exportar CSV', '/dashboard/reports/csv', 'pi pi-file-export', 'Exportar datos a CSV'),
            ('Reportes IA', '/dashboard/reports/ai', 'pi pi-sparkles', 'Generador de reportes con IA')
        ],
        'Sistema': [
            ('Logs', '/dashboard/system/logs', 'pi pi-file', 'Auditoría del sistema'),
            ('Backup', '/dashboard/system/backup', 'pi pi-database', 'Respaldo de datos')
        ]
    }
    
    for res_name, subs_list in resources_data.items():
        res = Resource.query.filter(db.func.lower(Resource.name) == res_name.lower()).first()
        if not res:
            # Descripción según el recurso
            descriptions = {
                'Inicio': 'Pantalla principal / Dashboard',
                'Inventario': 'Gestión de inventario y stock',
                'Producción': 'BOM, órdenes y ejecución',
                'Proveedores': 'Maestro de proveedores',
                'Planificación': 'Demanda, MPS y MRP',
                'Administración': 'Usuarios, Roles y Seguridad',
                'Reportes': 'Generación de reportes',
                'Sistema': 'Configuración y mantenimiento'
            }
            res = Resource(name=res_name, description=descriptions.get(res_name, f'Módulo {res_name}'))
            db.session.add(res)
            db.session.flush()
            print(f"✓ Resource '{res_name}' creado")
        else:
            print(f"- Resource '{res_name}' ya existe")
        
        # Crear subrecursos con datos completos
        for sub_data in subs_list:
            sub_name, url, icon, description = sub_data
            sub = Subresource.query.filter(
                db.func.lower(Subresource.name) == sub_name.lower(),
                Subresource.resource_id == res.id
            ).first()
            if not sub:
                sub = Subresource(
                    name=sub_name, 
                    resource_id=res.id,
                    description=description,
                    url=url,
                    icon=icon
                )
                db.session.add(sub)
                print(f"  ✓ Subresource '{sub_name}' creado")
    
    db.session.commit()


def seed_role_resources():
    """Asignar todos los subrecursos al rol Admin"""
    admin = Role.query.filter(db.func.lower(Role.name) == 'admin').first()
    if not admin:
        print("⚠️  No se encontró rol Admin, ejecuta seed_roles() primero")
        return
    
    # Obtener todos los subrecursos
    subresources = Subresource.query.all()
    for sub in subresources:
        existing = RoleResource.query.filter_by(
            role_id=admin.id, 
            resource_id=sub.resource_id,
            subresource_id=sub.id
        ).first()
        if not existing:
            rr = RoleResource(
                role_id=admin.id, 
                resource_id=sub.resource_id,
                subresource_id=sub.id
            )
            db.session.add(rr)
            resource = Resource.query.get(sub.resource_id)
            print(f"✓ Admin → {resource.name} / {sub.name}")
    
    db.session.commit()


def seed_units():
    """Crear unidades básicas si no existen"""
    units_data = [
        ('EA', 'Unidad'),
        ('KG', 'Kilogramo'),
        ('L', 'Litro'),
        ('M', 'Metro'),
        ('M2', 'Metro cuadrado'),
        ('M3', 'Metro cúbico'),
        ('BOX', 'Caja'),
        ('PAL', 'Pallet'),
    ]
    
    for code, desc in units_data:
        existing = Unit.query.filter_by(code=code).first()
        if not existing:
            unit = Unit(code=code, description=desc)
            db.session.add(unit)
            print(f"✓ Unidad '{code}' creada")
        else:
            print(f"- Unidad '{code}' ya existe")
    
    db.session.commit()


def run_all_seeds():
    """Ejecuta todos los seeds en orden"""
    with app.app_context():
        print("=== Iniciando seeds ===\n")
        
        print("1) Planes...")
        seed_plans()
        
        print("\n2) Unidades...")
        seed_units()
        
        print("\n3) Roles...")
        seed_roles()
        
        print("\n4) Resources...")
        seed_resources()
        
        print("\n5) Role Resources (Admin)...")
        seed_role_resources()
        
        print("\n=== Seeds completados ===")


if __name__ == '__main__':
    run_all_seeds()
