# MRP Backend - Información del Proyecto

## Stack Tecnológico

- **Framework**: Flask 3.x
- **ORM**: SQLAlchemy 2.x
- **Base de Datos**: PostgreSQL 14+
- **Autenticación**: JWT custom
- **Container**: Docker + AWS ECR
- **ML/Analytics**: NumPy, Pandas, Scikit-learn, Statsmodels

## Arquitectura

Sistema MRP (Material Requirements Planning) con arquitectura multi-tenant SaaS.

### Componentes Principales

- **Multi-Tenant**: Aislamiento de datos por organización
- **Role-Based Access Control**: Sistema de permisos granular
- **RESTful API**: Endpoints documentados
- **Analytics**: Sistema de pronósticos estadísticos
- **Alertas**: Notificaciones automáticas de stock bajo, retrasos, etc.

## Estructura del Proyecto

```
mrp_flask_be/
├── app/                    # Código fuente principal
│   ├── controllers/       # Endpoints REST (HTTP handlers)
│   ├── models/           # Modelos SQLAlchemy (DB schema)
│   ├── services/         # Lógica de negocio
│   ├── entities/         # DTOs y entidades
│   ├── config.py         # Configuración de la app
│   ├── db.py             # Database setup
│   ├── responses.py      # Respuestas HTTP estandarizadas
│   └── utils.py          # Utilidades comunes
├── auth/                 # Sistema de autenticación
│   ├── decorators.py     # Decoradores JWT
│   └── jwt_handler.py    # Manejo de tokens
├── migrations/           # SQL migrations (DDL)
├── seeds/               # Datos iniciales
├── scripts/             # Scripts de utilidad
│   ├── database/       # Scripts de BD
│   ├── setup/          # Setup inicial
│   ├── deploy/         # Deployment
│   └── test/           # Tests de endpoints
├── tests/              # Tests automatizados
│   └── integration/    # Tests de integración
├── docs/               # Documentación técnica
├── env/                # Virtual environment (no versionado)
├── logs/               # Logs de aplicación (no versionado)
├── run.py             # Punto de entrada
├── requirements.txt   # Dependencias Python
├── Dockerfile         # Container definition
└── docker-compose.yml # Multi-container orchestration
```

## Sprints Implementados

### Sprint 1 - Core MRP
- Sistema de usuarios y autenticación JWT
- Gestión de roles y permisos
- CRUD de productos y categorías
- Inventario multi-almacén
- Movimientos de inventario

### Sprint 2 - SaaS Multi-Tenant
- Sistema de registro de organizaciones
- Planes y suscripciones
- Menú dinámico basado en permisos
- Aislamiento de datos por org_id

### Sprint 3 - Producción
- Bill of Materials (BOMs)
- Órdenes de trabajo (Work Orders)
- Trazabilidad de producción
- Consumo de materiales
- Reportes de producción

### Sprint 4 - Planificación (En progreso)
- Gestión de demanda
- Master Production Schedule (MPS)
- Material Requirements Planning (MRP)
- Simulación de planes

### Sprint 5 - Analytics (En progreso)
- Sistema de alertas automáticas
- Pronósticos estadísticos (ML)
  - Moving Average
  - Weighted Average
  - Exponential Smoothing
  - Linear Regression
- Dashboard de KPIs
- Resumen de planificación

## Base de Datos

### Schema: `mrp`

Tablas principales:
- **organization**: Organizaciones (multi-tenant)
- **user**: Usuarios del sistema
- **role**: Roles de usuario
- **product**: Productos y materiales
- **warehouse**: Almacenes
- **product_warehouse**: Relación producto-almacén (stock)
- **movement**: Movimientos de inventario
- **bom**: Bill of Materials
- **work_order**: Órdenes de trabajo
- **demand**: Demanda de productos
- **mps**: Master Production Schedule
- **mrp_proposal**: Propuestas MRP
- **forecast**: Pronósticos de demanda
- **alert**: Alertas del sistema

Ver scripts de migración en `migrations/`

## API Endpoints

Documentación completa en: [`ENDPOINTS_COMPLETE_LIST.md`](ENDPOINTS_COMPLETE_LIST.md)

### Módulos principales:
- `/api/auth` - Autenticación
- `/api/user` - Usuarios
- `/api/org` - Organizaciones
- `/api/product` - Productos
- `/api/warehouse` - Almacenes
- `/api/movement` - Movimientos
- `/api/bom` - Bill of Materials
- `/api/wo` - Work Orders
- `/api/demand` - Demanda
- `/api/mps` - Master Production Schedule
- `/api/mrp` - MRP
- `/api/forecast` - Pronósticos
- `/api/alert` - Alertas
- `/api/dashboard` - Dashboards

## Testing

### Tests de Integración
```bash
python tests/integration/test_fixed_endpoints.py
```

### Tests de Sprint 4/5
```bash
python test_sprint4_sprint5.py
```

### Tests PowerShell
```powershell
.\scripts\test\test-all-endpoints.ps1
```

## Deployment

### Docker Local
```bash
docker-compose up -d
```

### AWS ECR
```bash
# Windows
.\scripts\deploy\deploy-ecr.ps1

# Linux/macOS
./scripts/deploy/deploy-ecr.sh
```

Ver guía completa: [`docs/DEPLOY_ECR_SUMMARY.md`](DEPLOY_ECR_SUMMARY.md)

## Variables de Entorno

Archivo `.env` requerido:

```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASS=yourpassword
DB_NAME=mrp

# JWT
JWT_SECRET_KEY=your-secret-key-here
JWT_EXPIRATION_HOURS=24

# Flask
FLASK_ENV=development
FLASK_DEBUG=True

# AWS (opcional)
AWS_REGION=us-east-1
ECR_REPOSITORY=mrp-backend
```

Ver `.env.example` para template completo.

## Contribución

Proyecto académico - UAGRM Sistemas de Información 2

### Equipo
- Desarrollo: Marcel JP
- Materia: Sistemas de Información 2
- Universidad: UAGRM
- Año: 2025

## Licencia

Proyecto académico - Todos los derechos reservados
