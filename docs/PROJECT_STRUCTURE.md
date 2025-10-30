# 📁 Estructura del Proyecto MRP Flask Backend

## 🗂️ Organización de Carpetas

```
mrp_flask_be/
├── 📁 app/                      # Aplicación principal
│   ├── config.py                # Configuración (DB, JWT, AWS, etc)
│   ├── db.py                    # Instancia de SQLAlchemy
│   ├── responses.py             # Respuestas estandarizadas
│   ├── utils.py                 # Utilidades generales
│   │
│   ├── 📁 controllers/          # Controladores (endpoints)
│   │   ├── auth_controller.py       # Login, refresh
│   │   ├── dashboard_controller.py  # KPIs, alertas
│   │   ├── bom_controller.py        # Lista de materiales (S3)
│   │   ├── work_order_controller.py # Órdenes de producción (S3)
│   │   └── ...                      # 30+ controladores
│   │
│   ├── 📁 models/               # Modelos SQLAlchemy
│   │   ├── user.py                  # Usuario
│   │   ├── organization.py          # Organización
│   │   ├── product.py               # Producto
│   │   ├── bom.py                   # BOM (S3)
│   │   ├── work_order.py            # Work Order (S3)
│   │   └── ...                      # 30+ modelos
│   │
│   ├── 📁 services/             # Lógica de negocio
│   │   ├── auth_service.py          # Autenticación JWT
│   │   ├── stock_service.py         # Gestión de stocks
│   │   └── ...                      # Servicios de dominio
│   │
│   └── 📁 entities/             # Entidades de dominio (DTOs)
│       ├── bom_entity.py
│       └── work_order_entity.py
│
├── 📁 auth/                     # Sistema de autenticación
│   └── decorators.py            # @auth_required, validación JWT
│
├── 📁 migrations/               # Migraciones de base de datos
│   ├── 001_create_users.sql    # S1: Usuarios, roles, ACL
│   ├── 008_create_products.sql # S1: Productos, almacenes
│   ├── 013_create_boms.sql     # S3: BOMs
│   ├── 014_create_work_orders.sql # S3: Órdenes producción
│   └── ...                      # 15 migraciones
│
├── 📁 seeds/                    # Datos iniciales
│   └── full_database_seeds.sql  # Seed completo S1+S2+S3
│
├── 📁 tests/                    # ⭐ Tests
│   └── integration/             # Tests de integración (endpoints)
│       ├── test_auth_debug.py
│       ├── test_fixed_endpoints.py
│       ├── test_subscription_endpoint.py
│       ├── test_stocks_and_kpis.py
│       ├── test_db_connection.py
│       └── ...
│
├── 📁 scripts/                  # ⭐ Scripts de utilidad
│   ├── database/                # Scripts de base de datos
│   │   ├── populate_database.py        # Población inicial
│   │   ├── create_boms_direct.py       # Crear BOMs
│   │   ├── fix_users_org.py            # Asignar orgs a usuarios
│   │   └── ...
│   │
│   ├── setup/                   # Scripts de configuración inicial
│   │   ├── create_test_user.py
│   │   └── ...
│   │
│   ├── deploy/                  # Scripts de deployment
│   │   ├── deploy-ecr.ps1
│   │   └── ...
│   │
│   └── testing/                 # Scripts de testing PowerShell
│       ├── test-all-endpoints.ps1
│       └── ...
│
├── 📁 docs/                     # ⭐ Documentación
│   ├── ENDPOINTS_COMPLETE_LIST.md      # Referencia completa de API
│   ├── PROJECT_STRUCTURE.md            # Este archivo
│   └── guides/                  # Guías y tutoriales
│       ├── FRONTEND_DASHBOARD_GUIDE.md
│       ├── CAMBIOS_SPRINT3.md
│       └── instrucciones.txt
│
├── 📄 run.py                    # Punto de entrada de la aplicación
├── 📄 requirements.txt          # Dependencias Python
├── 📄 README.md                 # Documentación principal
├── 📄 Dockerfile                # Imagen Docker
├── 📄 docker-compose.yml        # Orquestación Docker
├── 📄 .env                      # Variables de entorno (local)
├── 📄 .env.development          # Environment desarrollo
├── 📄 .env.production           # Environment producción
└── 📄 .gitignore                # Archivos ignorados por git
```

---

## 📚 Guía de Uso

### 🧪 Ejecutar Tests

```bash
# Tests de integración
python tests/integration/test_fixed_endpoints.py
python tests/integration/test_subscription_endpoint.py
python tests/integration/test_stocks_and_kpis.py

# Tests PowerShell (requiere servidor corriendo)
.\scripts\testing\test-all-endpoints.ps1
.\scripts\testing\test-sprint2-dashboard.ps1
```

### 🗄️ Base de Datos

```bash
# Poblar base de datos inicial
python scripts/database/populate_database.py

# Poblar datos Sprint 3 (BOMs, Work Orders)
python scripts/database/create_boms_direct.py

# Verificar integridad de datos
python scripts/database/verify_structure.py

# Asignar organizaciones a usuarios
python scripts/database/fix_users_org.py
```

### 👤 Setup Inicial

```bash
# Crear usuario de prueba
python scripts/setup/create_test_user.py

# Verificar roles
python scripts/setup/check_user_roles.py

# Test de login
python scripts/setup/test_login.py
```

### 🚀 Deployment

```bash
# Cambiar a ambiente de desarrollo
.\scripts\deploy\use-dev.bat

# Cambiar a producción
.\scripts\deploy\use-prod.bat

# Deploy a AWS ECR
.\scripts\deploy\deploy-ecr.ps1
```

---

## 📖 Documentación

| Archivo | Descripción |
|---------|-------------|
| `docs/ENDPOINTS_COMPLETE_LIST.md` | **Referencia completa de API** - Todos los endpoints con request/response |
| `docs/guides/FRONTEND_DASHBOARD_GUIDE.md` | **Guía para Frontend** - Cómo consumir endpoints de dashboard/stocks |
| `docs/guides/CAMBIOS_SPRINT3.md` | **Log de Cambios S3** - Resumen de implementación de Producción |
| `README.md` | **Documentación Principal** - Setup, instalación, inicio rápido |

---

## 🔧 Archivos de Configuración

| Archivo | Propósito |
|---------|-----------|
| `.env` | Variables de entorno locales (no commitear) |
| `.env.development` | Configuración para desarrollo |
| `.env.production` | Configuración para producción |
| `requirements.txt` | Dependencias Python |
| `package.json` | Scripts npm (si se usan) |
| `Dockerfile` | Imagen Docker del backend |
| `docker-compose.yml` | Orquestación (app + postgres) |

---

## 🏗️ Arquitectura

### Capas de la Aplicación

```
┌─────────────────────────────────────────┐
│         Controllers (HTTP Layer)         │  ← Endpoints REST
├─────────────────────────────────────────┤
│         Services (Business Logic)        │  ← Lógica de negocio
├─────────────────────────────────────────┤
│         Models (Data Layer)              │  ← Modelos SQLAlchemy
├─────────────────────────────────────────┤
│         Database (PostgreSQL)            │  ← Persistencia
└─────────────────────────────────────────┘
```

### Flujo de una Request

```
1. Cliente → Controller (endpoint)
2. Controller → Auth Decorator (@auth_required)
3. Auth → Verifica JWT, establece g.org_id
4. Controller → Service (lógica de negocio)
5. Service → Model (consulta DB)
6. Model → Database (SQL)
7. Database → Model → Service → Controller
8. Controller → Response (JSON estandarizado)
```

---

## 🎯 Sprints Implementados

### Sprint 1 - Core MRP (20 blueprints)
- ✅ Autenticación (JWT)
- ✅ Usuarios, Roles, Organizaciones
- ✅ ACL (Recursos, Subrecursos, Permisos)
- ✅ Productos, Almacenes, Movimientos
- ✅ Proveedores, Stocks
- ✅ Dashboard básico

### Sprint 2 - SaaS Multi-Tenant (8 blueprints)
- ✅ Signup público
- ✅ Planes SaaS (Free, Starter, Pro)
- ✅ Menú dinámico (ACL)
- ✅ Reportes CSV + IA
- ✅ Backup completo
- ✅ Logs del sistema

### Sprint 3 - Producción (2 blueprints)
- ✅ BOMs (Lista de Materiales)
- ✅ Work Orders (Órdenes de Producción)
- ✅ Trazabilidad de movimientos
- ✅ KPIs de producción

### Sprint 4 - Planificación (Pendiente)
- ⏳ MPS (Master Production Schedule)
- ⏳ MRP (Material Requirements Planning)
- ⏳ Propuestas de compra/producción

### Sprint 5 - Analytics (Pendiente)
- ⏳ Forecasting con IA
- ⏳ Dashboard analítico avanzado
- ⏳ Alertas inteligentes

---

## 🧹 Limpieza y Mantenimiento

### Archivos Eliminados

Los siguientes archivos obsoletos/duplicados fueron **eliminados**:
- ❌ Tests antiguos en raíz (movidos a `tests/integration/`)
- ❌ Scripts sueltos en raíz (movidos a `scripts/database/`)
- ❌ Documentación dispersa (consolidada en `docs/`)

### ¿Qué NO Eliminar?

⚠️ **Mantener siempre:**
- `run.py` - Punto de entrada
- `requirements.txt` - Dependencias
- `.env*` - Configuraciones de ambiente
- `Dockerfile`, `docker-compose.yml` - Docker
- `README.md` - Documentación principal
- `migrations/` - Historial de cambios de BD
- `seeds/` - Datos iniciales

---

## 📞 Contacto y Contribución

- **Repositorio:** marcelojp03/mrp-flask-be
- **Branch:** dev
- **Última actualización:** Sprint 3 - Octubre 2025

### Convenciones de Commits

```
feat: Nueva funcionalidad
fix: Corrección de bug
docs: Cambios en documentación
refactor: Refactorización de código
test: Añadir o modificar tests
chore: Tareas de mantenimiento
```

---

**¿Necesitas ayuda?** Consulta la documentación en `docs/` o revisa los ejemplos en `tests/integration/`.
