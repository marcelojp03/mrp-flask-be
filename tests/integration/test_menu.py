"""
Test menu endpoint and auth tokens
"""
import requests
import json

print("=" * 60)
print("TEST 1: LOGIN CON ACCESS_TOKEN Y REFRESH_TOKEN")
print("=" * 60)

# Login
login_response = requests.post(
    'http://localhost:4646/api/auth/login',
    json={'email': 'marcelojp03@gmail.com', 'password': 'mrp123'}
)
print("\nLogin response:", login_response.status_code)
login_data = login_response.json()

if login_response.status_code == 200:
    print("\n✓ Login exitoso")
    print(f"  - access_token: {'access_token' in login_data['data']}")
    print(f"  - refresh_token: {'refresh_token' in login_data['data']}")
    print(f"  - token (alias): {'token' in login_data['data']}")
    
    access_token = login_data['data'].get('access_token') or login_data['data'].get('token')
    refresh_token = login_data['data'].get('refresh_token')
    
    # Test menu con access_token
    print("\n" + "=" * 60)
    print("TEST 2: MENU CON ACCESS_TOKEN")
    print("=" * 60)
    
    menu_response = requests.get(
        'http://localhost:4646/api/menu',
        headers={'Authorization': f'Bearer {access_token}'}
    )
    print(f"\nMenu response: {menu_response.status_code}")
    menu_data = menu_response.json()
    
    if menu_data.get('success'):
        resources = menu_data['data']
        print(f"\n✓ Menú obtenido exitosamente")
        print(f"  Total recursos: {len(resources)}")
        total_subs = 0
        
        # Verificar que no hay duplicados
        all_sub_ids = []
        for resource in resources:
            subs = resource.get('subresources', [])
            total_subs += len(subs)
            for sub in subs:
                all_sub_ids.append(sub['id'])
        
        duplicates = len(all_sub_ids) - len(set(all_sub_ids))
        print(f"  Total subrecursos: {total_subs}")
        print(f"  Subrecursos duplicados: {duplicates}")
        
        if duplicates == 0:
            print("\n✓ No hay subrecursos duplicados")
        else:
            print("\n✗ HAY SUBRECURSOS DUPLICADOS")
            # Mostrar duplicados
            from collections import Counter
            counts = Counter(all_sub_ids)
            for sub_id, count in counts.items():
                if count > 1:
                    print(f"    - ID {sub_id} aparece {count} veces")
        
        # Mostrar recursos de Producción
        print("\n" + "-" * 60)
        print("RECURSOS DE PRODUCCIÓN:")
        print("-" * 60)
        for resource in resources:
            if 'producc' in resource['name'].lower():
                print(f"\n{resource['name']} (id={resource['id']})")
                for sub in resource.get('subresources', []):
                    print(f"  - {sub['name']} (id={sub['id']}) - {sub['url']}")
    
    # Test refresh token
    if refresh_token:
        print("\n" + "=" * 60)
        print("TEST 3: REFRESH TOKEN")
        print("=" * 60)
        
        refresh_response = requests.post(
            'http://localhost:4646/api/auth/refresh',
            json={'refresh_token': refresh_token}
        )
        print(f"\nRefresh response: {refresh_response.status_code}")
        
        if refresh_response.status_code == 200:
            refresh_data = refresh_response.json()
            print("\n✓ Token renovado exitosamente")
            print(f"  - Nuevo access_token: {'access_token' in refresh_data['data']}")
            print(f"  - Token (alias): {'token' in refresh_data['data']}")
        else:
            print(f"\n✗ Error al renovar token: {refresh_response.json()}")
else:
    print(f"\n✗ Error en login: {login_data}")

print("\n" + "=" * 60)
print("TESTS COMPLETADOS")
print("=" * 60)
