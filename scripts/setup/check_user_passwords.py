#!/usr/bin/env python3
"""
Verificar contraseñas de usuarios en la base de datos
"""
import os
import sys
import psycopg2

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
print("🔐 INFORMACIÓN DE USUARIOS PARA LOGIN")
print("="*60 + "\n")

try:
    conn = psycopg2.connect(
        host=db_host,
        port=db_port,
        database=db_name,
        user=db_user,
        password=db_pass
    )
    
    cursor = conn.cursor()
    cursor.execute(f"""
        SELECT id, name, email, password 
        FROM "{db_schema}"."user"
        ORDER BY id
        LIMIT 5
    """)
    
    users = cursor.fetchall()
    
    print("👥 Usuarios encontrados:\n")
    for user in users:
        user_id, name, email, pwd_hash = user
        print(f"   Usuario #{user_id}:")
        print(f"   • Nombre: {name}")
        print(f"   • Email:  {email}")
        
        # Verificar si la contraseña es hash o texto plano
        if pwd_hash.startswith('scrypt:') or pwd_hash.startswith('pbkdf2:'):
            print(f"   • Password: [HASH - {pwd_hash[:30]}...]")
            print(f"   ⚠️  La contraseña está hasheada. No se puede ver en texto plano.")
        else:
            print(f"   • Password: {pwd_hash}")
            print(f"   ℹ️  La contraseña está en texto plano (no recomendado)")
        
        print()
    
    cursor.close()
    conn.close()
    
    print("="*60)
    print("💡 RECOMENDACIÓN:")
    print("   Si las contraseñas están hasheadas y no las recuerdas,")
    print("   puedes crear un nuevo usuario o resetear la contraseña.")
    print("="*60 + "\n")
    
except Exception as e:
    print(f"❌ Error: {e}\n")
    sys.exit(1)
