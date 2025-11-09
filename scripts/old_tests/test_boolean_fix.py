#!/usr/bin/env python3
"""
Test específico para validar que la IA entiende tipos de datos BOOLEAN
"""
import requests
import json

BASE_URL = "http://localhost:4646"

def test_boolean_queries():
    print("=" * 70)
    print("🔍 TEST DE CONSULTAS CON BOOLEAN")
    print("=" * 70)
    
    # Login
    print("\n🔐 Login...")
    response = requests.post(f"{BASE_URL}/api/auth/login", json={
        "email": "marcelojp03@gmail.com",
        "password": "mrp123"
    })
    
    if response.status_code == 200:
        token = response.json()['data']['access_token']
        print("✅ Token obtenido\n")
    else:
        print(f"❌ Login falló: {response.status_code}")
        return
    
    headers = {
        'Authorization': f'Bearer {token}',
        'Content-Type': 'application/json'
    }
    
    # Queries que involucran campos booleanos
    boolean_queries = [
        "lista de productos activos",
        "muéstrame productos inactivos",
        "productos con is_active = true",
        "cuántos productos están activos",
    ]
    
    for i, query in enumerate(boolean_queries, 1):
        print("\n" + "=" * 70)
        print(f"Test {i}: {query}")
        print("-" * 70)
        
        response = requests.post(
            f"{BASE_URL}/api/reports/nl",
            headers=headers,
            json={
                "query": query,
                "format": "json",
                "limit": 5
            }
        )
        
        if response.status_code == 200:
            data = response.json()['data']
            print(f"✅ Status: 200")
            print(f"📊 SQL generado:")
            print(f"   {data['sql']}")
            print(f"📈 Filas: {data['summary']['total_rows']}")
            print(f"💬 Interpretación: {data['interpretation'][:80]}...")
        else:
            error_msg = response.json().get('message', 'Sin mensaje')
            print(f"❌ Error {response.status_code}")
            print(f"   {error_msg[:150]}")
    
    print("\n" + "=" * 70)
    print("✅ TEST COMPLETADO")
    print("=" * 70)

if __name__ == '__main__':
    test_boolean_queries()
