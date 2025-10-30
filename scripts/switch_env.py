#!/usr/bin/env python3
"""
Script para cambiar entre entornos (development, staging, production)
Uso: python switch_env.py [development|staging|production]
"""
import sys
import shutil
from pathlib import Path

def switch_environment(env: str):
    """Cambia el archivo .env al entorno especificado"""
    
    valid_envs = ['development', 'staging', 'production']
    
    if env not in valid_envs:
        print(f"❌ Entorno inválido: {env}")
        print(f"   Entornos válidos: {', '.join(valid_envs)}")
        sys.exit(1)
    
    base_dir = Path(__file__).parent
    source_file = base_dir / f".env.{env}"
    target_file = base_dir / ".env"
    
    if not source_file.exists():
        print(f"❌ No existe el archivo: {source_file}")
        sys.exit(1)
    
    # Hacer backup del .env actual
    if target_file.exists():
        backup_file = base_dir / ".env.backup"
        shutil.copy2(target_file, backup_file)
        print(f"📦 Backup creado: .env.backup")
    
    # Copiar el nuevo entorno
    shutil.copy2(source_file, target_file)
    
    print(f"✅ Entorno cambiado a: {env.upper()}")
    print(f"   Archivo activo: .env")
    print(f"   Fuente: .env.{env}")
    
    # Mostrar configuración actual
    print("\n📋 Configuración activa:")
    with open(target_file, 'r') as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith('#'):
                # Ocultar valores sensibles
                if any(x in line for x in ['PASSWORD', 'SECRET', 'KEY', 'PASS']):
                    key = line.split('=')[0]
                    print(f"   {key}=***OCULTO***")
                else:
                    print(f"   {line}")

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("Uso: python switch_env.py [development|staging|production]")
        print("\nEjemplos:")
        print("  python switch_env.py development   # Para desarrollo local")
        print("  python switch_env.py staging       # Para testing/staging")
        print("  python switch_env.py production    # Para producción")
        sys.exit(1)
    
    environment = sys.argv[1].lower()
    switch_environment(environment)
