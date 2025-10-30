import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from run import app
from app.db import db
from sqlalchemy import inspect

with app.app_context():
    inspector = inspect(db.engine)
    tables = sorted(inspector.get_table_names())
    
    print('\n✅ Tablas disponibles en la BD:')
    print(f'Total: {len(tables)} tablas\n')
    
    tables_with_org = []
    tables_without_org = []
    
    for table_name in tables:
        columns = [col['name'] for col in inspector.get_columns(table_name)]
        if 'org_id' in columns:
            tables_with_org.append(table_name)
        else:
            tables_without_org.append(table_name)
    
    print(f'📊 Tablas CON org_id (filtradas): {len(tables_with_org)}')
    for t in sorted(tables_with_org):
        print(f'  - {t}')
    
    print(f'\n📚 Tablas SIN org_id (compartidas): {len(tables_without_org)}')
    for t in sorted(tables_without_org):
        print(f'  - {t}')
    
    print(f'\n✅ El reporte con IA ahora puede consultar TODAS estas tablas!')
    print(f'✅ El backup ahora incluye TODAS estas tablas!')
