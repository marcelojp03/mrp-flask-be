"""
Test: Listar movements con nombres
"""
import requests
import json

BASE_URL = "http://localhost:4646/api"

# Login
login_response = requests.post(f"{BASE_URL}/login", json={
    "email": "marcelojp03@gmail.com",
    "password": "123456"
})

if login_response.status_code != 200:
    print(f"❌ Error en login: {login_response.status_code}")
    print(login_response.text)
    exit(1)

token = login_response.json()['data']['access_token']
headers = {"Authorization": f"Bearer {token}"}

# Test: GET /api/movements
print("=" * 60)
print("TEST: GET /api/movements")
print("=" * 60)

response = requests.get(f"{BASE_URL}/movements", headers=headers)

print(f"Status: {response.status_code}")
print(f"Response: {json.dumps(response.json(), indent=2, ensure_ascii=False)}")

# Mostrar primeros 3 movimientos en formato tabla
if response.status_code == 200:
    movements = response.json()['data']
    print("\n" + "=" * 60)
    print(f"Total movimientos: {len(movements)}")
    print("=" * 60)
    print("\nPrimeros 3 movimientos:")
    print("-" * 60)
    
    for i, m in enumerate(movements[:3], 1):
        print(f"\n{i}. Movement ID: {m['id']}")
        print(f"   Producto: {m.get('product_name')} ({m.get('product_code')})")
        print(f"   Tipo: {m['movement_type']} - {m['reason']}")
        print(f"   Cantidad: {m['quantity']}")
        if m.get('from_warehouse_name'):
            print(f"   Desde: {m['from_warehouse_name']}")
        if m.get('to_warehouse_name'):
            print(f"   Hacia: {m['to_warehouse_name']}")
        if m.get('created_by_name'):
            print(f"   Creado por: {m['created_by_name']}")
