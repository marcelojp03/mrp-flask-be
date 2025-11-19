# MRP Backend

Backend Flask para sistema MRP (Material Requirements Planning) con arquitectura multi-tenant.

## Inicio Rápido

### Requisitos Previos
- Python 3.11+
- PostgreSQL 14+
- Git

### Instalación

1. Clonar repositorio:
```bash
git clone https://github.com/marcelojp03/mrp-flask-be.git
cd mrp-flask-be
```

2. Crear y activar entorno virtual:
```bash
# Crear entorno virtual
python -m venv env

# Activar (Windows PowerShell)
.\env\Scripts\activate

# Activar (Linux/macOS)
source env/bin/activate
```

3. Instalar dependencias:
```bash
pip install -r requirements.txt
```

4. Configurar variables de entorno:

Crear archivo `.env` en la raíz:
```env
DB_HOST=localhost
DB_PORT=5432
DB_USER=tu_usuario
DB_PASS=tu_password
DB_NAME=mrp
JWT_SECRET_KEY=tu_secreto_jwt_seguro
```

5. Inicializar base de datos:
```bash
# Crear base de datos
createdb mrp

# Ejecutar migraciones
python scripts/database/create_tables.py
```

6. Ejecutar aplicación:
```bash
python run.py
```

La aplicación estará disponible en: `http://localhost:4646`

### Verificar Instalación

```bash
# Health check
curl http://localhost:4646/health

# Test de conexión a BD
python tests/integration/test_db_connection.py
```

## Docker

### Usando Docker Compose
```bash
docker-compose up -d
```

### Construir imagen manualmente
```bash
docker build -t mrp-backend .

docker run -p 4646:4646 \
  -e DB_HOST=host.docker.internal \
  -e DB_PASS=yourpassword \
  mrp-backend
```

## Documentación

- [Información del Proyecto](docs/PROJECT_INFO.md) - Arquitectura, stack tecnológico, sprints
- [Endpoints API](docs/ENDPOINTS_COMPLETE_LIST.md) - Referencia completa de API
- [Deployment](docs/DEPLOY_ECR_SUMMARY.md) - Guía de deployment a AWS
- [Guías](docs/guides/) - Guías de uso específicas

## Testing

```bash
# Tests de integración
python tests/integration/test_fixed_endpoints.py

# Tests de Sprint 4/5
python test_sprint4_sprint5.py
```

## Estructura del Proyecto

```
mrp_flask_be/
├── app/                # Código fuente
│   ├── controllers/   # Endpoints REST
│   ├── models/       # Modelos SQLAlchemy
│   └── services/     # Lógica de negocio
├── auth/             # Autenticación JWT
├── migrations/       # Migraciones SQL
├── scripts/          # Scripts de utilidad
├── tests/            # Tests
├── docs/             # Documentación
└── run.py           # Punto de entrada
```

Ver estructura completa en [PROJECT_INFO.md](docs/PROJECT_INFO.md)

## Tecnologías

- Flask 3.x
- SQLAlchemy 2.x
- PostgreSQL 14+
- JWT Authentication
- Docker

## Contribución

Proyecto académico - UAGRM Sistemas de Información 2

## Repositorio

[github.com/marcelojp03/mrp-flask-be](https://github.com/marcelojp03/mrp-flask-be)
