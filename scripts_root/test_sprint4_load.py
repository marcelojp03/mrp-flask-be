"""Test de carga de blueprints Sprint 4"""
from run import app

print('✅ Aplicación cargada exitosamente')
print(f'📊 Total blueprints registrados: {len(app.blueprints)}')
print('\nBlueprints Sprint 4:')
for bp in ['demand', 'mps', 'mrp']:
    status = '✅' if bp in app.blueprints else '❌'
    print(f'  - {bp}: {status}')

print('\nEndpoints Sprint 4:')
for rule in app.url_map.iter_rules():
    if any(x in str(rule) for x in ['/demand', '/mps', '/mrp']):
        print(f'  {rule.methods - {"HEAD", "OPTIONS"}} {rule}')
