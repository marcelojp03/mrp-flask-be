import os
import psycopg2
from dotenv import load_dotenv

# Cargar variables de entorno
load_dotenv()

DB_HOST = os.getenv('DB_HOST')
DB_NAME = os.getenv('DB_NAME')
DB_USER = os.getenv('DB_USER')
DB_PASSWORD = os.getenv('DB_PASS')  # Usar DB_PASS en lugar de DB_PASSWORD
DB_SCHEMA = os.getenv('DB_SCHEMA', 'mrp')

print(f'\n🔄 Aplicando migraciones Sprint 4...')
print(f'Host: {DB_HOST}')
print(f'Database: {DB_NAME}')
print(f'Schema: {DB_SCHEMA}\n')

try:
    # Conectar a la base de datos
    conn = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    conn.autocommit = False
    cur = conn.cursor()
    
    # Establecer schema
    cur.execute(f'SET search_path TO {DB_SCHEMA}, public;')
    
    # Lista de migraciones
    migrations = [
        ('016_create_demand_table.sql', 'Tabla demand'),
        ('017_create_mps_plan_table.sql', 'Tabla mps_plan'),
        ('018_create_mrp_proposal_table.sql', 'Tabla mrp_proposal')
    ]
    
    for filename, description in migrations:
        filepath = os.path.join('migrations', filename)
        print(f'📄 Aplicando: {description} ({filename})')
        
        with open(filepath, 'r', encoding='utf-8') as f:
            sql = f.read()
            cur.execute(sql)
        
        print(f'   ✅ {description} creada exitosamente\n')
    
    # Confirmar transacción
    conn.commit()
    print('✅ Todas las migraciones Sprint 4 aplicadas exitosamente!')
    
    # Verificar tablas creadas
    cur.execute("""
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = %s 
        AND table_name IN ('demand', 'mps_plan', 'mrp_proposal')
        ORDER BY table_name;
    """, (DB_SCHEMA,))
    
    tables = cur.fetchall()
    print(f'\n📊 Tablas creadas en schema {DB_SCHEMA}:')
    for table in tables:
        print(f'   - {table[0]}')
    
    cur.close()
    conn.close()
    
except Exception as e:
    print(f'\n❌ Error al aplicar migraciones: {e}')
    if conn:
        conn.rollback()
    raise
