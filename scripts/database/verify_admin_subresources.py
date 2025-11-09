"""
Verificar subrecursos de Administración después de eliminar Recursos/ACL
"""
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from run import app
from app.db import db
from sqlalchemy import text

with app.app_context():
    print("\n" + "="*60)
    print("📋 SUBRECURSOS DE ADMINISTRACIÓN")
    print("="*60)
    
    result = db.session.execute(text("""
        SELECT s.id, s.name, s.url, s.icon, r.name as resource
        FROM subresource s 
        JOIN resource r ON r.id = s.resource_id 
        WHERE r.name = 'Administración' 
        ORDER BY s.name
    """)).fetchall()
    
    if result:
        for row in result:
            print(f"\n  ID: {row[0]}")
            print(f"  Nombre: {row[1]}")
            print(f"  URL: {row[2]}")
            print(f"  Icono: {row[3]}")
    else:
        print("\n  ℹ️  No hay subrecursos en Administración")
    
    print("\n" + "="*60)
    print(f"TOTAL: {len(result)} subrecursos")
    print("="*60)
    print("\n✅ ESPERADO: 2 subrecursos (Usuarios, Roles)")
    print("❌ NO DEBE APARECER: Recursos/ACL\n")
