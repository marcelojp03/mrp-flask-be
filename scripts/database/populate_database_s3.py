import psycopg2
import os
from urllib.parse import quote_plus

# Configuración de conexión
password = quote_plus('Marcelojp03')
DB_CONFIG = {
    'host': 'localhost',
    'database': 'mrp_db',
    'user': 'postgres',
    'password': 'Marcelojp03'
}

def ejecutar_sql_file(cursor, filepath, encoding='utf-8'):
    """Ejecuta un archivo SQL"""
    print(f"\n📄 Ejecutando: {filepath}")
    try:
        with open(filepath, 'r', encoding=encoding) as f:
            sql = f.read()
            cursor.execute(sql)
        print(f"✅ {filepath} ejecutado correctamente")
        return True
    except Exception as e:
        print(f"❌ Error en {filepath}: {str(e)}")
        return False

def main():
    conn = None
    try:
        # Conectar a la base de datos
        print("🔌 Conectando a PostgreSQL...")
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        print("✅ Conexión establecida\n")
        
        # 1. Limpiar base de datos
        print("=" * 60)
        print("PASO 1: Limpiando base de datos")
        print("=" * 60)
        if ejecutar_sql_file(cur, 'seeds/clean_database.sql'):
            conn.commit()
            print("✅ Base de datos limpiada\n")
        else:
            conn.rollback()
            print("⚠️  Advertencia: No se pudo limpiar la base de datos\n")
        
        # 2. Cargar seeds completos
        print("=" * 60)
        print("PASO 2: Cargando seeds completos (S1-S3)")
        print("=" * 60)
        if ejecutar_sql_file(cur, 'seeds/full_database_seeds.sql', encoding='latin-1'):
            conn.commit()
            print("✅ Seeds completos cargados\n")
        else:
            conn.rollback()
            raise Exception("Error al cargar seeds")
        
        # 3. Verificar datos cargados
        print("=" * 60)
        print("VERIFICACIÓN DE DATOS")
        print("=" * 60)
        
        verificaciones = [
            ("Planes SaaS", "SELECT COUNT(*) FROM plan"),
            ("Organizaciones", "SELECT COUNT(*) FROM organization"),
            ("Roles", "SELECT COUNT(*) FROM role"),
            ("Recursos", "SELECT COUNT(*) FROM resource"),
            ("Subrecursos", "SELECT COUNT(*) FROM subresource"),
            ("Usuarios", "SELECT COUNT(*) FROM \"user\""),
            ("Almacenes", "SELECT COUNT(*) FROM warehouse"),
            ("Productos", "SELECT COUNT(*) FROM product"),
            ("Proveedores", "SELECT COUNT(*) FROM supplier"),
            ("BOMs", "SELECT COUNT(*) FROM bom"),
            ("Componentes BOM", "SELECT COUNT(*) FROM bom_component"),
            ("Work Orders", "SELECT COUNT(*) FROM work_order"),
        ]
        
        for nombre, query in verificaciones:
            cur.execute(query)
            count = cur.fetchone()[0]
            print(f"✓ {nombre}: {count}")
        
        print("\n" + "=" * 60)
        print("MENÚ POR ROLES")
        print("=" * 60)
        
        # Verificar menú por rol
        cur.execute("""
            SELECT r.name, COUNT(DISTINCT rr.subresource_id) as total_subrecursos
            FROM role r
            LEFT JOIN role_resource rr ON rr.role_id = r.id
            GROUP BY r.name
            ORDER BY r.name
        """)
        
        for row in cur.fetchall():
            print(f"✓ {row[0]}: {row[1]} subrecursos")
        
        print("\n" + "=" * 60)
        print("✅ POBLACIÓN COMPLETA EXITOSA")
        print("=" * 60)
        print("\n📋 Credenciales de acceso:")
        print("  • admin@acme.com / admin123")
        print("  • planner@acme.com / planner123")
        print("  • super@acme.com / super123")
        print("  • op@acme.com / op123")
        print("\n🏭 Producción:")
        print("  • 2 BOMs activas (FG-MESA, FG-SILLA)")
        print("  • 2 Work Orders planificadas")
        print("\n🚀 Sistema listo para Sprint 3")
        
    except Exception as e:
        if conn:
            conn.rollback()
        print(f"\n❌ ERROR: {str(e)}")
        raise
    finally:
        if conn:
            cur.close()
            conn.close()
            print("\n🔌 Conexión cerrada")

if __name__ == "__main__":
    main()
