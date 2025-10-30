"""
Agregar subrecursos faltantes de Sprint 3 (Producción)
"""
from app.db import db
from run import app
from app.models.resource import Resource
from app.models.subresource import Subresource

def add_sprint3_subresources():
    with app.app_context():
        print("=" * 60)
        print("AGREGANDO SUBRECURSOS FALTANTES DE SPRINT 3")
        print("=" * 60)
        
        # Buscar recurso Producción (id=17)
        prod_resource = Resource.query.get(17)
        if not prod_resource:
            print("ERROR: No se encontró recurso Producción (id=17)")
            return
        
        print(f"\nRecurso encontrado: {prod_resource.name} (id={prod_resource.id})")
        
        # Subrecursos actuales de Producción
        current = Subresource.query.filter_by(resource_id=17).all()
        print(f"\nSubrecursos actuales de Producción: {len(current)}")
        for s in current:
            print(f"  - {s.name} (id={s.id})")
        
        # Subrecursos que deberían existir según planificación
        desired_subresources = [
            {
                'name': 'Lista de Materiales',
                'description': 'ABM de BOMs',
                'icon': 'pi pi-list',
                'url': '/dashboard/production/boms'
            },
            {
                'name': 'Órdenes de Producción',
                'description': 'Gestión de órdenes de producción',
                'icon': 'pi pi-calendar',
                'url': '/dashboard/production/work-orders'
            },
            {
                'name': 'Ejecución',
                'description': 'Iniciar/Finalizar órdenes',
                'icon': 'pi pi-cog',
                'url': '/dashboard/production/execution'
            },
            {
                'name': 'Reportes Producción',
                'description': 'Reportes de producción',
                'icon': 'pi pi-chart-bar',
                'url': '/dashboard/production/reports'
            }
        ]
        
        print("\n" + "-" * 60)
        print("CREANDO/ACTUALIZANDO SUBRECURSOS")
        print("-" * 60)
        
        for sub_data in desired_subresources:
            # Buscar si ya existe por nombre o URL
            existing = Subresource.query.filter(
                Subresource.resource_id == 17,
                db.or_(
                    Subresource.name == sub_data['name'],
                    Subresource.url == sub_data['url']
                )
            ).first()
            
            if existing:
                print(f"\nActualizando: {sub_data['name']}")
                existing.name = sub_data['name']
                existing.description = sub_data['description']
                existing.icon = sub_data['icon']
                existing.url = sub_data['url']
                print(f"  OK actualizado (id={existing.id})")
            else:
                print(f"\nCreando: {sub_data['name']}")
                new_sub = Subresource(
                    resource_id=17,
                    name=sub_data['name'],
                    description=sub_data['description'],
                    icon=sub_data['icon'],
                    url=sub_data['url']
                )
                db.session.add(new_sub)
                db.session.flush()
                print(f"  OK creado (id={new_sub.id})")
        
        db.session.commit()
        
        # Verificación final
        print("\n" + "=" * 60)
        print("VERIFICACION FINAL")
        print("=" * 60)
        
        final = Subresource.query.filter_by(resource_id=17).order_by(Subresource.id).all()
        print(f"\nSubrecursos de Producción: {len(final)}")
        for s in final:
            print(f"  - {s.name} (id={s.id}) - {s.url}")
        
        total = Subresource.query.count()
        print(f"\nTotal subrecursos en sistema: {total}")
        print("\n" + "=" * 60)
        print("COMPLETADO")
        print("=" * 60)

if __name__ == "__main__":
    add_sprint3_subresources()
