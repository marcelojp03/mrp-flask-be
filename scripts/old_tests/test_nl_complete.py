#!/usr/bin/env python3
"""
Test completo del endpoint /api/reports/nl con diferentes tipos de queries
"""
import requests
import json

BASE_URL = "http://localhost:4646"

def test_nl_queries():
    print("=" * 70)
    print("🤖 TEST COMPLETO DE REPORTES CON IA")
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
    
    # Diferentes queries para probar
    queries = [
        {
            "title": "Conteo simple",
            "query": "¿cuántos productos tengo?",
            "format": "json"
        },
        {
            "title": "Lista con detalles",
            "query": "muéstrame los nombres de todos los productos activos",
            "format": "json"
        },
        {
            "title": "Agregación",
            "query": "¿cuántos productos hay por tipo de item?",
            "format": "json"
        },
        {
            "title": "Stock bajo",
            "query": "qué productos tienen stock menor al mínimo",
            "format": "json"
        },
        {
            "title": "Work Orders",
            "query": "lista las órdenes de producción activas",
            "format": "json"
        }
    ]
    
    for i, query_data in enumerate(queries, 1):
        print("\n" + "=" * 70)
        print(f"\n{i}️⃣  {query_data['title']}")
        print("-" * 70)
        print(f"❓ Query: \"{query_data['query']}\"")
        
        response = requests.post(
            f"{BASE_URL}/api/reports/nl",
            headers=headers,
            json={
                "query": query_data['query'],
                "format": query_data['format'],
                "dry_run": False,
                "limit": 10
            }
        )
        
        if response.status_code == 200:
            data = response.json()['data']
            
            print(f"\n🔍 SQL Generado:")
            print(f"   {data['sql']}")
            
            print(f"\n📊 Resultados ({data['summary']['total_rows']} filas):")
            if data['rows']:
                # Mostrar solo primeras 3 filas
                for row in data['rows'][:3]:
                    print(f"   {row}")
                if len(data['rows']) > 3:
                    print(f"   ... y {len(data['rows']) - 3} más")
            else:
                print("   (sin resultados)")
            
            print(f"\n💬 Interpretación:")
            interpretation = data.get('interpretation', 'No disponible')
            for line in interpretation.split('. '):
                if line.strip():
                    print(f"   • {line.strip()}.")
            
            print(f"\n⏱️  Tiempo: {data['summary']['execution_time_ms']:.0f} ms")
        else:
            print(f"\n❌ Error {response.status_code}:")
            print(f"   {response.json().get('message', 'Error desconocido')}")
    
    print("\n" + "=" * 70)
    print("✅ PRUEBAS COMPLETADAS")
    print("=" * 70)

if __name__ == '__main__':
    test_nl_queries()
