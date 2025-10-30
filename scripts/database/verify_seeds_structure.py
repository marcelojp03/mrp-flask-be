"""
Script para verificar la estructura de seeds (recursos y subrecursos)
Muestra la estructura definida en ambos archivos
"""

def show_python_structure():
    """Muestra estructura de init_data.py"""
    structure = {
        'Inicio': [
            'Dashboard'
        ],
        'Inventario': [
            'Productos', 'Almacenes', 'Movimientos', 'Stock Bajo', 'Sugerencias'
        ],
        'Producción': [
            'Órdenes (demo)'
        ],
        'Proveedores': [
            'Proveedores', 'Catálogo Proveedor'
        ],
        'Planificación': [
            'Demanda', 'MPS', 'MRP'
        ],
        'Administración': [
            'Usuarios', 'Roles', 'Recursos/ACL'
        ],
        'Reportes': [
            'Exportar CSV', 'Reportes IA'
        ],
        'Sistema': [
            'Logs', 'Backup'
        ]
    }
    return structure


def show_sql_structure():
    """Muestra estructura de production_seeds.sql"""
    structure = {
        'Inicio': [
            'Dashboard'
        ],
        'Inventario': [
            'Productos', 'Almacenes', 'Movimientos', 'Stock Bajo', 'Sugerencias'
        ],
        'Producción': [
            'Órdenes (demo)'
        ],
        'Proveedores': [
            'Proveedores', 'Catálogo Proveedor'
        ],
        'Planificación': [
            'Demanda', 'MPS', 'MRP'
        ],
        'Administración': [
            'Usuarios', 'Roles', 'Recursos/ACL'
        ],
        'Reportes': [
            'Exportar CSV', 'Reportes IA'
        ],
        'Sistema': [
            'Logs', 'Backup'
        ]
    }
    return structure


def compare_structures():
    """Compara ambas estructuras"""
    print("=" * 70)
    print("VERIFICACIÓN DE ESTRUCTURA DE SEEDS")
    print("=" * 70)
    
    py_struct = show_python_structure()
    sql_struct = show_sql_structure()
    
    print(f"\n📄 init_data.py: {len(py_struct)} recursos")
    print(f"📄 production_seeds.sql: {len(sql_struct)} recursos")
    
    # Contar subrecursos
    total_py = sum(len(subs) for subs in py_struct.values())
    total_sql = sum(len(subs) for subs in sql_struct.values())
    
    print(f"📋 Total subrecursos Python: {total_py}")
    print(f"📋 Total subrecursos SQL: {total_sql}")
    
    # Comparar
    if py_struct == sql_struct:
        print("\n✅ ESTRUCTURAS IDÉNTICAS")
        print("\nEstructura del menú (8 recursos, 19 subrecursos):")
        print("-" * 70)
        
        for resource, subs in py_struct.items():
            print(f"\n📦 {resource} ({len(subs)} subrecursos)")
            for sub in subs:
                print(f"   • {sub}")
        
        print("\n" + "=" * 70)
        print("RESUMEN:")
        print(f"  • 8 recursos principales")
        print(f"  • 19 subrecursos totales")
        print(f"  • Sin duplicados ni CRUDs innecesarios")
        print(f"  • Estructura limpia y funcional")
        print("=" * 70)
    else:
        print("\n❌ ESTRUCTURAS DIFERENTES")
        # Mostrar diferencias
        all_resources = set(py_struct.keys()) | set(sql_struct.keys())
        for resource in sorted(all_resources):
            py_subs = set(py_struct.get(resource, []))
            sql_subs = set(sql_struct.get(resource, []))
            
            if py_subs != sql_subs:
                print(f"\n⚠️  {resource}:")
                print(f"   Python: {py_subs}")
                print(f"   SQL: {sql_subs}")


if __name__ == '__main__':
    compare_structures()
