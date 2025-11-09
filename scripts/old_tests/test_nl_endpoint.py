#!/usr/bin/env python3
"""
Test del endpoint /api/reports/nl
"""
import requests
import json

BASE_URL = "http://localhost:4646"

def test_nl_endpoint():
    print("=" * 60)
    print("🧪 TEST DE /api/reports/nl")
    print("=" * 60)
    
    # Login
    print("\n1️⃣ Login...")
    response = requests.post(f"{BASE_URL}/api/auth/login", json={
        "email": "marcelojp03@gmail.com",
        "password": "mrp123"
    })
    
    if response.status_code == 200:
        token = response.json()['data']['access_token']
        print(f"✅ Token obtenido")
    else:
        print(f"❌ Login falló: {response.status_code}")
        print(response.text)
        return
    
    headers = {
        'Authorization': f'Bearer {token}',
        'Content-Type': 'application/json'
    }
    
    # Test 1: Query simple
    print("\n2️⃣ POST /api/reports/nl - Query simple")
    test_query = {
        "query": "¿cuántos productos tengo?",
        "format": "json",
        "dry_run": False
    }
    
    print(f"Request: {json.dumps(test_query, indent=2)}")
    
    response = requests.post(
        f"{BASE_URL}/api/reports/nl",
        headers=headers,
        json=test_query
    )
    
    print(f"\nStatus: {response.status_code}")
    print(f"Headers: {dict(response.headers)}")
    
    try:
        data = response.json()
        print(f"\nResponse Body:")
        print(json.dumps(data, indent=2, ensure_ascii=False))
        
        # Mostrar interpretación si existe
        if data.get('success') and 'interpretation' in data.get('data', {}):
            print(f"\n💬 INTERPRETACIÓN EN LENGUAJE NATURAL:")
            print(f"   {data['data']['interpretation']}")
            print(f"\n📊 Resumen:")
            if 'summary' in data['data']:
                summary = data['data']['summary']
                print(f"   - Total de filas: {summary.get('total_rows', 'N/A')}")
                print(f"   - Tiempo de ejecución: {summary.get('execution_time_ms', 0):.0f} ms")
    except:
        print(f"\nResponse Text:")
        print(response.text)
    
    # Test 2: Dry run
    print("\n" + "=" * 60)
    print("\n3️⃣ POST /api/reports/nl - Dry run (solo generar SQL)")
    test_query_dry = {
        "query": "lista de productos activos",
        "format": "json",
        "dry_run": True
    }
    
    print(f"Request: {json.dumps(test_query_dry, indent=2)}")
    
    response = requests.post(
        f"{BASE_URL}/api/reports/nl",
        headers=headers,
        json=test_query_dry
    )
    
    print(f"\nStatus: {response.status_code}")
    
    try:
        data = response.json()
        print(f"\nResponse Body:")
        print(json.dumps(data, indent=2, ensure_ascii=False))
    except:
        print(f"\nResponse Text:")
        print(response.text)
    
    print("\n" + "=" * 60)

if __name__ == '__main__':
    test_nl_endpoint()
