#!/usr/bin/env python3
"""
Test de endpoints de supplier_items
"""
import requests
import json

BASE_URL = "http://localhost:4646"

def login():
    """Login y obtener token"""
    response = requests.post(f"{BASE_URL}/api/auth/login", json={
        "email": "marcelojp03@gmail.com",
        "password": "mrp123"
    })
    if response.status_code == 200:
        data = response.json()
        return data['data']['access_token']
    else:
        print(f"❌ Login falló: {response.status_code}")
        return None

def test_endpoints():
    print("=" * 60)
    print("🧪 TEST DE SUPPLIER ITEMS ENDPOINTS")
    print("=" * 60)
    
    # Login
    token = login()
    if not token:
        return
    
    headers = {
        'Authorization': f'Bearer {token}',
        'Content-Type': 'application/json'
    }
    
    # 1. Listar todos los supplier_items
    print("\n1️⃣ GET /api/supplier-items")
    response = requests.get(f"{BASE_URL}/api/supplier-items", headers=headers)
    print(f"Status: {response.status_code}")
    if response.status_code == 200:
        data = response.json()
        items = data.get('data', [])
        print(f"✅ Total items: {len(items)}")
        if items:
            print(f"Primer item: {json.dumps(items[0], indent=2)}")
            test_item_id = items[0]['id']
        else:
            print("⚠️  No hay items para probar")
            return
    else:
        print(f"❌ Error: {response.text}")
        return
    
    # 2. Probar set-preferred
    print(f"\n2️⃣ PUT /api/supplier-items/{test_item_id}/set-preferred")
    response = requests.put(f"{BASE_URL}/api/supplier-items/{test_item_id}/set-preferred", headers=headers)
    print(f"Status: {response.status_code}")
    if response.status_code == 200:
        data = response.json()
        print(f"✅ Respuesta: {json.dumps(data, indent=2)}")
        if data['data']['is_preferred']:
            print("✅ Item marcado como preferido correctamente")
    else:
        print(f"❌ Error: {response.text}")
    
    # 3. Probar toggle-active
    print(f"\n3️⃣ PUT /api/supplier-items/{test_item_id}/toggle-active")
    response = requests.put(f"{BASE_URL}/api/supplier-items/{test_item_id}/toggle-active", headers=headers)
    print(f"Status: {response.status_code}")
    if response.status_code == 200:
        data = response.json()
        print(f"✅ Respuesta: {json.dumps(data, indent=2)}")
        print(f"Estado actual: is_active={data['data']['is_active']}")
    else:
        print(f"❌ Error: {response.text}")
    
    # 4. Toggle de nuevo para regresar al estado original
    print(f"\n4️⃣ PUT /api/supplier-items/{test_item_id}/toggle-active (revertir)")
    response = requests.put(f"{BASE_URL}/api/supplier-items/{test_item_id}/toggle-active", headers=headers)
    print(f"Status: {response.status_code}")
    if response.status_code == 200:
        data = response.json()
        print(f"✅ Estado revertido: is_active={data['data']['is_active']}")
    else:
        print(f"❌ Error: {response.text}")
    
    print("\n" + "=" * 60)
    print("✅ PRUEBAS COMPLETADAS")
    print("=" * 60)

if __name__ == '__main__':
    test_endpoints()
