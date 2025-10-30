"""
Eliminar subrecurso demo duplicado
"""
from app.db import db
from run import app
from models.subresource import Subresource
from models.role_resource import RoleResource

with app.app_context():
    demo = Subresource.query.filter_by(id=46).first()
    if demo:
        print(f"Eliminando referencias: {demo.name} (id={demo.id})")
        
        # Primero eliminar referencias en role_resource
        refs = RoleResource.query.filter_by(subresource_id=46).all()
        print(f"  Referencias en role_resource: {len(refs)}")
        for ref in refs:
            db.session.delete(ref)
        
        # Ahora eliminar el subrecurso
        db.session.delete(demo)
        db.session.commit()
        print("OK eliminado")
    
    total = Subresource.query.count()
    print(f"\nTotal subrecursos: {total}")
