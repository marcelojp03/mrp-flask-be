#!/usr/bin/env python3
"""
Test para verificar que la IA prioriza nombres sobre IDs
"""
import requests
import json

BASE_URL = "http://localhost:4646"

def test_readable_columns():
    print("=" * 70)
    print("📋 TEST DE COLUMNAS LEGIBLES (nombres sobre IDs)")
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
    
    # Queries que deberían priorizar nombres
    test_cases = [
        {
            "query": "lista de productos",
            "should_have": ["name", "code"],
            "should_not_have": ["org_id", "category_id", "subcategory_id"]
        },
        {
            "query": "muéstrame los almacenes",
            "should_have": ["name"],
            "should_not_have": ["org_id"]
        },
        {
            "query": "productos con su categoría",
            "should_have": ["product", "category", "name"],
            "should_not_have": []
        },
        {
            "query": "proveedores activos",
            "should_have": ["name"],
            "should_not_have": ["org_id"]
        },
    ]
    
    for i, test in enumerate(test_cases, 1):
        print("\n" + "=" * 70)
        print(f"Test {i}: {test['query']}")
        print("-" * 70)
        
        response = requests.post(
            f"{BASE_URL}/api/reports/nl",
            headers=headers,
            json={
                "query": test['query'],
                "format": "json",
                "limit": 3
            }
        )
        
        if response.status_code == 200:
            data = response.json()['data']
            sql = data['sql'].lower()
            columns = [col.lower() for col in data['columns']]
            
            print(f"✅ Status: 200")
            print(f"📊 SQL generado:")
            print(f"   {data['sql']}")
            print(f"\n📋 Columnas retornadas: {', '.join(data['columns'])}")
            
            # Verificar columnas que DEBE tener
            has_good = [col for col in test['should_have'] if any(col in c for c in columns)]
            if has_good:
                print(f"✅ Incluye columnas legibles: {', '.join(has_good)}")
            
            # Verificar columnas que NO debe tener (IDs innecesarios)
            has_bad = [col for col in test['should_not_have'] if any(col in c for c in columns)]
            if has_bad:
                print(f"⚠️  Incluye IDs innecesarios: {', '.join(has_bad)}")
            else:
                print(f"✅ No incluye IDs innecesarios")
            
            # Mostrar primera fila de ejemplo
            if data['rows']:
                print(f"\n📄 Ejemplo de datos:")
                first_row = data['rows'][0]
                # Convertir row a lista si es necesario
                row_values = list(first_row) if hasattr(first_row, '__iter__') and not isinstance(first_row, str) else first_row
                for idx, col in enumerate(data['columns'][:5]):
                    val = row_values[idx] if idx < len(row_values) else 'N/A'
                    print(f"   - {col}: {val}")
        else:
            error_msg = response.json().get('message', 'Sin mensaje')
            print(f"❌ Error {response.status_code}")
            print(f"   {error_msg[:150]}")
    
    print("\n" + "=" * 70)
    print("✅ TEST COMPLETADO")
    print("=" * 70)

if __name__ == '__main__':
    test_readable_columns()
