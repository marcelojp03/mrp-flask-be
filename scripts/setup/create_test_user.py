#!/usr/bin/env python3
"""
Crear usuario de prueba para login
"""
import os
import sys
import psycopg2
from werkzeug.security import generate_password_hash

# Cargar .env manualmente
env_file = os.path.join(os.path.dirname(os.path.dirname(__file__)), '.env')
if os.path.exists(env_file):
    with open(env_file, 'r') as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith('#') and '=' in line:
                key, value = line.split('=', 1)
                os.environ[key.strip()] = value.strip()

db_user = os.getenv("DB_USER", "postgres")
db_pass = os.getenv("DB_PASS", "admin123*")
db_host = os.getenv("DB_HOST", "localhost")
db_port = os.getenv("DB_PORT", "5432")
db_name = os.getenv("DB_NAME", "mrp")
db_schema = os.getenv("DB_SCHEMA", "public")

print("\n" + "="*60)
print("🔧 CREAR USUARIO DE PRUEBA")
print("="*60 + "\n")

# Usuario de prueba
test_email = "test@test.com"
test_password = "123456"
test_name = "Usuario de Prueba"

try:
    conn = psycopg2.connect(
        host=db_host,
        port=db_port,
        database=db_name,
        user=db_user,
        password=db_pass
    )
    
    cursor = conn.cursor()
    
    # Verificar si el usuario ya existe
    cursor.execute(f"""
        SELECT id, email FROM "{db_schema}"."user" 
        WHERE email = %s
    """, (test_email,))
    
    existing = cursor.fetchone()
    
    if existing:
        print(f"ℹ️  El usuario {test_email} ya existe.")
        print(f"   Actualizando contraseña...\n")
        
        # Actualizar contraseña
        pwd_hash = generate_password_hash(test_password)
        cursor.execute(f"""
            UPDATE "{db_schema}"."user"
            SET password = %s
            WHERE email = %s
        """, (pwd_hash, test_email))
        
    else:
        print(f"➕ Creando nuevo usuario...\n")
        
        # Crear nuevo usuario
        pwd_hash = generate_password_hash(test_password)
        cursor.execute(f"""
            INSERT INTO "{db_schema}"."user" (name, email, password)
            VALUES (%s, %s, %s)
            RETURNING id
        """, (test_name, test_email, pwd_hash))
        
        user_id = cursor.fetchone()[0]
        print(f"   ✅ Usuario creado con ID: {user_id}\n")
    
    conn.commit()
    
    print("="*60)
    print("✅ USUARIO DE PRUEBA LISTO")
    print("="*60 + "\n")
    print("📧 Credenciales para login:")
    print(f"   Email:    {test_email}")
    print(f"   Password: {test_password}")
    print()
    print("🚀 Prueba el login desde tu frontend con estas credenciales")
    print("="*60 + "\n")
    
    cursor.close()
    conn.close()
    
except Exception as e:
    print(f"❌ Error: {e}\n")
    sys.exit(1)
