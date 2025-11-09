"""
Test manual: Crear Work Order
"""
import requests
import json

BASE_URL = "http://localhost:4646/api"

# Login
print("🔐 Iniciando sesión...")
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
print("✅ Login exitoso\n")

# Test 1: Crear Work Order MÍNIMA (solo campos requeridos)
print("=" * 60)
print("TEST 1: Work Order MÍNIMA (solo product_id y quantity)")
print("=" * 60)

minimal_wo = {
    "product_id": 8,
    "quantity": 5
}

print(f"📤 Enviando: {json.dumps(minimal_wo, indent=2)}")

response = requests.post(
    f"{BASE_URL}/work-orders",
    headers=headers,
    json=minimal_wo
)

print(f"\n📥 Status: {response.status_code}")
if response.status_code == 201:
    print("✅ Work Order creada exitosamente!")
    data = response.json()['data']
    print(f"   ID: {data['id']}")
    print(f"   Producto: {data['product_name']}")
    print(f"   Cantidad: {data['quantity']}")
    print(f"   Estado: {data['status']}")
else:
    print(f"❌ Error:")
    print(json.dumps(response.json(), indent=2, ensure_ascii=False))

# Test 2: Crear Work Order COMPLETA
print("\n\n" + "=" * 60)
print("TEST 2: Work Order COMPLETA (todos los campos)")
print("=" * 60)

complete_wo = {
    "product_id": 7,
    "quantity": 10,
    "warehouse_id": 1,
    "reference": "OP-TEST-001",
    "notes": "Orden de prueba desde script",
    "assigned_to": 1,
    "planned_start": "2025-11-01T08:00:00",
    "planned_end": "2025-11-03T18:00:00"
}

print(f"📤 Enviando: {json.dumps(complete_wo, indent=2)}")

response = requests.post(
    f"{BASE_URL}/work-orders",
    headers=headers,
    json=complete_wo
)

print(f"\n📥 Status: {response.status_code}")
if response.status_code == 201:
    print("✅ Work Order creada exitosamente!")
    data = response.json()['data']
    print(f"   ID: {data['id']}")
    print(f"   Producto: {data['product_name']}")
    print(f"   Cantidad: {data['quantity']}")
    print(f"   Estado: {data['status']}")
    print(f"   Referencia: {data['reference']}")
    print(f"   Almacén: {data.get('warehouse_name', 'N/A')}")
else:
    print(f"❌ Error:")
    print(json.dumps(response.json(), indent=2, ensure_ascii=False))

# Test 3: Intentar con producto sin BOM (debe fallar)
print("\n\n" + "=" * 60)
print("TEST 3: Producto sin BOM (debe retornar error)")
print("=" * 60)

invalid_wo = {
    "product_id": 2,  # Aluminio (materia prima, no tiene BOM)
    "quantity": 5
}

print(f"📤 Enviando: {json.dumps(invalid_wo, indent=2)}")

response = requests.post(
    f"{BASE_URL}/work-orders",
    headers=headers,
    json=invalid_wo
)

print(f"\n📥 Status: {response.status_code}")
if response.status_code == 400:
    print("✅ Error esperado (producto sin BOM):")
    print(f"   {response.json()['message']}")
else:
    print(f"⚠️  Respuesta inesperada:")
    print(json.dumps(response.json(), indent=2, ensure_ascii=False))

print("\n" + "=" * 60)
print("RESUMEN:")
print("  Solo products 7 (Mesa) y 8 (Silla) tienen BOM activa")
print("  Campos requeridos: product_id, quantity")
print("  Ambos deben ser números, no strings")
print("=" * 60)
