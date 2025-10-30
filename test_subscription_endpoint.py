#!/usr/bin/env python3
"""
Test específico del endpoint /api/subscription con token válido
"""
import requests
import json

BASE_URL = "http://localhost:4646"

# Paso 1: Login
print("🔐 Login...")
login_response = requests.post(f"{BASE_URL}/api/auth/login", json={
    "email": "marcelojp03@gmail.com",
    "password": "mrp123"
})

if login_response.status_code != 200:
    print(f"❌ Login falló: {login_response.text}")
    exit(1)

token = login_response.json()['data']['access_token']
print(f"✅ Token obtenido: {token[:50]}...\n")

# Paso 2: Llamar a /api/subscription CON token
print("📊 Consultando /api/subscription CON token...")
headers = {"Authorization": f"Bearer {token}"}
response = requests.get(f"{BASE_URL}/api/subscription", headers=headers)

print(f"Status: {response.status_code}")
print(f"\nRespuesta completa:")
print(json.dumps(response.json(), indent=2, ensure_ascii=False))

if response.status_code == 200:
    data = response.json()
    org = data.get('organization', {})
    sub = data.get('subscription', {})
    plan = data.get('plan', {})
    usage = data.get('usage', {})
    
    print("\n" + "=" * 70)
    print("RESUMEN DE SUSCRIPCIÓN")
    print("=" * 70)
    print(f"Organización: {org.get('name')} ({org.get('code')})")
    print(f"Plan: {plan.get('name')} ({plan.get('code')})")
    print(f"Status: {sub.get('status')}")
    print(f"Trial: {sub.get('is_trial')} | Días restantes: {sub.get('trial_days_remaining')}")
    print(f"\nUso actual:")
    print(f"  Productos: {usage.get('products', {}).get('current')}/{usage.get('products', {}).get('limit')}")
    print(f"  Almacenes: {usage.get('warehouses', {}).get('current')}/{usage.get('warehouses', {}).get('limit')}")
    print(f"  Movimientos hoy: {usage.get('movements_today', {}).get('current')}/{usage.get('movements_today', {}).get('limit')}")
