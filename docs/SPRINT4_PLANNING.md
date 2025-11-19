# Sprint 4: Sistema de Planificación (Demand → MPS → MRP)

## 📋 Resumen

Sprint 4 implementa el sistema completo de planificación de materiales:
- **Gestión de Demanda**: Captura y gestión de proyecciones de demanda
- **MPS (Master Production Schedule)**: Plan maestro de producción
- **MRP (Material Requirements Planning)**: Cálculo de necesidades de materiales con explosión de BOM

## 🗄️ Modelos de Base de Datos

### 1. Tabla `demand`
Almacena proyecciones de demanda (manual, importada o pronosticada).

```sql
CREATE TABLE demand (
    id SERIAL PRIMARY KEY,
    org_id INTEGER NOT NULL REFERENCES organization(id),
    product_id INTEGER NOT NULL REFERENCES product(id),
    period DATE NOT NULL,
    quantity NUMERIC(10, 2) NOT NULL CHECK (quantity > 0),
    source VARCHAR(20) NOT NULL DEFAULT 'manual' CHECK (source IN ('manual', 'import', 'forecast')),
    status VARCHAR(20) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'confirmed', 'cancelled')),
    notes TEXT,
    created_by INTEGER REFERENCES usuario(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_demand_org_product ON demand(org_id, product_id);
CREATE INDEX idx_demand_period ON demand(period);
CREATE INDEX idx_demand_status ON demand(status);
```

**Campos:**
- `source`: Origen de la demanda (manual, import, forecast)
- `status`: Estado (draft, confirmed, cancelled)
- `period`: Periodo/fecha de la demanda proyectada

### 2. Tabla `mps_plan`
Plan Maestro de Producción calculado desde la demanda.

```sql
CREATE TABLE mps_plan (
    id SERIAL PRIMARY KEY,
    org_id INTEGER NOT NULL REFERENCES organization(id),
    product_id INTEGER NOT NULL REFERENCES product(id),
    period DATE NOT NULL,
    planned_qty NUMERIC(10, 2) NOT NULL CHECK (planned_qty > 0),
    demand_id INTEGER REFERENCES demand(id),
    status VARCHAR(20) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'cancelled')),
    notes TEXT,
    published_at TIMESTAMP,
    created_by INTEGER REFERENCES usuario(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_mps_org_product ON mps_plan(org_id, product_id);
CREATE INDEX idx_mps_period ON mps_plan(period);
CREATE INDEX idx_mps_status ON mps_plan(status);
```

**Campos:**
- `planned_qty`: Cantidad planificada a producir
- `status`: draft (borrador), published (publicado), cancelled
- `published_at`: Timestamp de publicación

### 3. Tabla `mrp_proposal`
Propuestas generadas por MRP (BUY o MAKE).

```sql
CREATE TABLE mrp_proposal (
    id SERIAL PRIMARY KEY,
    org_id INTEGER NOT NULL REFERENCES organization(id),
    mps_plan_id INTEGER REFERENCES mps_plan(id),
    product_id INTEGER NOT NULL REFERENCES product(id),
    type VARCHAR(10) NOT NULL CHECK (type IN ('BUY', 'MAKE')),
    quantity NUMERIC(10, 2) NOT NULL CHECK (quantity > 0),
    due_date DATE NOT NULL,
    source_period DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'proposed' CHECK (status IN ('proposed', 'approved', 'rejected', 'executed')),
    reason TEXT,
    supplier_id INTEGER REFERENCES supplier(id),
    estimated_cost NUMERIC(12, 2),
    warehouse_id INTEGER REFERENCES warehouse(id),
    approved_at TIMESTAMP,
    approved_by INTEGER REFERENCES usuario(id),
    executed_reference_type VARCHAR(10) CHECK (executed_reference_type IN ('WO', 'PO')),
    executed_reference_id INTEGER,
    created_by INTEGER REFERENCES usuario(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_mrp_org_product ON mrp_proposal(org_id, product_id);
CREATE INDEX idx_mrp_due_date ON mrp_proposal(due_date);
CREATE INDEX idx_mrp_status ON mrp_proposal(status);
CREATE INDEX idx_mrp_type ON mrp_proposal(type);
```

**Campos:**
- `type`: BUY (comprar) o MAKE (fabricar)
- `status`: proposed → approved → executed (o rejected)
- `executed_reference_type/id`: Vinculación con WO (Work Order) o PO (Purchase Order)

## 🔌 API Endpoints

### Gestión de Demanda

#### `GET /api/demand`
Listar demandas con filtros.

**Query Parameters:**
- `product_id`: int (opcional)
- `period_start`: date YYYY-MM-DD (opcional)
- `period_end`: date YYYY-MM-DD (opcional)
- `source`: manual|import|forecast (opcional)
- `status`: draft|confirmed|cancelled (opcional)

**Response 200:**
```json
{
  "success": true,
  "message": "15 demandas encontradas",
  "data": [
    {
      "id": 1,
      "org_id": 1,
      "product_id": 123,
      "product_code": "PROD-001",
      "product_name": "Producto A",
      "period": "2025-02-01",
      "quantity": 150.00,
      "source": "manual",
      "status": "confirmed",
      "notes": "Demanda Q1 2025",
      "created_by": 5,
      "created_at": "2025-01-15T10:00:00",
      "updated_at": "2025-01-15T10:00:00"
    }
  ]
}
```

#### `POST /api/demand`
Crear nueva demanda.

**Request Body:**
```json
{
  "product_id": 123,
  "period": "2025-02-01",
  "quantity": 150.0,
  "source": "manual",
  "status": "draft",
  "notes": "Demanda estimada Q1"
}
```

**Response 201:**
```json
{
  "success": true,
  "message": "Demanda creada exitosamente",
  "data": { ... }
}
```

#### `PUT /api/demand/:id`
Actualizar demanda existente.

#### `DELETE /api/demand/:id`
Eliminar demanda.

#### `POST /api/demand/import`
Importar demandas desde archivo CSV.

**Form Data:**
- `file`: archivo CSV con formato:
  ```csv
  product_code,period,quantity,notes
  PROD-001,2025-02-01,100,Demanda Q1
  PROD-002,2025-02-01,50,
  ```

**Response 200:**
```json
{
  "success": true,
  "message": "25 demandas importadas, 3 errores",
  "data": {
    "created_count": 25,
    "created": [...],
    "errors_count": 3,
    "errors": [
      "Línea 5: Producto 'PROD-999' no encontrado",
      "Línea 8: Cantidad debe ser mayor a 0"
    ]
  }
}
```

### Master Production Schedule (MPS)

#### `POST /api/mps/simulate`
Simular plan MPS desde demanda confirmada.

**Request Body:**
```json
{
  "period_start": "2025-02-01",
  "period_end": "2025-02-28",
  "product_ids": [123, 456]  // opcional
}
```

**Response 200:**
```json
{
  "success": true,
  "message": "12 propuestas MPS generadas",
  "data": [
    {
      "product_id": 123,
      "product_code": "PROD-001",
      "product_name": "Producto A",
      "period": "2025-02-01",
      "planned_qty": 150.0,
      "demand_qty": 150.0,
      "demand_ids": [1, 2, 3]
    }
  ]
}
```

#### `POST /api/mps/publish`
Publicar plan MPS (guardar propuestas simuladas).

**Request Body:**
```json
{
  "plans": [
    {
      "product_id": 123,
      "period": "2025-02-01",
      "planned_qty": 150.0,
      "demand_ids": [1, 2],
      "notes": "Plan Q1 2025"
    }
  ]
}
```

**Response 201:**
```json
{
  "success": true,
  "message": "10 planes MPS publicados exitosamente",
  "data": [...]
}
```

#### `GET /api/mps`
Listar planes MPS con filtros (product_id, period_start, period_end, status).

#### `PUT /api/mps/:id/cancel`
Cancelar plan MPS.

### Material Requirements Planning (MRP)

#### `POST /api/mrp/run`
Ejecutar MRP con explosión de BOM.

**Lógica:**
1. Lee planes MPS publicados en el rango
2. Explota BOMs para calcular componentes necesarios
3. Calcula necesidad neta: `(cantidad_bom × cantidad_mps) - stock_disponible`
4. Decide BUY (si tiene proveedor) o MAKE (si tiene BOM)
5. Calcula `due_date` considerando lead times

**Request Body:**
```json
{
  "period_start": "2025-02-01",
  "period_end": "2025-02-28"
}
```

**Response 201:**
```json
{
  "success": true,
  "message": "35 propuestas MRP generadas",
  "data": {
    "message": "35 propuestas MRP generadas",
    "proposals_created": 35,
    "proposals": [
      {
        "id": 1,
        "org_id": 1,
        "mps_plan_id": 5,
        "product_id": 200,
        "product_code": "COMP-001",
        "product_name": "Componente X",
        "type": "BUY",
        "quantity": 500.0,
        "due_date": "2025-01-25",
        "source_period": "2025-02-01",
        "status": "proposed",
        "reason": "Componente para Producto A - MPS 2025-02-01",
        "supplier_id": 10,
        "estimated_cost": 5000.00,
        "warehouse_id": null,
        "created_by": 5,
        "created_at": "2025-01-20T10:00:00"
      }
    ]
  }
}
```

#### `GET /api/mrp/proposals`
Listar propuestas MRP con filtros.

**Query Parameters:**
- `product_id`: int
- `type`: BUY|MAKE
- `status`: proposed|approved|rejected|executed
- `due_date_start`: date
- `due_date_end`: date

#### `PUT /api/mrp/proposals/:id/approve`
Aprobar propuesta MRP.

**Response 200:**
```json
{
  "success": true,
  "message": "Propuesta aprobada exitosamente",
  "data": {
    "id": 1,
    "status": "approved",
    "approved_at": "2025-01-20T14:30:00",
    "approved_by": 5,
    ...
  }
}
```

#### `PUT /api/mrp/proposals/:id/reject`
Rechazar propuesta MRP.

**Request Body (opcional):**
```json
{
  "reason": "Stock suficiente ya disponible"
}
```

#### `PUT /api/mrp/proposals/:id/execute`
Marcar propuesta como ejecutada (vinculada a WO o PO).

**Request Body:**
```json
{
  "reference_type": "WO",  // WO o PO
  "reference_id": 123
}
```

#### `POST /api/mrp/proposals/bulk-approve`
Aprobar múltiples propuestas.

**Request Body:**
```json
{
  "proposal_ids": [1, 2, 3, 4, 5]
}
```

## 🔄 Flujo Completo Sprint 4

```
1. DEMANDA
   Usuario crea demanda manualmente o importa CSV
   └─> POST /api/demand o POST /api/demand/import
   └─> Estado: draft → confirmed

2. MPS (Master Production Schedule)
   Sistema simula plan desde demanda confirmada
   └─> POST /api/mps/simulate
   └─> Usuario revisa y publica
   └─> POST /api/mps/publish
   └─> Estado: draft → published

3. MRP (Material Requirements Planning)
   Sistema ejecuta MRP con explosión de BOM
   └─> POST /api/mrp/run
   └─> Genera propuestas BUY/MAKE
   └─> Usuario aprueba propuestas
   └─> PUT /api/mrp/proposals/:id/approve
   └─> Usuario ejecuta (crea WO o PO)
   └─> PUT /api/mrp/proposals/:id/execute
```

## 🧮 Lógica de Negocio MRP

### Explosión de BOM
```python
# Pseudo-código del algoritmo MRP
for mps_plan in mps_plans_publicados:
    bom = obtener_bom_activa(mps_plan.product_id)
    
    for componente in bom.components:
        # Calcular cantidad necesaria
        cantidad_base = componente.quantity * mps_plan.planned_qty
        scrap_factor = 1 + (componente.scrap_percentage / 100)
        cantidad_requerida = cantidad_base * scrap_factor
        
        # Obtener stock disponible
        stock_actual = obtener_stock(componente.component_id)
        
        # Necesidad neta
        necesidad_neta = cantidad_requerida - stock_actual
        
        if necesidad_neta > 0:
            # Decidir BUY o MAKE
            if tiene_proveedor(componente.component_id):
                tipo = "BUY"
                supplier = obtener_proveedor(componente.component_id)
                lead_time = supplier.lead_time_days
            elif tiene_bom(componente.component_id):
                tipo = "MAKE"
                lead_time = 7  # default
            else:
                tipo = "BUY"
                lead_time = 7
            
            # Calcular fecha de vencimiento
            due_date = mps_plan.period - timedelta(days=lead_time)
            
            # Crear propuesta
            crear_propuesta_mrp(
                product_id=componente.component_id,
                type=tipo,
                quantity=necesidad_neta,
                due_date=due_date,
                mps_plan_id=mps_plan.id,
                supplier_id=supplier.id if tipo == "BUY" else None
            )
```

## 📊 Servicios Implementados

### `DemandService`
- `list()`: Listar con filtros
- `get()`: Obtener por ID
- `create()`: Crear demanda
- `update()`: Actualizar
- `delete()`: Eliminar
- `bulk_create()`: Importación masiva

### `MPSService`
- `list()`: Listar planes
- `get()`: Obtener por ID
- `simulate()`: Simular plan desde demanda
- `publish()`: Publicar planes
- `create()`: Crear individual
- `update()`: Actualizar
- `delete()`: Eliminar (solo draft)

### `MRPService`
- `run()`: Ejecutar MRP con explosión de BOM
- `list_proposals()`: Listar propuestas
- `get_proposal()`: Obtener por ID
- `approve_proposal()`: Aprobar
- `reject_proposal()`: Rechazar
- `execute_proposal()`: Marcar como ejecutada

## 🔒 Autenticación

Todos los endpoints requieren:
- Header: `Authorization: Bearer <access_token>`
- JWT debe contener: `org_id` y `user_id`

## 📈 Métricas de Implementación

**Sprint 4 Completado:**
- ✅ 3 tablas nuevas en BD
- ✅ 3 modelos SQLAlchemy
- ✅ 3 migraciones SQL aplicadas
- ✅ 3 servicios con lógica de negocio
- ✅ 3 controladores
- ✅ 21 endpoints REST funcionando
- ✅ Integración completa con sistema existente (BOMs, Stock, Suppliers)

**Líneas de código:**
- Modelos: ~200 líneas
- Servicios: ~500 líneas
- Controladores: ~700 líneas
- Migraciones: ~150 líneas
- **Total: ~1,550 líneas** de código productivo

---

**Fecha de implementación:** Enero 2025  
**Versión:** Sprint 4  
**Estado:** ✅ Completado y funcionando
