"""
Script para eliminar el subrecurso 'Recursos/ACL' de la base de datos
"""
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from run import app
from app.db import db
from sqlalchemy import text

with app.app_context():
    # Primero eliminar los permisos (role_resource) asociados
    print("1️⃣  Eliminando permisos asociados a 'Recursos/ACL'...")
    result_perms = db.session.execute(
        text("""
            DELETE FROM role_resource 
            WHERE subresource_id IN (
                SELECT id FROM subresource WHERE name = :name
            )
            RETURNING role_id, subresource_id
        """),
        {"name": "Recursos/ACL"}
    )
    deleted_perms = result_perms.fetchall()
    
    if deleted_perms:
        print(f"   ✓ Eliminados {len(deleted_perms)} permisos (role_resource)")
    else:
        print("   ℹ️  No se encontraron permisos asociados")
    
    # Ahora eliminar el subrecurso
    print("\n2️⃣  Eliminando subrecurso 'Recursos/ACL'...")
    result = db.session.execute(
        text("DELETE FROM subresource WHERE name = :name RETURNING id"),
        {"name": "Recursos/ACL"}
    )
    deleted = result.fetchall()
    
    db.session.commit()
    
    if deleted:
        print(f"   ✓ Eliminado subrecurso 'Recursos/ACL' (ID: {deleted[0][0]})")
        print("\n✅ COMPLETADO: El subrecurso 'Recursos/ACL' ha sido eliminado exitosamente")
    else:
        print("   ℹ️  No se encontró el subrecurso 'Recursos/ACL' en la base de datos")
        print("   (Probablemente ya fue eliminado)")
