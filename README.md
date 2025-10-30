# 🏭 MRP Backend - Sistema de Planificación de Requerimientos de Materiales

Backend Flask para sistema MRP (Material Requirements Planning) con arquitectura multi-tenant SaaS.

## 🚀 Stack Tecnológico

- **Framework**: Flask 3.x
- **ORM**: SQLAlchemy 2.x
- **Base de Datos**: PostgreSQL 14+
- **Autenticación**: JWT (Flask-JWT-Extended)
- **AI Integration**: OpenAI GPT-4
- **Container**: Docker + AWS ECR

## 📋 Características

### Sprint 1 - Core MRP
- ✅ Autenticación JWT con multi-tenant (org_id)
- ✅ Gestión de Usuarios, Roles y Permisos (ACL)
- ✅ Inventario: Productos, Almacenes, Movimientos
- ✅ Control de Stock en tiempo real
- ✅ Gestión de Proveedores y Artículos de Proveedor
- ✅ Dashboard con métricas clave
- ✅ Menú dinámico basado en permisos

### Sprint 2 - SaaS Features
- ✅ Landing pública y registro multi-organización
- ✅ Auditoría automática de todas las operaciones
- ✅ Exportación de reportes CSV
- ✅ Backup completo en JSON (filtrado por org_id)
- ✅ Health check endpoint
- ✅ Reportes AI con lenguaje natural (OpenAI)
- ✅ Manejo global de errores
- ✅ Seeding de datos iniciales

## 🛠️ Instalación

### 1. Clonar repositorio
```bash
git clone <repo-url>
cd mrp_flask_be
```

### 2. Crear entorno virtual
```bash
python -m venv env
# Windows
.\env\Scripts\activate
# Linux/macOS
source env/bin/activate
```

### 3. Instalar dependencias
```bash
pip install -r requirements.txt
```

### 4. Configurar variables de entorno
```bash
# Copiar archivo de ejemplo
cp .env.example .env

# Editar .env con tus credenciales
# Mínimo requerido:
# - DB_USER, DB_PASS, DB_HOST, DB_NAME
# - JWT_SECRET_KEY
```

### 5. Crear base de datos
```bash
# PostgreSQL
createdb mrp

# Inicializar tablas (automático al correr la app)
python myapp.py
```

### 6. Seed de datos iniciales (opcional)
```bash
python seeds/init_data.py
```

## 🏃 Ejecución

### Desarrollo
```bash
python myapp.py
# Server: http://localhost:4646
```

### Docker
```bash
docker build -t mrp-backend .
docker run -p 4646:4646 \
  -e DB_HOST=host.docker.internal \
  -e DB_PASS=yourpassword \
  mrp-backend
```

### Docker Compose
```bash
docker-compose up -d
```

## 🚢 Deploy a AWS ECR

Ver documentación completa en [`scripts/README.md`](scripts/README.md)

```bash
# Windows PowerShell
.\scripts\deploy-ecr.ps1

# Linux/macOS
./scripts/deploy-ecr.sh
```

## 📁 Estructura del Proyecto

```
mrp_flask_be/
├── app/                    # Configuración y utilidades
│   ├── config.py          # Configuración por ambiente
│   ├── responses.py       # Formato estándar de respuestas
│   └── utils.py           # Utilidades comunes
├── controllers/           # Endpoints REST (Blueprints)
├── models/               # Modelos SQLAlchemy
├── services/             # Lógica de negocio
├── seeds/                # Scripts de inicialización
├── scripts/              # Scripts de deployment
├── docs/                 # Documentación del proyecto
├── myapp.py             # Punto de entrada de la aplicación
├── requirements.txt     # Dependencias Python
├── Dockerfile           # Imagen Docker
└── docker-compose.yml   # Orquestación local
```

## 🔧 Configuración

El sistema usa variables de entorno para configuración (ver `.env.example`):

### Variables Principales
| Variable | Descripción | Default |
|----------|-------------|---------|
| `FLASK_ENV` | Ambiente (development/production) | `development` |
| `DB_HOST` | Host de PostgreSQL | `localhost` |
| `DB_NAME` | Nombre de la base de datos | `mrp` |
| `JWT_SECRET_KEY` | Secret para JWT | `uagrm123` |

### Ambientes
- **Development**: `DevConfig` - Debug ON, SQL echo opcional
- **Production**: `ProdConfig` - Debug OFF, variables obligatorias

## 📡 API Endpoints

### Públicos
- `POST /api/public/signup` - Registro de nuevas organizaciones
- `GET /api/public/plans` - Lista de planes SaaS
- `GET /health` - Health check

### Autenticación
- `POST /api/auth/login` - Login con JWT
- `POST /api/auth/refresh` - Refresh token

### Inventario
- `GET/POST/PUT/DELETE /api/products` - CRUD Productos
- `GET/POST/PUT/DELETE /api/warehouses` - CRUD Almacenes
- `POST /api/movements` - Registrar movimientos
- `GET /api/stocks` - Consultar stock actual

### Reportes
- `GET /api/reports/products.csv` - Exportar productos CSV
- `GET /api/reports/movements.csv` - Exportar movimientos CSV
- `POST /api/reports/nl` - Reporte con lenguaje natural (AI)
- `GET /api/logs` - Auditoría de operaciones
- `GET /api/backup` - Backup completo JSON

Ver documentación completa de endpoints en [`docs/`](docs/)

## 🧪 Testing

```bash
# Verificar archivos del sprint
python verify_sprint.py

# Ejecutar tests unitarios (si existen)
pytest
```

## 🔒 Seguridad

- ✅ JWT con refresh tokens
- ✅ Control de acceso basado en roles (RBAC)
- ✅ Filtrado automático por org_id (multi-tenant)
- ✅ Validación de permisos en cada endpoint
- ✅ SQL Injection prevention (SQLAlchemy ORM)
- ✅ Password encoding con bcrypt
- ✅ Rate limiting en reportes AI

## 📚 Documentación Adicional

- [Sprint 1 Checklist](docs/SPRINT1_CHECKLIST.md)
- [Sprint 2 Documentation](docs/SPRINT2_DOCS.md)
- [Guía Completa Sprint Final](docs/README_SPRINT_FINAL.md)
- [Scripts de Deploy](scripts/README.md)

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add: AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Licencia

Proyecto académico - UAGRM Sistemas de Información 2

## 👥 Autores

- Equipo de desarrollo SI2 - UAGRM

## 🆘 Soporte

Para reportar bugs o solicitar features, usar GitHub Issues.

---

**Versión**: Sprint 2 - 2025
**Última actualización**: Enero 2025
