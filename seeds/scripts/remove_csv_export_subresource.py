#!/usr/bin/env python3
"""
Script para eliminar el subrecurso obsoleto "Exportar CSV"
Ya que el nuevo endpoint /api/reports/nl lo reemplaza completamente
"""
import sys
import os
sys.path.insert(0, os.path.dirname(__file__))

from dotenv import load_dotenv
load_dotenv()

from app.db import db
from app.models.subresource import Subresource
from app.models.role_resource import RoleResource
from flask import Flask
from app.config import Config

# Crear app
app = Flask(__name__)
app.config.from_object(Config)
db.init_app(app)

with app.app_context():
    print("=" * 70)
    print("🗑️  ELIMINANDO SUBRECURSO OBSOLETO: 'Exportar CSV'")
    print("=" * 70)
    
    # Buscar el subrecurso
    csv_export = Subresource.query.filter_by(name='Exportar CSV').first()
    
    if not csv_export:
        print("\n⚠️  El subrecurso 'Exportar CSV' no existe en la base de datos")
        print("✅ No hay nada que eliminar")
    else:
        print(f"\n📋 Encontrado:")
        print(f"   ID: {csv_export.id}")
        print(f"   Nombre: {csv_export.name}")
        print(f"   URL: {csv_export.url}")
        print(f"   Recurso: {csv_export.resource.name if csv_export.resource else 'N/A'}")
        
        # Verificar si tiene permisos asignados
        role_resources = RoleResource.query.filter_by(subresource_id=csv_export.id).all()
        
        if role_resources:
            print(f"\n⚠️  Este subrecurso está asignado a {len(role_resources)} rol(es)")
            print("   Eliminando asignaciones de roles...")
            
            for rr in role_resources:
                db.session.delete(rr)
            
            print(f"✅ {len(role_resources)} asignación(es) eliminada(s)")
        else:
            print("\n✓ No tiene asignaciones de roles")
        
        # Eliminar el subrecurso
        print("\n🗑️  Eliminando subrecurso...")
        db.session.delete(csv_export)
        db.session.commit()
        
        print("✅ Subrecurso 'Exportar CSV' eliminado exitosamente")
        print("\n💡 Motivo: El nuevo endpoint /api/reports/nl lo reemplaza con:")
        print("   - Consultas en lenguaje natural")
        print("   - Exportación a CSV, Excel y PDF")
        print("   - Interpretación de resultados con IA")
        print("   - Reportes dinámicos sin limitaciones")
    
    print("\n" + "=" * 70)
    print("✅ PROCESO COMPLETADO")
    print("=" * 70)
