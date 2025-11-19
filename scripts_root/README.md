# Scripts Root - Archivos de Utilidad

Este directorio contiene scripts de utilidad, migraciones manuales y archivos de prueba que estaban en la raíz del proyecto.

## Contenido

### Migraciones Manuales
- `apply_migration_019.py` - Aplicar migración de tabla Alert
- `apply_migration_020.py` - Aplicar migración de tabla Forecast
- `apply_sprint4_migrations.py` - Aplicar migraciones de Sprint 4
- `apply_sprint4_migrations.sql` - SQL de migraciones Sprint 4

### Scripts de Verificación
- `check_routes.py` - Verificar rutas registradas en Flask
- `check_subscription.py` - Verificar suscripciones de organizaciones

### Scripts de Actualización
- `update_plan.py` - Actualizar planes de suscripción
- `update_plan_limits.py` - Actualizar límites de planes
- `fix_responses.py` - Arreglar respuestas de endpoints

### Tests
- `test_sprint4_sprint5.py` - Suite de tests para Sprint 4 y 5 (39 endpoints)
- `test_sprint4_load.py` - Test de carga de datos Sprint 4

### Datos
- `login.json` - Credenciales de prueba
- `mrpAWS.sql` - Dump completo de base de datos AWS

## Uso

Estos scripts son herramientas de desarrollo y no forman parte del código de producción. Se pueden ejecutar directamente desde este directorio:

```bash
# Ejemplo: Aplicar migración
python scripts_root/apply_migration_019.py

# Ejemplo: Ejecutar tests
python scripts_root/test_sprint4_sprint5.py
```

## Nota

Para scripts de producción y deployment, ver:
- `scripts/database/` - Scripts de base de datos
- `scripts/deploy/` - Scripts de deployment
- `scripts/setup/` - Scripts de configuración inicial
