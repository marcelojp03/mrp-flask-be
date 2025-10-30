#!/usr/bin/env python3
"""
Probar endpoint de reorder suggestions
"""
import requests
import json

BASE_URL = "http://localhost:4646"

# Login
print("🔐 Login...")
login_response = requests.post(f"{BASE_URL}/api/auth/login", json={
    "email": "marcelojp03@gmail.com",
    "password": "mrp123"
})

token = login_response.json()['data']['access_token']
headers = {"Authorization": f"Bearer {token}"}

print("\n" + "=" * 80)
print("📦 GET /api/stocks/reorder-suggestions")
print("=" * 80)

response = requests.get(f"{BASE_URL}/api/stocks/reorder-suggestions", headers=headers)
print(f"Status: {response.status_code}")
print(f"\nResponse completa:")
print(json.dumps(response.json(), indent=2, ensure_ascii=False))

# Análisis de estructura
print("\n" + "=" * 80)
print("📋 ANÁLISIS PARA FRONTEND")
print("=" * 80)

data = response.json()
if 'data' in data:
    print(f"Tipo de data: {type(data['data'])}")
    if isinstance(data['data'], list):
        print(f"Cantidad de sugerencias: {len(data['data'])}")
        if len(data['data']) > 0:
            print(f"\nEstructura del primer item:")
            print(json.dumps(data['data'][0], indent=2, ensure_ascii=False))
            
            print(f"\nCampos disponibles:")
            for key in data['data'][0].keys():
                value = data['data'][0][key]
                print(f"  - {key}: {type(value).__name__}")
