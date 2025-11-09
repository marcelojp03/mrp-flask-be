"""
Test directo de endpoints de BOMs y Work Orders
"""
import requests
import json

BASE_URL = "http://localhost:4646"

# 1. Login para obtener token
print("🔐 Haciendo login...")
login_response = requests.post(f"{BASE_URL}/api/auth/login", json={
    "email": "marcelojp03@gmail.com",
    "password": "mrp123"
})

if login_response.status_code == 200:
    token = login_response.json()['data']['access_token']
    headers = {'Authorization': f'Bearer {token}'}
    print(f"✅ Login exitoso\n")
    
    # 2. Test BOMs
    print("=" * 60)
    print("TEST: GET /api/boms")
    print("=" * 60)
    try:
        response = requests.get(f"{BASE_URL}/api/boms", headers=headers)
        print(f"Status: {response.status_code}")
        print(f"Response: {json.dumps(response.json(), indent=2)}")
    except Exception as e:
        print(f"❌ Error: {e}")
        print(f"Response text: {response.text}")
    
    print("\n")
    
    # 3. Test Work Orders
    print("=" * 60)
    print("TEST: GET /api/work-orders")
    print("=" * 60)
    try:
        response = requests.get(f"{BASE_URL}/api/work-orders", headers=headers)
        print(f"Status: {response.status_code}")
        print(f"Response: {json.dumps(response.json(), indent=2)}")
    except Exception as e:
        print(f"❌ Error: {e}")
        print(f"Response text: {response.text}")
    
    print("\n")
    
    # 4. Test Work Orders con filtro
    print("=" * 60)
    print("TEST: GET /api/work-orders?status=Planificada")
    print("=" * 60)
    try:
        response = requests.get(f"{BASE_URL}/api/work-orders?status=Planificada", headers=headers)
        print(f"Status: {response.status_code}")
        print(f"Response: {json.dumps(response.json(), indent=2)}")
    except Exception as e:
        print(f"❌ Error: {e}")
        print(f"Response text: {response.text}")
    
    print("\n")
    
    # 5. Test Movements
    print("=" * 60)
    print("TEST: GET /api/movements")
    print("=" * 60)
    try:
        response = requests.get(f"{BASE_URL}/api/movements", headers=headers)
        print(f"Status: {response.status_code}")
        print(f"Response: {json.dumps(response.json(), indent=2)}")
    except Exception as e:
        print(f"❌ Error: {e}")
        print(f"Response text: {response.text}")
        
else:
    print(f"❌ Login falló: {login_response.status_code}")
    print(login_response.text)
