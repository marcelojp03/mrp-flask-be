#!/usr/bin/env python3
"""
Script para probar el endpoint de login
"""
import requests
import json

BASE_URL = "http://localhost:4646"

print("\n" + "="*60)
print("🧪 PRUEBA DE ENDPOINT DE LOGIN")
print("="*60 + "\n")

# Test 1: Login con usuario de prueba
print("Test 1: Login con usuario de prueba")
print("="*40)

login_data = {
    "email": "test@test.com",
    "password": "123456"
}

print(f"📤 Request:")
print(f"   URL: {BASE_URL}/api/auth/login")
print(f"   Method: POST")
print(f"   Body: {json.dumps(login_data, indent=2)}\n")

try:
    response = requests.post(
        f"{BASE_URL}/api/auth/login",
        json=login_data,
        timeout=10
    )
    
    print(f"📥 Response:")
    print(f"   Status Code: {response.status_code}")
    print(f"   Headers: {dict(response.headers)}\n")
    
    try:
        response_data = response.json()
        print(f"   Body:")
        print(json.dumps(response_data, indent=2))
    except:
        print(f"   Body (raw): {response.text}")
    
    print()
    
    if response.status_code == 200:
        print("✅ LOGIN EXITOSO")
        if 'data' in response_data and 'token' in response_data['data']:
            token = response_data['data']['token']
            print(f"   Token: {token[:50]}...")
            
            # Test 2: Probar endpoint protegido con el token
            print("\n" + "="*60)
            print("Test 2: Endpoint protegido (GET /api/users)")
            print("="*40 + "\n")
            
            headers = {
                "Authorization": f"Bearer {token}"
            }
            
            print(f"📤 Request:")
            print(f"   URL: {BASE_URL}/api/users")
            print(f"   Method: GET")
            print(f"   Headers: Authorization: Bearer {token[:30]}...\n")
            
            protected_response = requests.get(
                f"{BASE_URL}/api/users",
                headers=headers,
                timeout=10
            )
            
            print(f"📥 Response:")
            print(f"   Status Code: {protected_response.status_code}")
            
            try:
                protected_data = protected_response.json()
                print(f"   Body:")
                print(json.dumps(protected_data, indent=2))
            except:
                print(f"   Body (raw): {protected_response.text}")
            
            print()
            
            if protected_response.status_code == 200:
                print("✅ ENDPOINT PROTEGIDO FUNCIONA")
            else:
                print("❌ ERROR EN ENDPOINT PROTEGIDO")
    else:
        print("❌ LOGIN FALLÓ")
        
except requests.exceptions.ConnectionError:
    print("❌ ERROR: No se puede conectar al servidor")
    print("   ¿Está corriendo Flask en el puerto 4646?")
    print("   Inicia el servidor con: python run.py")
    
except requests.exceptions.Timeout:
    print("❌ ERROR: Timeout - El servidor no responde")
    
except Exception as e:
    print(f"❌ ERROR INESPERADO: {e}")

print("\n" + "="*60)

# Test 3: Login con credenciales incorrectas
print("\nTest 3: Login con credenciales incorrectas")
print("="*40 + "\n")

wrong_data = {
    "email": "test@test.com",
    "password": "wrong_password"
}

print(f"📤 Request:")
print(f"   Body: {json.dumps(wrong_data, indent=2)}\n")

try:
    response = requests.post(
        f"{BASE_URL}/api/auth/login",
        json=wrong_data,
        timeout=10
    )
    
    print(f"📥 Response:")
    print(f"   Status Code: {response.status_code}")
    
    try:
        response_data = response.json()
        print(f"   Body:")
        print(json.dumps(response_data, indent=2))
    except:
        print(f"   Body (raw): {response.text}")
    
    print()
    
    if response.status_code == 401:
        print("✅ VALIDACIÓN CORRECTA (Rechaza credenciales inválidas)")
    else:
        print("⚠️  Respuesta inesperada")
        
except Exception as e:
    print(f"❌ ERROR: {e}")

print("\n" + "="*60)

# Test 4: Login con usuario que no existe
print("\nTest 4: Login con usuario inexistente")
print("="*40 + "\n")

nonexistent_data = {
    "email": "noexiste@test.com",
    "password": "123456"
}

print(f"📤 Request:")
print(f"   Body: {json.dumps(nonexistent_data, indent=2)}\n")

try:
    response = requests.post(
        f"{BASE_URL}/api/auth/login",
        json=wrong_data,
        timeout=10
    )
    
    print(f"📥 Response:")
    print(f"   Status Code: {response.status_code}")
    
    try:
        response_data = response.json()
        print(f"   Body:")
        print(json.dumps(response_data, indent=2))
    except:
        print(f"   Body (raw): {response.text}")
    
    print()
    
    if response.status_code == 401:
        print("✅ VALIDACIÓN CORRECTA (Rechaza usuario inexistente)")
    else:
        print("⚠️  Respuesta inesperada")
        
except Exception as e:
    print(f"❌ ERROR: {e}")

print("\n" + "="*60)
print("PRUEBAS COMPLETADAS")
print("="*60 + "\n")
