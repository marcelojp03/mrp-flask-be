"""
Test de endpoints corregidos
"""
import requests
import json

BASE_URL = "http://localhost:4646"

print("=" * 60)
print("TEST DE ENDPOINTS CORREGIDOS")
print("=" * 60)

# 1. Login
print("\n1. LOGIN")
login_response = requests.post(
    f'{BASE_URL}/api/auth/login',
    json={'email': 'marcelojp03@gmail.com', 'password': 'mrp123'}
)
print(f"Status: {login_response.status_code}")

if login_response.status_code != 200:
    print("ERROR en login, no se puede continuar")
    exit(1)

token = login_response.json()['data']['access_token']
headers = {'Authorization': f'Bearer {token}'}
print("✓ Login exitoso")

# 2. Test /api/subscription
print("\n2. TEST /api/subscription")
sub_response = requests.get(f'{BASE_URL}/api/subscription', headers=headers)
print(f"Status: {sub_response.status_code}")
if sub_response.status_code == 200:
    data = sub_response.json()['data']
    print(f"✓ Plan: {data['plan']['name']}")
    print(f"✓ Productos: {data['usage']['products']['current']}/{data['usage']['products']['limit']}")
    print(f"✓ Almacenes: {data['usage']['warehouses']['current']}/{data['usage']['warehouses']['limit']}")
else:
    print(f"✗ Error: {sub_response.text[:200]}")

# 3. Test /api/producto-almacen/listado/todos
print("\n3. TEST /api/producto-almacen/listado/todos")
pa_response = requests.get(f'{BASE_URL}/api/producto-almacen/listado/todos', headers=headers)
print(f"Status: {pa_response.status_code}")
if pa_response.status_code == 200:
    data = pa_response.json()['data']
    print(f"✓ Total relaciones: {len(data)}")
else:
    print(f"✗ Error: {pa_response.text[:200]}")

# 4. Test /api/stocks/low
print("\n4. TEST /api/stocks/low")
low_response = requests.get(f'{BASE_URL}/api/stocks/low', headers=headers)
print(f"Status: {low_response.status_code}")
if low_response.status_code == 200:
    data = low_response.json()['data']
    print(f"✓ Productos con stock bajo: {len(data)}")
else:
    print(f"✗ Error: {low_response.text[:200]}")

# 5. Test /api/stocks/reorder-suggestions
print("\n5. TEST /api/stocks/reorder-suggestions")
reorder_response = requests.get(f'{BASE_URL}/api/stocks/reorder-suggestions', headers=headers)
print(f"Status: {reorder_response.status_code}")
if reorder_response.status_code == 200:
    data = reorder_response.json()['data']
    print(f"✓ Sugerencias: {len(data)}")
else:
    print(f"✗ Error: {reorder_response.text[:200]}")

# 6. Test /api/boms
print("\n6. TEST /api/boms")
boms_response = requests.get(f'{BASE_URL}/api/boms', headers=headers)
print(f"Status: {boms_response.status_code}")
if boms_response.status_code == 200:
    data = boms_response.json()['data']
    print(f"✓ BOMs encontradas: {len(data)}")
    for bom in data:
        print(f"  - {bom.get('product', {}).get('name', 'N/A')} v{bom.get('version')}")
else:
    print(f"✗ Error: {boms_response.text[:500]}")

# 7. Test /api/work-orders
print("\n7. TEST /api/work-orders")
wo_response = requests.get(f'{BASE_URL}/api/work-orders', headers=headers)
print(f"Status: {wo_response.status_code}")
if wo_response.status_code == 200:
    data = wo_response.json()['data']
    print(f"✓ Work Orders encontradas: {len(data)}")
    for wo in data:
        print(f"  - {wo.get('reference', 'N/A')}: {wo.get('quantity')} x {wo.get('product', {}).get('name', 'N/A')} ({wo.get('status')})")
else:
    print(f"✗ Error: {wo_response.text[:500]}")

# 8. Test /api/work-orders?status=Planificada
print("\n8. TEST /api/work-orders?status=Planificada")
wo_planned_response = requests.get(f'{BASE_URL}/api/work-orders?status=Planificada', headers=headers)
print(f"Status: {wo_planned_response.status_code}")
if wo_planned_response.status_code == 200:
    data = wo_planned_response.json()['data']
    print(f"✓ Órdenes planificadas: {len(data)}")
else:
    print(f"✗ Error: {wo_planned_response.text[:500]}")

print("\n" + "=" * 60)
print("TESTS COMPLETADOS")
print("=" * 60)
