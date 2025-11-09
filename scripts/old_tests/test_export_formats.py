#!/usr/bin/env python3
"""
Test de exportación en múltiples formatos (JSON, CSV, Excel, PDF)
"""
import requests
import json

BASE_URL = "http://localhost:4646"

def test_export_formats():
    print("=" * 70)
    print("📤 TEST DE EXPORTACIÓN EN MÚLTIPLES FORMATOS")
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
    
    query = "lista de 10 productos con su stock actual y mínimo"
    
    # Test 1: JSON (con interpretación)
    print("\n" + "=" * 70)
    print("1️⃣  Formato: JSON (con interpretación en lenguaje natural)")
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
        print(f"📊 Filas: {data['summary']['total_rows']}")
        print(f"💬 Interpretación: {data['interpretation'][:100]}...")
        print(f"📦 Opciones de exportación: {', '.join(data['export_options'])}")
    else:
        print(f"❌ Error: {response.status_code}")
        print(response.text[:200])
    
    # Test 2: CSV
    print("\n" + "=" * 70)
    print("2️⃣  Formato: CSV")
    print("-" * 70)
    
    response = requests.post(
        f"{BASE_URL}/api/reports/nl",
        headers=headers,
        json={
            "query": query,
            "format": "csv",
            "limit": 5
        }
    )
    
    if response.status_code == 200:
        csv_content = response.text
        print(f"✅ Status: 200")
        print(f"📄 Content-Type: {response.headers.get('Content-Type')}")
        print(f"💾 Content-Disposition: {response.headers.get('Content-Disposition')}")
        print(f"\n📋 Primeras líneas del CSV:")
        print('\n'.join(csv_content.split('\n')[:5]))
        
        # Guardar archivo
        with open('report_test.csv', 'w', encoding='utf-8') as f:
            f.write(csv_content)
        print(f"\n💾 Archivo guardado: report_test.csv")
    else:
        print(f"❌ Error: {response.status_code}")
        print(response.text[:200])
    
    # Test 3: Excel
    print("\n" + "=" * 70)
    print("3️⃣  Formato: Excel (.xlsx)")
    print("-" * 70)
    
    response = requests.post(
        f"{BASE_URL}/api/reports/nl",
        headers=headers,
        json={
            "query": query,
            "format": "excel",
            "limit": 10
        }
    )
    
    if response.status_code == 200:
        print(f"✅ Status: 200")
        print(f"📄 Content-Type: {response.headers.get('Content-Type')}")
        print(f"💾 Content-Disposition: {response.headers.get('Content-Disposition')}")
        print(f"📦 Tamaño: {len(response.content)} bytes")
        
        # Guardar archivo
        with open('report_test.xlsx', 'wb') as f:
            f.write(response.content)
        print(f"💾 Archivo guardado: report_test.xlsx")
    else:
        print(f"❌ Error: {response.status_code}")
        print(response.text[:200])
    
    # Test 4: PDF
    print("\n" + "=" * 70)
    print("4️⃣  Formato: PDF")
    print("-" * 70)
    
    response = requests.post(
        f"{BASE_URL}/api/reports/nl",
        headers=headers,
        json={
            "query": query,
            "format": "pdf",
            "limit": 10
        }
    )
    
    if response.status_code == 200:
        print(f"✅ Status: 200")
        print(f"📄 Content-Type: {response.headers.get('Content-Type')}")
        print(f"💾 Content-Disposition: {response.headers.get('Content-Disposition')}")
        print(f"📦 Tamaño: {len(response.content)} bytes")
        
        # Guardar archivo
        with open('report_test.pdf', 'wb') as f:
            f.write(response.content)
        print(f"💾 Archivo guardado: report_test.pdf")
    else:
        print(f"❌ Error: {response.status_code}")
        print(response.text[:200])
    
    print("\n" + "=" * 70)
    print("✅ PRUEBAS COMPLETADAS")
    print("\n📁 Archivos generados:")
    print("   • report_test.csv   - Formato CSV")
    print("   • report_test.xlsx  - Formato Excel")
    print("   • report_test.pdf   - Formato PDF")
    print("=" * 70)

if __name__ == '__main__':
    test_export_formats()
