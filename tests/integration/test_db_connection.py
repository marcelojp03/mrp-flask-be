#!/usr/bin/env python3
"""
Script de prueba de conexión a la base de datos
"""
import os
import sys

# Agregar el directorio raíz al path
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

try:
    import psycopg2
except ImportError:
    print("❌ Error: psycopg2 no está instalado")
    print("   Instala con: pip install psycopg2-binary")
    sys.exit(1)

# Cargar .env manualmente
env_file = os.path.join(os.path.dirname(os.path.dirname(__file__)), '.env')
if os.path.exists(env_file):
    with open(env_file, 'r') as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith('#') and '=' in line:
                key, value = line.split('=', 1)
                os.environ[key.strip()] = value.strip()

def test_connection():
    """Probar conexión a PostgreSQL"""
    
    # Leer configuración
    db_user = os.getenv("DB_USER", "postgres")
    db_pass = os.getenv("DB_PASS", "admin123*")
    db_host = os.getenv("DB_HOST", "localhost")
    db_port = os.getenv("DB_PORT", "5432")
    db_name = os.getenv("DB_NAME", "mrp")
    db_schema = os.getenv("DB_SCHEMA", "public")
    
    print("\n" + "="*60)
    print("🔍 VERIFICACIÓN DE CONEXIÓN A BASE DE DATOS")
    print("="*60 + "\n")
    
    print("📋 Configuración actual:")
    print(f"   Host:     {db_host}")
    print(f"   Puerto:   {db_port}")
    print(f"   Database: {db_name}")
    print(f"   Schema:   {db_schema}")
    print(f"   Usuario:  {db_user}")
    print(f"   Password: {'*' * len(db_pass)} (oculta)")
    print()
    
    # Test 1: Conexión básica
    print("🧪 Test 1: Conexión TCP a PostgreSQL...")
    try:
        import socket
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(5)
        result = sock.connect_ex((db_host, int(db_port)))
        sock.close()
        
        if result == 0:
            print("   ✅ Puerto PostgreSQL está abierto y accesible\n")
        else:
            print(f"   ❌ No se puede conectar al puerto {db_port}")
            print(f"   Error code: {result}")
            print(f"   Verifica que PostgreSQL esté corriendo: net start postgresql-x64-XX\n")
            return False
    except Exception as e:
        print(f"   ❌ Error en conexión TCP: {e}\n")
        return False
    
    # Test 2: Conexión con psycopg2
    print("🧪 Test 2: Autenticación con PostgreSQL...")
    try:
        conn = psycopg2.connect(
            host=db_host,
            port=db_port,
            database=db_name,
            user=db_user,
            password=db_pass,
            connect_timeout=10
        )
        print("   ✅ Autenticación exitosa\n")
        
        # Test 3: Verificar schema
        print("🧪 Test 3: Verificar schema...")
        cursor = conn.cursor()
        cursor.execute(f"SET search_path TO {db_schema}")
        cursor.execute("SELECT current_schema()")
        current = cursor.fetchone()[0]
        print(f"   ✅ Schema activo: {current}\n")
        
        # Test 4: Verificar versión de PostgreSQL
        print("🧪 Test 4: Información del servidor...")
        cursor.execute("SELECT version()")
        version = cursor.fetchone()[0]
        print(f"   ✅ {version.split(',')[0]}\n")
        
        # Test 5: Verificar tablas
        print("🧪 Test 5: Verificar tablas en el schema...")
        cursor.execute("""
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = %s 
            ORDER BY table_name
        """, (db_schema,))
        tables = cursor.fetchall()
        
        if tables:
            print(f"   ✅ Se encontraron {len(tables)} tablas:")
            for table in tables[:10]:  # Mostrar primeras 10
                print(f"      • {table[0]}")
            if len(tables) > 10:
                print(f"      ... y {len(tables) - 10} más")
        else:
            print(f"   ⚠️  No se encontraron tablas en el schema '{db_schema}'")
            print(f"      Ejecuta: python scripts/create_tables.py")
        
        print()
        
        # Test 6: Verificar tabla de usuarios
        print("🧪 Test 6: Verificar tabla 'user'...")
        cursor.execute("""
            SELECT EXISTS (
                SELECT FROM information_schema.tables 
                WHERE table_schema = %s AND table_name = 'user'
            )
        """, (db_schema,))
        exists = cursor.fetchone()[0]
        
        if exists:
            cursor.execute(f"SELECT COUNT(*) FROM \"{db_schema}\".\"user\"")
            count = cursor.fetchone()[0]
            print(f"   ✅ Tabla 'user' existe con {count} usuarios\n")
            
            if count > 0:
                cursor.execute(f"SELECT id, name, email FROM \"{db_schema}\".\"user\" LIMIT 5")
                users = cursor.fetchall()
                print("   👥 Usuarios en la base de datos:")
                for user in users:
                    print(f"      • ID: {user[0]}, Nombre: {user[1]}, Email: {user[2]}")
                print()
        else:
            print(f"   ⚠️  Tabla 'user' no existe")
            print(f"      Ejecuta: python scripts/create_tables.py")
            print()
        
        cursor.close()
        conn.close()
        
        print("="*60)
        print("✅ TODAS LAS PRUEBAS PASARON EXITOSAMENTE")
        print("="*60 + "\n")
        
        return True
        
    except psycopg2.OperationalError as e:
        print(f"   ❌ Error de conexión: {e}")
        print("\n💡 Posibles soluciones:")
        print("   1. Verifica que PostgreSQL esté corriendo:")
        print("      • Windows: net start postgresql-x64-XX")
        print("      • Ver servicios: services.msc")
        print("   2. Verifica usuario y contraseña en .env")
        print("   3. Verifica que la base de datos 'mrp' existe:")
        print("      psql -U postgres -c \"CREATE DATABASE mrp;\"")
        print()
        return False
        
    except Exception as e:
        print(f"   ❌ Error inesperado: {e}")
        print()
        return False

if __name__ == "__main__":
    success = test_connection()
    sys.exit(0 if success else 1)
