#!/usr/bin/env python3
"""
Script de diagnóstico para problemas de autenticación 401
"""
import requests
import json

BASE_URL = "http://localhost:4646"

def test_login():
    """Test 1: Login y obtener tokens"""
    print("=" * 70)
    print("TEST 1: LOGIN")
    print("=" * 70)
    
    response = requests.post(f"{BASE_URL}/api/auth/login", json={
        "email": "marcelojp03@gmail.com",
        "password": "mrp123"
    })
    
    print(f"Status: {response.status_code}")
    
    if response.status_code == 200:
        data = response.json()
        print(f"✓ Login exitoso")
        print(f"  Response completo: {json.dumps(data, indent=2)}")
        
        # Intentar extraer token de diferentes ubicaciones
        token = None
        if 'access_token' in data:
            token = data['access_token']
        elif 'token' in data:
            token = data['token']
        elif 'data' in data and isinstance(data['data'], dict):
            token = data['data'].get('access_token') or data['data'].get('token')
        
        if token:
            print(f"  - Token encontrado: {token[:50]}...")
        else:
            print(f"  ⚠️ No se encontró token en la respuesta")
        
        return token
    else:
        print(f"✗ Login falló: {response.text}")
        return None

def test_subscription(token):
    """Test 2: GET /api/subscription con token"""
    print("\n" + "=" * 70)
    print("TEST 2: GET /api/subscription")
    print("=" * 70)
    
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(f"{BASE_URL}/api/subscription", headers=headers)
    
    print(f"Status: {response.status_code}")
    print(f"Headers enviados: {headers}")
    
    if response.status_code == 200:
        print(f"✓ Subscription OK")
        data = response.json()
        print(f"  Organización: {data.get('organization', {}).get('name')}")
        print(f"  Plan: {data.get('plan', {}).get('name')}")
    else:
        print(f"✗ Error: {response.text}")

def test_stocks_low(token):
    """Test 3: GET /api/stocks/low con token"""
    print("\n" + "=" * 70)
    print("TEST 3: GET /api/stocks/low")
    print("=" * 70)
    
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(f"{BASE_URL}/api/stocks/low", headers=headers)
    
    print(f"Status: {response.status_code}")
    
    if response.status_code == 200:
        print(f"✓ Stocks low OK")
        data = response.json()
        print(f"  Productos con stock bajo: {len(data)}")
    else:
        print(f"✗ Error: {response.text}")

def test_stocks_reorder(token):
    """Test 4: GET /api/stocks/reorder-suggestions con token"""
    print("\n" + "=" * 70)
    print("TEST 4: GET /api/stocks/reorder-suggestions")
    print("=" * 70)
    
    headers = {"Authorization": f"Bearer {token}"}
    response = requests.get(f"{BASE_URL}/api/stocks/reorder-suggestions", headers=headers)
    
    print(f"Status: {response.status_code}")
    
    if response.status_code == 200:
        print(f"✓ Reorder suggestions OK")
        data = response.json()
        print(f"  Sugerencias: {len(data)}")
    else:
        print(f"✗ Error: {response.text}")

def test_decode_token(token):
    """Test 5: Decodificar token para ver su contenido"""
    print("\n" + "=" * 70)
    print("TEST 5: DECODIFICAR TOKEN (sin verificar firma)")
    print("=" * 70)
    
    import jwt
    try:
        # Decodificar sin verificar (solo para debug)
        payload = jwt.decode(token, options={"verify_signature": False})
        print(f"✓ Token decodificado:")
        print(f"  - sub (user_id): {payload.get('sub')}")
        print(f"  - org_id: {payload.get('org_id')}")
        print(f"  - exp (expiration): {payload.get('exp')}")
        print(f"  - type: {payload.get('type', 'access')}")
        
        # Verificar expiración
        import time
        if payload.get('exp'):
            now = time.time()
            if now > payload['exp']:
                print(f"  ⚠️ TOKEN EXPIRADO (exp: {payload['exp']}, now: {now})")
            else:
                remaining = payload['exp'] - now
                print(f"  ✓ Token válido por {remaining/60:.1f} minutos más")
    except Exception as e:
        print(f"✗ Error decodificando: {e}")

def main():
    print("\n🔍 DIAGNÓSTICO DE AUTENTICACIÓN\n")
    
    # Test 1: Login
    token = test_login()
    if not token:
        print("\n⛔ No se pudo obtener token. Abortando tests.")
        return
    
    # Test 5: Decodificar token
    test_decode_token(token)
    
    # Test 2: Subscription
    test_subscription(token)
    
    # Test 3: Stocks low
    test_stocks_low(token)
    
    # Test 4: Reorder suggestions
    test_stocks_reorder(token)
    
    print("\n" + "=" * 70)
    print("DIAGNÓSTICO COMPLETADO")
    print("=" * 70)

if __name__ == "__main__":
    main()
