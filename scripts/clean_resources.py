import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app.db import db
from models.resource import Resource
from models.subresource import Subresource
from models.role_resource import RoleResource
from run import app

with app.app_context():
    print("=== Limpiando recursos duplicados ===\n")
    
    # 1. Eliminar todos los role_resources
    deleted_rr = RoleResource.query.delete()
    print(f"✓ {deleted_rr} role_resources eliminados")
    
    # 2. Eliminar todos los subrecursos
    deleted_subs = Subresource.query.delete()
    print(f"✓ {deleted_subs} subrecursos eliminados")
    
    # 3. Eliminar todos los recursos
    deleted_res = Resource.query.delete()
    print(f"✓ {deleted_res} recursos eliminados")
    
    db.session.commit()
    
    print("\n=== Limpieza completada ===")
    print("Ahora ejecuta: python seeds/init_data.py")
