"""Aplicar migración 019 - Alert table"""
import os
import psycopg2
from dotenv import load_dotenv

load_dotenv()

DB_HOST = os.getenv('DB_HOST')
DB_NAME = os.getenv('DB_NAME')
DB_USER = os.getenv('DB_USER')
DB_PASSWORD = os.getenv('DB_PASS')
DB_SCHEMA = os.getenv('DB_SCHEMA', 'mrp')

print(f'\n🔄 Aplicando migración 019 - Alert table...')
print(f'Host: {DB_HOST}')
print(f'Database: {DB_NAME}')
print(f'Schema: {DB_SCHEMA}\n')

try:
    conn = psycopg2.connect(
        host=DB_HOST,
        database=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD
    )
    conn.autocommit = False
    cur = conn.cursor()
    
    cur.execute(f'SET search_path TO {DB_SCHEMA}, public;')
    
    filepath = 'migrations/019_create_alert_table.sql'
    print(f'📄 Aplicando: {filepath}')
    
    with open(filepath, 'r', encoding='utf-8') as f:
        sql = f.read()
        cur.execute(sql)
    
    conn.commit()
    print(f'   ✅ Tabla alert creada exitosamente\n')
    
    # Verificar tabla creada
    cur.execute("""
        SELECT column_name, data_type 
        FROM information_schema.columns 
        WHERE table_schema = %s 
        AND table_name = 'alert'
        ORDER BY ordinal_position;
    """, (DB_SCHEMA,))
    
    columns = cur.fetchall()
    print(f'📊 Columnas creadas en alert:')
    for col_name, data_type in columns:
        print(f'   - {col_name}: {data_type}')
    
    cur.close()
    conn.close()
    
    print('\n✅ Migración 019 aplicada exitosamente!')
    
except Exception as e:
    print(f'\n❌ Error al aplicar migración: {e}')
    if conn:
        conn.rollback()
    raise
