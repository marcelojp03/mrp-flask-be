"""
Script para poblar la base de datos con seeds completos (S1-S3)
Usa el ORM de SQLAlchemy del proyecto para evitar problemas de encoding
"""
import sys
from app.db import db
from run import app

def ejecutar_sql_file(filepath, encoding='utf-8'):
    """Ejecuta un archivo SQL usando SQLAlchemy"""
    print(f"\nEjecutando: {filepath}")
    try:
        with open(filepath, 'r', encoding=encoding) as f:
            sql = f.read()
            # Ejecutar cada statement por separado
            statements = []
            for s in sql.split(';'):
                s = s.strip()
                # Skip comentarios y líneas vacías
                if not s or s.startswith('--'):
                    continue
                # Remover líneas de comentarios
                lines = [line for line in s.split('\n') if not line.strip().startswith('--')]
                cleaned = '\n'.join(lines).strip()
                if cleaned:
                    statements.append(cleaned)
            
            for stmt in statements:
                db.session.execute(db.text(stmt))
            db.session.commit()
        print(f"OK {filepath} ejecutado correctamente")
        return True
    except Exception as e:
        print(f"ERROR en {filepath}: {str(e)}")
        db.session.rollback()
        return False

def main():
    with app.app_context():
        try:
            # 1. Limpiar base de datos
            print("=" * 60)
            print("PASO 1: Limpiando base de datos")
            print("=" * 60)
            if ejecutar_sql_file('seeds/clean_database.sql'):
                print("OK Base de datos limpiada\n")
            else:
                print("WARNING: No se pudo limpiar la base de datos\n")
            
            # 2. Cargar seeds completos
            print("=" * 60)
            print("PASO 2: Cargando seeds completos (S1-S3)")
            print("=" * 60)
            if ejecutar_sql_file('seeds/full_database_seeds.sql', encoding='latin-1'):
                print("OK Seeds completos cargados\n")
            else:
                raise Exception("Error al cargar seeds")
            
            # 3. Verificar datos cargados
            print("=" * 60)
            print("VERIFICACION DE DATOS")
            print("=" * 60)
            
            verificaciones = [
                ("Planes SaaS", "SELECT COUNT(*) FROM plan"),
                ("Organizaciones", "SELECT COUNT(*) FROM organization"),
                ("Roles", "SELECT COUNT(*) FROM role"),
                ("Recursos", "SELECT COUNT(*) FROM resource"),
                ("Subrecursos", "SELECT COUNT(*) FROM subresource"),
                ("Usuarios", 'SELECT COUNT(*) FROM "user"'),
                ("Almacenes", "SELECT COUNT(*) FROM warehouse"),
                ("Productos", "SELECT COUNT(*) FROM product"),
                ("Proveedores", "SELECT COUNT(*) FROM supplier"),
                ("BOMs", "SELECT COUNT(*) FROM bom"),
                ("Componentes BOM", "SELECT COUNT(*) FROM bom_component"),
                ("Work Orders", "SELECT COUNT(*) FROM work_order"),
            ]
            
            for nombre, query in verificaciones:
                result = db.session.execute(db.text(query))
                count = result.scalar()
                print(f"OK {nombre}: {count}")
            
            print("\n" + "=" * 60)
            print("MENU POR ROLES")
            print("=" * 60)
            
            # Verificar menú por rol
            result = db.session.execute(db.text("""
                SELECT r.name, COUNT(DISTINCT rr.subresource_id) as total_subrecursos
                FROM role r
                LEFT JOIN role_resource rr ON rr.role_id = r.id
                GROUP BY r.name
                ORDER BY r.name
            """))
            
            for row in result:
                print(f"OK {row[0]}: {row[1]} subrecursos")
            
            print("\n" + "=" * 60)
            print("POBLACION COMPLETA EXITOSA")
            print("=" * 60)
            print("\nCredenciales de acceso:")
            print("  admin@acme.com / admin123")
            print("  planner@acme.com / planner123")
            print("  super@acme.com / super123")
            print("  op@acme.com / op123")
            print("\nProduccion:")
            print("  2 BOMs activas (FG-MESA, FG-SILLA)")
            print("  2 Work Orders planificadas")
            print("\nSistema listo para Sprint 3")
            
        except Exception as e:
            print(f"\nERROR: {str(e)}")
            db.session.rollback()
            sys.exit(1)

if __name__ == "__main__":
    main()
