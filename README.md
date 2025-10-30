# 🏭 MRP Backend - Sistema de Planificación de Requerimientos de Materiales

Backend Flask para sistema MRP (Material Requirements Planning) con arquitectura multi-tenant SaaS.

## 🚀 Stack Tecnológico

- **Framework**: Flask 3.x
- **ORM**: SQLAlchemy 2.x
- **Base de Datos**: PostgreSQL 14+
- **Autenticación**: JWT custom
- **Container**: Docker + AWS ECR

---

## 🛠️ Instalación y Ejecución

### 1️⃣ Requisitos Previos
- Python 3.11+
- PostgreSQL 14+
- Git

### 2️⃣ Clonar e Instalar

```bash
# Clonar repositorio
git clone https://github.com/marcelojp03/mrp-flask-be.git
cd mrp-flask-be

# Crear entorno virtual
python -m venv env

# Activar entorno virtual
# Windows PowerShell:
.\env\Scripts\activate
# Linux/macOS:
source env/bin/activate

# Instalar dependencias
pip install -r requirements.txt
```

### 3️⃣ Configurar Base de Datos

```bash
# Crear base de datos PostgreSQL
createdb mrp

# Configurar variables de entorno
# Crear archivo .env con:
DB_HOST=localhost
DB_PORT=5432
DB_USER=tu_usuario
DB_PASS=tu_password
DB_NAME=mrp
JWT_SECRET_KEY=tu_secreto_jwt_seguro
```

**⚠️ IMPORTANTE**: Nunca commitear archivos `.env` con credenciales reales.

### 4️⃣ Inicializar Base de Datos

```bash
# Ejecutar migraciones
python scripts/database/create_tables.py

# Poblar datos iniciales (opcional)
python scripts/database/populate_database.py
```

### 5️⃣ Ejecutar Aplicación

```bash
# Modo desarrollo
python run.py

# La aplicación estará disponible en:
# http://localhost:4646
```

### 6️⃣ Verificar Instalación

```bash
# Test de conexión a DB
python tests/integration/test_db_connection.py

# Health check
curl http://localhost:4646/health
```

---

## 🐳 Ejecutar con Docker

```bash
# Build
docker build -t mrp-backend .

# Run
docker run -p 4646:4646 \
  -e DB_HOST=host.docker.internal \
  -e DB_PASS=yourpassword \
  mrp-backend

# O usar Docker Compose
docker-compose up -d
```

---

## 📁 Estructura del Proyecto

```
mrp_flask_be/
├── app/                    # Código fuente principal
│   ├── controllers/       # Endpoints REST
│   ├── models/           # Modelos SQLAlchemy
│   ├── services/         # Lógica de negocio
│   ├── entities/         # DTOs y entidades
│   ├── config.py         # Configuración
│   └── db.py             # Database setup
├── migrations/           # SQL migrations
├── seeds/               # Datos iniciales
├── scripts/             # Scripts de utilidad
│   ├── database/       # Scripts de BD
│   ├── setup/          # Setup inicial
│   ├── deploy/         # Deployment
│   └── testing/        # Tests PowerShell
├── tests/              # Tests
│   └── integration/    # Tests de integración
├── docs/               # Documentación
├── run.py             # Punto de entrada
└── requirements.txt   # Dependencias Python
```

Ver documentación completa de estructura en [`docs/PROJECT_STRUCTURE.md`](docs/PROJECT_STRUCTURE.md)

---

## 📖 Documentación

| Documento | Descripción |
|-----------|-------------|
| [`docs/PROJECT_STRUCTURE.md`](docs/PROJECT_STRUCTURE.md) | Estructura completa del proyecto |
| [`docs/ENDPOINTS_COMPLETE_LIST.md`](docs/ENDPOINTS_COMPLETE_LIST.md) | Referencia de API |
| [`docs/guides/`](docs/guides/) | Guías de uso |

---

## 🧪 Testing

```bash
# Tests de integración
python tests/integration/test_fixed_endpoints.py

# Tests PowerShell (requiere servidor corriendo)
.\scripts\testing\test-all-endpoints.ps1
```

---

## 🚢 Deploy a AWS ECR

```bash
# Windows PowerShell
.\scripts\deploy\deploy-ecr.ps1

# Linux/macOS
./scripts/deploy/deploy-ecr.sh
```

---

## � Sprints Implementados

- ✅ **Sprint 1**: Core MRP (Usuarios, Roles, Productos, Inventario)
- ✅ **Sprint 2**: SaaS Multi-Tenant (Signup, Planes, Menú Dinámico)
- ✅ **Sprint 3**: Producción (BOMs, Work Orders, Trazabilidad)
- ⏳ **Sprint 4**: Planificación (MPS, MRP)
- ⏳ **Sprint 5**: Analytics (Forecasting, IA)

---

## 🤝 Contribución

Proyecto académico - UAGRM Sistemas de Información 2

---

**Versión**: Sprint 3 - 2025  
**Repositorio**: [marcelojp03/mrp-flask-be](https://github.com/marcelojp03/mrp-flask-be)
