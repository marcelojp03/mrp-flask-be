"""
Script para probar el endpoint de reportes de producción
GET /api/work-orders/reports/stats
"""
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from run import app
import json

# Simular una petición al endpoint
with app.test_client() as client:
    # Primero hacer login para obtener token
    print("\n" + "="*70)
    print("🔐 PASO 1: LOGIN PARA OBTENER TOKEN")
    print("="*70)
    
    login_response = client.post('/api/auth/login', 
        json={
            'email': 'marcelojp03@gmail.com',
            'password': 'mrp123'
        },
        content_type='application/json'
    )
    
    if login_response.status_code == 200:
        login_data = json.loads(login_response.data)
        token = login_data.get('data', {}).get('token')
        print(f"✅ Login exitoso")
        print(f"   Usuario: {login_data.get('data', {}).get('user', {}).get('name')}")
        print(f"   Email: {login_data.get('data', {}).get('user', {}).get('email')}")
        print(f"   Token: {token[:30]}...")
        
        # Ahora probar el endpoint de reportes
        print("\n" + "="*70)
        print("📊 PASO 2: OBTENER ESTADÍSTICAS DE PRODUCCIÓN")
        print("="*70)
        
        # Sin parámetros (últimos 30 días por defecto)
        stats_response = client.get('/api/work-orders/reports/stats',
            headers={'Authorization': f'Bearer {token}'}
        )
        
        print(f"\n📍 Endpoint: GET /api/work-orders/reports/stats")
        print(f"📍 Status: {stats_response.status_code}")
        
        if stats_response.status_code == 200:
            stats_data = json.loads(stats_response.data)
            
            print(f"\n✅ RESPUESTA EXITOSA\n")
            
            # Mostrar datos del período
            period = stats_data.get('data', {}).get('period', {})
            print(f"📅 PERÍODO:")
            print(f"   Desde: {period.get('from')}")
            print(f"   Hasta: {period.get('to')}")
            
            # Mostrar resumen
            summary = stats_data.get('data', {}).get('summary', {})
            print(f"\n📊 RESUMEN:")
            print(f"   Total Work Orders: {summary.get('total_work_orders')}")
            print(f"   Cantidad Planificada: {summary.get('total_quantity_planned')}")
            print(f"   Cantidad Terminada: {summary.get('total_quantity_finished')}")
            print(f"   Tasa de Completitud: {summary.get('completion_rate')}%")
            print(f"   Eficiencia: {summary.get('efficiency_rate')}%")
            print(f"   Tiempo Prom. Producción: {summary.get('avg_completion_time_hours')} hrs")
            
            # Mostrar por estado
            by_status = summary.get('by_status', {})
            print(f"\n📈 POR ESTADO:")
            print(f"   PLANIFICADAS: {by_status.get('PLANNED', 0)}")
            print(f"   EN PROGRESO: {by_status.get('IN_PROGRESS', 0)}")
            print(f"   FINALIZADAS: {by_status.get('FINISHED', 0)}")
            print(f"   CANCELADAS: {by_status.get('CANCELLED', 0)}")
            
            # Top BOMs
            top_boms = stats_data.get('data', {}).get('top_boms', [])
            print(f"\n🏆 TOP {len(top_boms)} BOMs MÁS UTILIZADAS:")
            for i, bom in enumerate(top_boms, 1):
                print(f"   {i}. {bom.get('product_name')} ({bom.get('product_code')})")
                print(f"      - Órdenes: {bom.get('work_orders_count')}")
                print(f"      - Cantidad Total: {bom.get('total_quantity')}")
            
            # Top Productos
            top_products = stats_data.get('data', {}).get('top_products', [])
            print(f"\n🥇 TOP {len(top_products)} PRODUCTOS MÁS PRODUCIDOS:")
            for i, prod in enumerate(top_products, 1):
                print(f"   {i}. {prod.get('product_name')} ({prod.get('product_code')})")
                print(f"      - Cantidad: {prod.get('total_quantity')} unidades")
                print(f"      - Órdenes: {prod.get('orders_count')}")
            
            # Tendencia mensual
            monthly = stats_data.get('data', {}).get('monthly_production', [])
            print(f"\n📅 TENDENCIA MENSUAL ({len(monthly)} meses):")
            for month_data in monthly:
                month = month_data.get('month')
                total = month_data.get('total')
                finished = month_data.get('finished')
                print(f"   {month}: {total} órdenes ({finished} finalizadas)")
            
            # Respuesta completa en JSON
            print("\n" + "="*70)
            print("📦 RESPUESTA COMPLETA (JSON):")
            print("="*70)
            print(json.dumps(stats_data, indent=2, ensure_ascii=False))
            
        else:
            print(f"\n❌ ERROR: {stats_response.status_code}")
            print(json.dumps(json.loads(stats_response.data), indent=2, ensure_ascii=False))
        
        # Probar con parámetros de fecha
        print("\n\n" + "="*70)
        print("📊 PASO 3: PROBAR CON PARÁMETROS DE FECHA")
        print("="*70)
        
        stats_response2 = client.get('/api/work-orders/reports/stats?from=2024-10-01&to=2024-12-31',
            headers={'Authorization': f'Bearer {token}'}
        )
        
        print(f"\n📍 Endpoint: GET /api/work-orders/reports/stats?from=2024-10-01&to=2024-12-31")
        print(f"📍 Status: {stats_response2.status_code}")
        
        if stats_response2.status_code == 200:
            stats_data2 = json.loads(stats_response2.data)
            period2 = stats_data2.get('data', {}).get('period', {})
            summary2 = stats_data2.get('data', {}).get('summary', {})
            
            print(f"\n✅ RESPUESTA EXITOSA")
            print(f"   Período: {period2.get('from')} a {period2.get('to')}")
            print(f"   Total Work Orders: {summary2.get('total_work_orders')}")
            print(f"   Tasa de Completitud: {summary2.get('completion_rate')}%")
        
    else:
        print(f"❌ Error en login: {login_response.status_code}")
        print(json.dumps(json.loads(login_response.data), indent=2, ensure_ascii=False))

print("\n" + "="*70)
print("✅ PRUEBA COMPLETADA")
print("="*70 + "\n")
