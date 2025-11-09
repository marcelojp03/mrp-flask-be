"""
Test: Obtener productos con BOM activa
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
    exit(1)

token = login_response.json()['data']['access_token']
headers = {"Authorization": f"Bearer {token}"}

# Test: GET productos con BOM activa
print("=" * 60)
print("TEST: GET /api/boms/products-with-active-bom")
print("=" * 60)

response = requests.get(
    f"{BASE_URL}/boms/products-with-active-bom",
    headers=headers
)

print(f"Status: {response.status_code}")
if response.status_code == 200:
    products = response.json()['data']
    print(f"\n✅ {len(products)} productos con BOM activa:\n")
    
    for p in products:
        print(f"  ID: {p['id']}")
        print(f"  Código: {p['code']}")
        print(f"  Nombre: {p['name']}")
        print(f"  BOM Versión: {p['bom_version']}")
        print()
    
    print("=" * 60)
    print("💡 USAR ESTOS IDs PARA CREAR WORK ORDERS")
    print("=" * 60)
else:
    print(f"❌ Error: {response.json()}")
