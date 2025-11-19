from run import app

modules = ['demand', 'mps', 'mrp', 'forecast', 'alert']
for m in modules:
    routes = [str(rule) for rule in app.url_map.iter_rules() if m in str(rule).lower()]
    print(f'\n{m.upper()} ({len(routes)} rutas):')
    for r in sorted(routes)[:8]:
        print(f'  {r}')
