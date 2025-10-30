#!/usr/bin/env python3
"""
Probar endpoints de stocks/low y dashboard/kpis
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
print("1️⃣ GET /api/stocks/low")
print("=" * 80)

response1 = requests.get(f"{BASE_URL}/api/stocks/low", headers=headers)
print(f"Status: {response1.status_code}")
print(f"\nResponse completa:")
print(json.dumps(response1.json(), indent=2, ensure_ascii=False))

print("\n" + "=" * 80)
print("2️⃣ GET /api/dashboard/kpis")
print("=" * 80)

response2 = requests.get(f"{BASE_URL}/api/dashboard/kpis", headers=headers)
print(f"Status: {response2.status_code}")
print(f"\nResponse completa:")
print(json.dumps(response2.json(), indent=2, ensure_ascii=False))

# Análisis de estructura
print("\n" + "=" * 80)
print("📋 ANÁLISIS PARA FRONTEND")
print("=" * 80)

print("\n✅ /api/stocks/low")
low_data = response1.json()
if 'data' in low_data:
    print(f"   Tipo de data: {type(low_data['data'])}")
    if isinstance(low_data['data'], list):
        print(f"   Cantidad de productos: {len(low_data['data'])}")
        if len(low_data['data']) > 0:
            print(f"   Estructura del primer item:")
            print(f"   {json.dumps(low_data['data'][0], indent=6, ensure_ascii=False)}")

print("\n✅ /api/dashboard/kpis")
kpis_data = response2.json()
if 'data' in kpis_data:
    print(f"   Tipo de data: {type(kpis_data['data'])}")
    if isinstance(kpis_data['data'], dict):
        print(f"   KPIs disponibles:")
        for key, value in kpis_data['data'].items():
            print(f"      - {key}: {value} ({type(value).__name__})")
