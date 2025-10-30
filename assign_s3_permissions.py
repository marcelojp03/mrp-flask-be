"""
Asignar permisos de Sprint 3 a roles
"""
from app.db import db
from run import app
from models.role import Role
from models.subresource import Subresource
from models.role_resource import RoleResource

def assign_s3_permissions():
    with app.app_context():
        print("=" * 60)
        print("ASIGNANDO PERMISOS SPRINT 3")
        print("=" * 60)
        
        # Obtener roles
        admin = Role.query.filter_by(name='Admin').first()
        planner = Role.query.filter_by(name='Planner').first()
        supervisor = Role.query.filter_by(name='Supervisor').first()
        operator = Role.query.filter_by(name='Operator').first()
        
        if not all([admin, planner, supervisor, operator]):
            print("ERROR: No se encontraron todos los roles")
            return
        
        # Subrecursos de Producción (id=17)
        boms_sub = Subresource.query.filter_by(resource_id=17, name='Lista de Materiales').first()
        wo_sub = Subresource.query.filter_by(resource_id=17, name='Órdenes de Producción').first()
        exec_sub = Subresource.query.filter_by(resource_id=17, name='Ejecución').first()
        reports_sub = Subresource.query.filter_by(resource_id=17, name='Reportes Producción').first()
        
        if not all([boms_sub, wo_sub, exec_sub, reports_sub]):
            print("ERROR: No se encontraron todos los subrecursos")
            return
        
        print(f"\nSubrecursos encontrados:")
        print(f"  - Lista de Materiales (id={boms_sub.id})")
        print(f"  - Órdenes de Producción (id={wo_sub.id})")
        print(f"  - Ejecución (id={exec_sub.id})")
        print(f"  - Reportes Producción (id={reports_sub.id})")
        
        # Permisos según planificación:
        # Admin: Todos
        # Planner: BOMs, Órdenes, Reportes
        # Supervisor: Órdenes, Reportes
        # Operator: Ejecución
        
        permissions = [
            # Admin - todos los subrecursos de Producción
            (admin.id, 17, boms_sub.id, 'Admin - BOMs'),
            (admin.id, 17, wo_sub.id, 'Admin - Work Orders'),
            (admin.id, 17, exec_sub.id, 'Admin - Ejecución'),
            (admin.id, 17, reports_sub.id, 'Admin - Reportes'),
            
            # Planner - BOMs, Órdenes, Reportes
            (planner.id, 17, boms_sub.id, 'Planner - BOMs'),
            (planner.id, 17, wo_sub.id, 'Planner - Work Orders'),
            (planner.id, 17, reports_sub.id, 'Planner - Reportes'),
            
            # Supervisor - Órdenes, Reportes
            (supervisor.id, 17, wo_sub.id, 'Supervisor - Work Orders'),
            (supervisor.id, 17, reports_sub.id, 'Supervisor - Reportes'),
            
            # Operator - Ejecución
            (operator.id, 17, exec_sub.id, 'Operator - Ejecución'),
        ]
        
        print("\n" + "-" * 60)
        print("ASIGNANDO PERMISOS")
        print("-" * 60)
        
        for role_id, resource_id, subresource_id, description in permissions:
            # Verificar si ya existe
            existing = RoleResource.query.filter_by(
                role_id=role_id,
                resource_id=resource_id,
                subresource_id=subresource_id
            ).first()
            
            if not existing:
                perm = RoleResource(
                    role_id=role_id,
                    resource_id=resource_id,
                    subresource_id=subresource_id
                )
                db.session.add(perm)
                print(f"  OK {description}")
            else:
                print(f"  -- {description} (ya existe)")
        
        db.session.commit()
        
        # Verificación
        print("\n" + "=" * 60)
        print("VERIFICACION")
        print("=" * 60)
        
        for role in [admin, planner, supervisor, operator]:
            count = RoleResource.query.filter_by(role_id=role.id).count()
            prod_count = RoleResource.query.filter_by(role_id=role.id, resource_id=17).count()
            print(f"\n{role.name}:")
            print(f"  Total permisos: {count}")
            print(f"  Permisos Producción: {prod_count}")
            
            # Listar permisos de producción
            prod_perms = RoleResource.query.filter_by(role_id=role.id, resource_id=17).all()
            for perm in prod_perms:
                sub = Subresource.query.get(perm.subresource_id)
                print(f"    - {sub.name}")
        
        print("\n" + "=" * 60)
        print("COMPLETADO")
        print("=" * 60)

if __name__ == "__main__":
    assign_s3_permissions()
