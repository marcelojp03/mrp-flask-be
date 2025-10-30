#!/usr/bin/env python3
"""
Simulación de cómo el FRONTEND debería llamar a los endpoints
"""
import requests
import json

BASE_URL = "http://localhost:4646"

print("=" * 70)
print("SIMULACIÓN FRONTEND - FLUJO COMPLETO")
print("=" * 70)

# PASO 1: Login (lo hace el usuario al entrar)
print("\n1️⃣ USUARIO HACE LOGIN")
print("-" * 70)
login_response = requests.post(f"{BASE_URL}/api/auth/login", json={
    "email": "marcelojp03@gmail.com",
    "password": "mrp123"
})

if login_response.status_code != 200:
    print(f"❌ Login falló: {login_response.text}")
    exit(1)

login_data = login_response.json()['data']
access_token = login_data['access_token']
print(f"✅ Login exitoso")
print(f"   Token guardado en localStorage/sessionStorage")
print(f"   Token: {access_token[:50]}...")

# PASO 2: Frontend intenta cargar subscription SIN token
print("\n\n2️⃣ FRONTEND INTENTA CARGAR SUBSCRIPTION (SIN TOKEN)")
print("-" * 70)
print("❌ ESTO ES LO QUE ESTÁ PASANDO ACTUALMENTE:")
response_sin_token = requests.get(f"{BASE_URL}/api/subscription")
print(f"   Status: {response_sin_token.status_code}")
print(f"   Error: {response_sin_token.json()}")

# PASO 3: Frontend carga subscription CON token
print("\n\n3️⃣ FRONTEND CARGA SUBSCRIPTION (CON TOKEN) ✅")
print("-" * 70)
print("ESTO ES LO QUE DEBERÍA HACER:")
headers = {"Authorization": f"Bearer {access_token}"}
response_con_token = requests.get(f"{BASE_URL}/api/subscription", headers=headers)
print(f"   Status: {response_con_token.status_code}")
if response_con_token.status_code == 200:
    data = response_con_token.json()
    print(f"   ✅ Datos recibidos correctamente")
    print(f"   Plan: {data.get('plan', {}).get('name', 'N/A')}")
else:
    print(f"   Error: {response_con_token.text}")

# PASO 4: Frontend carga reorder suggestions SIN token
print("\n\n4️⃣ FRONTEND INTENTA CARGAR REORDER SUGGESTIONS (SIN TOKEN)")
print("-" * 70)
print("❌ ESTO ES LO QUE ESTÁ PASANDO ACTUALMENTE:")
response_sin_token2 = requests.get(f"{BASE_URL}/api/stocks/reorder-suggestions")
print(f"   Status: {response_sin_token2.status_code}")
print(f"   Error: {response_sin_token2.json()}")

# PASO 5: Frontend carga reorder suggestions CON token
print("\n\n5️⃣ FRONTEND CARGA REORDER SUGGESTIONS (CON TOKEN) ✅")
print("-" * 70)
print("ESTO ES LO QUE DEBERÍA HACER:")
response_con_token2 = requests.get(f"{BASE_URL}/api/stocks/reorder-suggestions", headers=headers)
print(f"   Status: {response_con_token2.status_code}")
if response_con_token2.status_code == 200:
    data = response_con_token2.json()
    print(f"   ✅ Datos recibidos correctamente")
    print(f"   Sugerencias: {len(data)}")
else:
    print(f"   Error: {response_con_token2.text}")

# SOLUCIÓN
print("\n\n" + "=" * 70)
print("📋 SOLUCIÓN PARA EL FRONTEND")
print("=" * 70)
print("""
El frontend debe incluir el header de autorización en TODAS las peticiones
protegidas. Ejemplo en Angular/TypeScript:

// subscription.component.ts
loadSubscription() {
  const token = this.authService.getAccessToken(); // o localStorage.getItem('access_token')
  
  this.http.get('http://localhost:4646/api/subscription', {
    headers: {
      'Authorization': `Bearer ${token}`
    }
  }).subscribe({
    next: (data) => console.log('Subscription:', data),
    error: (err) => console.error('Error:', err)
  });
}

// reorder-suggestions.component.ts
loadSuggestions() {
  const token = this.authService.getAccessToken();
  
  this.http.get('http://localhost:4646/api/stocks/reorder-suggestions', {
    headers: {
      'Authorization': `Bearer ${token}`
    }
  }).subscribe({
    next: (data) => console.log('Suggestions:', data),
    error: (err) => console.error('Error:', err)
  });
}

// MEJOR: Usar un interceptor HTTP para agregar el token automáticamente
// a todas las peticiones (ver auth.interceptor.ts en Angular)
""")
