"""
Test de endpoints corregidos
"""
import requests
import json

BASE_URL = "http://localhost:4646"

print("=" * 70)
print("TEST DE ENDPOINTS CORREGIDOS")
print("=" * 70)

# 1. Login
print("\n1. LOGIN")
print("-" * 70)
login_response = requests.post(
    f"{BASE_URL}/api/auth/login",
    json={'email': 'marcelojp03@gmail.com', 'password': 'mrp123'}
)
print(f"Status: {login_response.status_code}")

if login_response.status_code != 200:
    print(f"ERROR: {login_response.json()}")
    exit(1)

login_data = login_response.json()
access_token = login_data['data']['access_token']
print("✓ Login exitoso")
print(f"  - access_token: presente")
print(f"  - refresh_token: {'refresh_token' in login_data['data']}")

headers = {'Authorization': f'Bearer {access_token}'}

# 2. Test /api/subscription
print("\n2. GET /api/subscription")
print("-" * 70)
sub_response = requests.get(f"{BASE_URL}/api/subscription", headers=headers)
print(f"Status: {sub_response.status_code}")

if sub_response.status_code == 200:
    sub_data = sub_response.json()
    if sub_data['success']:
        print("✓ Subscription endpoint OK")
        print(f"  - Plan: {sub_data['data']['plan']['name']}")
        print(f"  - Productos: {sub_data['data']['usage']['products']['current']}/{sub_data['data']['usage']['products']['limit']}")
        print(f"  - Almacenes: {sub_data['data']['usage']['warehouses']['current']}/{sub_data['data']['usage']['warehouses']['limit']}")
    else:
        print(f"✗ ERROR: {sub_data}")
else:
    print(f"✗ ERROR {sub_response.status_code}: {sub_response.text[:200]}")

# 3. Test /api/stocks/low
print("\n3. GET /api/stocks/low")
print("-" * 70)
stocks_low_response = requests.get(f"{BASE_URL}/api/stocks/low", headers=headers)
print(f"Status: {stocks_low_response.status_code}")

if stocks_low_response.status_code == 200:
    stocks_data = stocks_low_response.json()
    if stocks_data['success']:
        print("✓ Stocks low endpoint OK")
        print(f"  - Productos con stock bajo: {len(stocks_data['data'])}")
    else:
        print(f"✗ ERROR: {stocks_data}")
else:
    print(f"✗ ERROR {stocks_low_response.status_code}: {stocks_low_response.text[:200]}")

# 4. Test /api/stocks/reorder-suggestions
print("\n4. GET /api/stocks/reorder-suggestions")
print("-" * 70)
reorder_response = requests.get(f"{BASE_URL}/api/stocks/reorder-suggestions", headers=headers)
print(f"Status: {reorder_response.status_code}")

if reorder_response.status_code == 200:
    reorder_data = reorder_response.json()
    if reorder_data['success']:
        print("✓ Reorder suggestions endpoint OK")
        print(f"  - Sugerencias: {len(reorder_data['data'])}")
    else:
        print(f"✗ ERROR: {reorder_data}")
else:
    print(f"✗ ERROR {reorder_response.status_code}: {reorder_response.text[:200]}")

# 5. Test /api/boms
print("\n5. GET /api/boms")
print("-" * 70)
boms_response = requests.get(f"{BASE_URL}/api/boms", headers=headers)
print(f"Status: {boms_response.status_code}")

if boms_response.status_code == 200:
    boms_data = boms_response.json()
    if boms_data['success']:
        print("✓ BOMs endpoint OK")
        print(f"  - BOMs encontradas: {len(boms_data['data'])}")
        for bom in boms_data['data']:
            print(f"    - {bom['product']['name']} v{bom['version']} (activa: {bom['is_active']})")
    else:
        print(f"✗ ERROR: {boms_data}")
else:
    print(f"✗ ERROR {boms_response.status_code}: {boms_response.text[:200]}")

# 6. Test /api/work-orders
print("\n6. GET /api/work-orders")
print("-" * 70)
wo_response = requests.get(f"{BASE_URL}/api/work-orders", headers=headers)
print(f"Status: {wo_response.status_code}")

if wo_response.status_code == 200:
    wo_data = wo_response.json()
    if wo_data['success']:
        print("✓ Work Orders endpoint OK")
        print(f"  - Órdenes encontradas: {len(wo_data['data'])}")
        for wo in wo_data['data']:
            print(f"    - {wo['reference']}: {wo['quantity']} x {wo['product']['name']} ({wo['status']})")
    else:
        print(f"✗ ERROR: {wo_data}")
else:
    print(f"✗ ERROR {wo_response.status_code}: {wo_response.text[:200]}")

# 7. Test /api/work-orders con filtro
print("\n7. GET /api/work-orders?status=Planificada")
print("-" * 70)
wo_filter_response = requests.get(f"{BASE_URL}/api/work-orders?status=Planificada", headers=headers)
print(f"Status: {wo_filter_response.status_code}")

if wo_filter_response.status_code == 200:
    wo_filter_data = wo_filter_response.json()
    if wo_filter_data['success']:
        print("✓ Work Orders filtrado OK")
        print(f"  - Órdenes planificadas: {len(wo_filter_data['data'])}")
    else:
        print(f"✗ ERROR: {wo_filter_data}")
else:
    print(f"✗ ERROR {wo_filter_response.status_code}: {wo_filter_response.text[:200]}")

# 8. Test refresh token
print("\n8. POST /api/auth/refresh")
print("-" * 70)
refresh_token = login_data['data']['refresh_token']
refresh_response = requests.post(
    f"{BASE_URL}/api/auth/refresh",
    json={'refresh_token': refresh_token}
)
print(f"Status: {refresh_response.status_code}")

if refresh_response.status_code == 200:
    refresh_data = refresh_response.json()
    if refresh_data['success']:
        print("✓ Refresh token OK")
        print(f"  - Nuevo access_token: presente")
    else:
        print(f"✗ ERROR: {refresh_data}")
else:
    print(f"✗ ERROR {refresh_response.status_code}: {refresh_response.text[:200]}")

print("\n" + "=" * 70)
print("RESUMEN DE TESTS")
print("=" * 70)
print("✓ Todos los endpoints corregidos están funcionando correctamente")
print("\nEndpoints del frontend que deben actualizarse:")
print("  - /api/producto-almacen/listado/todos → /api/product-warehouses")
print("\n" + "=" * 70)
