# 📚 Documentación Completa - Endpoints Sprint 3

## 🔐 Autenticación

**Todos los endpoints requieren autenticación** mediante JWT token en el header:
```
Authorization: Bearer {access_token}
```

---

# 📋 BOMs (Bill of Materials)

## 1. GET /api/boms

**Descripción:** Lista todas las BOMs de la organización

**Query Parameters (opcionales):**
```
?product_id=8           # Filtrar por producto
?is_active=true         # Filtrar solo activas
```

**Request:**
```http
GET /api/boms HTTP/1.1
Authorization: Bearer {token}
```

**Response 200:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "org_id": 1,
      "product_id": 7,
      "product_code": "FG-MESA",
      "product_name": "Mesa Premium",
      "version": "1.0",
      "description": "BOM estándar para mesa de madera",
      "is_active": true,
      "created_at": "2025-10-27T18:13:51.740807",
      "updated_at": "2025-10-27T18:13:51.740807",
      "components": [
        {
          "id": 1,
          "bom_id": 1,
          "component_id": 6,
          "component_code": "RM-MAD",
          "component_name": "Madera Cedro",
          "quantity": 4.0,
          "unit_id": 1,
          "unit_code": "EA",
          "unit_description": "Unidad",
          "scrap_percentage": 5.0,
          "sequence": 1,
          "notes": "Tableros de madera principal",
          "created_at": "2025-10-27T18:13:51.752691"
        }
      ]
    }
  ],
  "message": "2 BOMs encontradas"
}
```

---

## 2. GET /api/boms/:id

**Descripción:** Obtiene una BOM específica con todos sus componentes

**Request:**
```http
GET /api/boms/1 HTTP/1.1
Authorization: Bearer {token}
```

**Response 200:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "product_id": 7,
    "product_code": "FG-MESA",
    "product_name": "Mesa Premium",
    "version": "1.0",
    "description": "BOM estándar para mesa",
    "is_active": true,
    "components": [
      {
        "component_id": 6,
        "component_code": "RM-MAD",
        "component_name": "Madera Cedro",
        "quantity": 4.0,
        "scrap_percentage": 5.0
      }
    ]
  }
}
```

**Response 404:**
```json
{
  "success": false,
  "message": "BOM no encontrada"
}
```

---

## 3. GET /api/boms/products-with-active-bom

**Descripción:** Lista productos que tienen BOM activa (útil para crear Work Orders)

**Request:**
```http
GET /api/boms/products-with-active-bom HTTP/1.1
Authorization: Bearer {token}
```

**Response 200:**
```json
{
  "success": true,
  "data": [
    {
      "id": 7,
      "code": "FG-MESA",
      "name": "Mesa Premium",
      "description": "Mesa de madera premium",
      "bom_version": "1.0"
    },
    {
      "id": 8,
      "code": "FG-SILLA",
      "name": "Silla Pro",
      "description": "Silla ergonómica profesional",
      "bom_version": "1.0"
    }
  ],
  "message": "2 productos con BOM activa"
}
```

---

## 4. POST /api/boms

**Descripción:** Crea una nueva BOM

**Request:**
```http
POST /api/boms HTTP/1.1
Authorization: Bearer {token}
Content-Type: application/json

{
  "product_id": 7,                    // REQUERIDO - ID del producto terminado
  "version": "1.0",                   // REQUERIDO - Versión de la BOM
  "description": "BOM estándar",      // OPCIONAL - Descripción
  "is_active": true,                  // OPCIONAL - Default: false
  "components": [                     // REQUERIDO - Mínimo 1 componente
    {
      "component_id": 6,              // REQUERIDO - ID del componente
      "quantity": 4.0,                // REQUERIDO - Cantidad necesaria
      "unit_id": 1,                   // OPCIONAL - Unidad de medida
      "scrap_percentage": 5.0,        // OPCIONAL - % desperdicio (default: 0)
      "sequence": 1,                  // OPCIONAL - Orden de ensamblaje
      "notes": "Material principal"   // OPCIONAL - Notas
    },
    {
      "component_id": 5,
      "quantity": 16.0,
      "unit_id": 1,
      "scrap_percentage": 3.0,
      "sequence": 2,
      "notes": "Tornillos de ensamblaje"
    }
  ]
}
```

**Response 201:**
```json
{
  "success": true,
  "data": {
    "id": 3,
    "product_id": 7,
    "version": "1.0",
    "is_active": true,
    "components": [...]
  },
  "message": "BOM creada exitosamente"
}
```

**Response 400 - Errores comunes:**
```json
// Falta campo requerido
{
  "success": false,
  "message": "Campo requerido: product_id"
}

// Sin componentes
{
  "success": false,
  "message": "La BOM debe tener al menos un componente"
}

// Recursividad
{
  "success": false,
  "message": "Un producto no puede ser componente de sí mismo"
}

// Componentes inválidos
{
  "success": false,
  "message": "Algunos componentes no existen"
}
```

**Response 404:**
```json
{
  "success": false,
  "message": "Producto no encontrado"
}
```

**Response 409:**
```json
{
  "success": false,
  "message": "Ya existe una BOM con esa versión para este producto"
}
```

---

## 5. PUT /api/boms/:id

**Descripción:** Actualiza una BOM existente (solo si NO está activa)

**Request:**
```http
PUT /api/boms/3 HTTP/1.1
Authorization: Bearer {token}
Content-Type: application/json

{
  "description": "BOM actualizada",
  "components": [              // Solo si BOM NO está activa
    {
      "component_id": 6,
      "quantity": 5.0,
      "scrap_percentage": 6.0
    }
  ]
}
```

**Response 200:**
```json
{
  "success": true,
  "data": {
    "id": 3,
    "description": "BOM actualizada",
    "components": [...]
  },
  "message": "BOM actualizada exitosamente"
}
```

**Response 400:**
```json
{
  "success": false,
  "message": "No se pueden modificar componentes de una BOM activa. Cree una nueva versión"
}
```

**Response 404:**
```json
{
  "success": false,
  "message": "BOM no encontrada"
}
```

---

## 6. PUT /api/boms/:id/activate

**Descripción:** Activa una versión de BOM (desactiva las demás del mismo producto)

**Request:**
```http
PUT /api/boms/3/activate HTTP/1.1
Authorization: Bearer {token}
```

**Response 200:**
```json
{
  "success": true,
  "data": {
    "id": 3,
    "product_id": 7,
    "version": "2.0",
    "is_active": true
  },
  "message": "BOM v2.0 activada para producto Mesa Premium"
}
```

**Response 404:**
```json
{
  "success": false,
  "message": "BOM no encontrada"
}
```

---

## 7. DELETE /api/boms/:id

**Descripción:** Elimina una BOM (solo si NO está activa y sin Work Orders)

**Request:**
```http
DELETE /api/boms/3 HTTP/1.1
Authorization: Bearer {token}
```

**Response 200:**
```json
{
  "success": true,
  "message": "BOM eliminada exitosamente"
}
```

**Response 400:**
```json
{
  "success": false,
  "message": "No se puede eliminar una BOM activa"
}
```

**Response 404:**
```json
{
  "success": false,
  "message": "BOM no encontrada"
}
```

---

# 🏭 WORK ORDERS (Órdenes de Producción)

## 1. GET /api/work-orders

**Descripción:** Lista todas las Work Orders de la organización

**Query Parameters (opcionales):**
```
?status=Planificada           # Filtrar por estado
?product_id=8                 # Filtrar por producto
?assigned_to=1                # Filtrar por operario
```

**Estados válidos:** `Planificada`, `En Progreso`, `Finalizada`, `Cancelada`

**Request:**
```http
GET /api/work-orders HTTP/1.1
Authorization: Bearer {token}
```

**Response 200:**
```json
{
  "success": true,
  "data": [
    {
      "id": 2,
      "org_id": 1,
      "product_id": 8,
      "product_code": "FG-SILLA",
      "product_name": "Silla Pro",
      "bom_id": 2,
      "bom_version": "1.0",
      "quantity": 10.0,
      "status": "Planificada",
      "warehouse_id": 1,
      "warehouse_name": "Principal",
      "assigned_to": 1,
      "assigned_to_name": "Marcelo Jimenez",
      "reference": "OP-2025-002",
      "notes": "Orden de sillas para stock",
      "planned_start": "2025-10-29T14:13:51.806066",
      "planned_end": "2025-11-01T14:13:51.806066",
      "actual_start": null,
      "actual_end": null,
      "created_by": 1,
      "created_by_name": "Marcelo Jimenez",
      "created_at": "2025-10-27T18:13:51.806643",
      "updated_at": "2025-10-27T18:13:51.806643"
    }
  ],
  "message": "2 órdenes encontradas"
}
```

---

## 2. GET /api/work-orders/:id

**Descripción:** Obtiene una Work Order específica

**Request:**
```http
GET /api/work-orders/2 HTTP/1.1
Authorization: Bearer {token}
```

**Response 200:**
```json
{
  "success": true,
  "data": {
    "id": 2,
    "product_id": 8,
    "product_name": "Silla Pro",
    "quantity": 10.0,
    "status": "Planificada",
    "warehouse_name": "Principal",
    "assigned_to_name": "Marcelo Jimenez"
  }
}
```

**Response 404:**
```json
{
  "success": false,
  "message": "Work Order no encontrada"
}
```

---

## 3. POST /api/work-orders

**Descripción:** Crea una nueva Work Order en estado "Planificada"

**Request:**
```http
POST /api/work-orders HTTP/1.1
Authorization: Bearer {token}
Content-Type: application/json

{
  "product_id": 8,                          // REQUERIDO - ID del producto (debe tener BOM activa)
  "quantity": 10,                           // REQUERIDO - Cantidad a producir
  "warehouse_id": 1,                        // OPCIONAL - Almacén de producción
  "assigned_to": 1,                         // OPCIONAL - ID del operario
  "reference": "OP-2025-003",               // OPCIONAL - Referencia única
  "notes": "Orden urgente",                 // OPCIONAL - Notas
  "planned_start": "2025-11-01T08:00:00",   // OPCIONAL - Inicio planificado
  "planned_end": "2025-11-03T18:00:00"      // OPCIONAL - Fin planificado
}
```

**Response 201:**
```json
{
  "success": true,
  "data": {
    "id": 3,
    "product_id": 8,
    "product_name": "Silla Pro",
    "quantity": 10.0,
    "status": "Planificada",
    "bom_id": 2,
    "bom_version": "1.0",
    "warehouse_id": 1
  },
  "message": "Work Order creada exitosamente"
}
```

**Response 400 - Errores comunes:**
```json
// Falta campo requerido
{
  "success": false,
  "message": "Campo requerido: product_id"
}

// Producto sin BOM activa
{
  "success": false,
  "message": "No existe una BOM activa para este producto"
}
```

**Response 404:**
```json
// Producto no existe
{
  "success": false,
  "message": "Producto no encontrado"
}

// Almacén no existe
{
  "success": false,
  "message": "Almacén no encontrado"
}
```

---

## 4. PUT /api/work-orders/:id/start

**Descripción:** Inicia una Work Order - Descuenta componentes y cambia estado a "En Progreso"

**Request:**
```http
PUT /api/work-orders/2/start HTTP/1.1
Authorization: Bearer {token}
```

**Response 200:**
```json
{
  "success": true,
  "data": {
    "work_order": {
      "id": 2,
      "status": "En Progreso",
      "actual_start": "2025-10-31T16:26:00.090502",
      "product_name": "Silla Pro",
      "quantity": 10.0
    },
    "movements": [
      {
        "movement_id": 6,
        "product_id": 6,
        "product_code": "RM-MAD",
        "product_name": "Madera Cedro",
        "quantity": 20.8              // 2.0 × 10 × 1.04 (scrap 4%)
      },
      {
        "movement_id": 7,
        "product_id": 2,
        "product_code": "RM-ALU",
        "product_name": "Aluminio 6061",
        "quantity": 15.9              // 1.5 × 10 × 1.06 (scrap 6%)
      },
      {
        "movement_id": 8,
        "product_id": 5,
        "product_code": "RM-TORN",
        "product_name": "Tornillos M6",
        "quantity": 123.6             // 12 × 10 × 1.03 (scrap 3%)
      }
    ]
  },
  "message": "Work Order iniciada. 3 movimientos de consumo generados"
}
```

**Response 400 - Stock insuficiente:**
```json
{
  "success": false,
  "message": "Stock insuficiente para iniciar producción",
  "details": {
    "insufficient_stock": [
      {
        "product": "Madera Cedro",
        "required": 20.8,
        "available": 15.0,
        "missing": 5.8
      },
      {
        "product": "Tornillos M6",
        "required": 123.6,
        "available": 100.0,
        "missing": 23.6
      }
    ]
  }
}
```

**Response 400 - Estado inválido:**
```json
{
  "success": false,
  "message": "Solo se pueden iniciar Work Orders en estado Planificada. Estado actual: En Progreso"
}
```

**Response 404:**
```json
{
  "success": false,
  "message": "Work Order no encontrada"
}
```

---

## 5. PUT /api/work-orders/:id/finish

**Descripción:** Finaliza una Work Order - Agrega productos terminados y cambia estado a "Finalizada"

**Request:**
```http
PUT /api/work-orders/2/finish HTTP/1.1
Authorization: Bearer {token}
Content-Type: application/json

{
  "produced_quantity": 9        // OPCIONAL - Cantidad producida (default: cantidad planificada)
}
```

**Response 200:**
```json
{
  "success": true,
  "data": {
    "work_order": {
      "id": 2,
      "status": "Finalizada",
      "actual_start": "2025-10-31T16:26:00.090502",
      "actual_end": "2025-10-31T18:30:00.123456",
      "quantity": 10.0
    },
    "movement": {
      "movement_id": 9,
      "product_id": 8,
      "product_code": "FG-SILLA",
      "product_name": "Silla Pro",
      "quantity": 10,
      "warehouse_id": 1,
      "warehouse_name": "Principal"
    }
  },
  "message": "Work Order finalizada. 10 unidades de Silla Pro agregadas al inventario"
}
```

**Response 400:**
```json
{
  "success": false,
  "message": "Solo se pueden finalizar Work Orders en estado En Progreso. Estado actual: Planificada"
}

// O si cantidad inválida
{
  "success": false,
  "message": "La cantidad producida debe ser mayor a 0"
}
```

**Response 404:**
```json
{
  "success": false,
  "message": "Work Order no encontrada"
}
```

---

## 6. PUT /api/work-orders/:id/cancel

**Descripción:** Cancela una Work Order (puede estar Planificada o En Progreso)

**Request:**
```http
PUT /api/work-orders/2/cancel HTTP/1.1
Authorization: Bearer {token}
Content-Type: application/json

{
  "reason": "Cambio de prioridades"    // OPCIONAL - Motivo de cancelación
}
```

**Response 200:**
```json
{
  "success": true,
  "data": {
    "id": 2,
    "status": "Cancelada",
    "product_name": "Silla Pro"
  },
  "message": "Work Order cancelada exitosamente"
}
```

**Response 400:**
```json
{
  "success": false,
  "message": "Solo se pueden cancelar Work Orders en estado Planificada o En Progreso"
}
```

**Response 404:**
```json
{
  "success": false,
  "message": "Work Order no encontrada"
}
```

---

# 📦 MOVEMENTS (Mejorado Sprint 3)

## GET /api/movements

**Descripción:** Lista movimientos con nombres de productos y almacenes

**Query Parameters (opcionales):**
```
?product_id=8                  # Filtrar por producto
?from_warehouse_id=1           # Filtrar por almacén origen
?to_warehouse_id=1             # Filtrar por almacén destino
?movement_type=OUT             # Filtrar por tipo (IN, OUT, TRANSFER, ADJUST)
?reason=CONSUMPTION            # Filtrar por razón (PURCHASE, CONSUMPTION, PRODUCTION, etc.)
```

**Request:**
```http
GET /api/movements HTTP/1.1
Authorization: Bearer {token}
```

**Response 200:**
```json
{
  "success": true,
  "data": [
    {
      "id": 6,
      "org_id": 1,
      "product_id": 6,
      "product_code": "RM-MAD",
      "product_name": "Madera Cedro",
      "from_warehouse_id": 1,
      "from_warehouse_name": "Principal",
      "to_warehouse_id": null,
      "to_warehouse_name": null,
      "movement_type": "OUT",
      "reason": "CONSUMPTION",
      "quantity": 20.8,
      "reference_id": "2",
      "reference_type": "WO",
      "note": "Consumo para WO #2 - Silla Pro",
      "created_by": 1,
      "created_by_name": "Marcelo Jimenez",
      "created_at": "Fri, 31 Oct 2025 16:26:00 GMT"
    },
    {
      "id": 9,
      "product_id": 8,
      "product_code": "FG-SILLA",
      "product_name": "Silla Pro",
      "from_warehouse_id": null,
      "from_warehouse_name": null,
      "to_warehouse_id": 1,
      "to_warehouse_name": "Principal",
      "movement_type": "IN",
      "reason": "PRODUCTION",
      "quantity": 10.0,
      "reference_id": "2",
      "reference_type": "WO",
      "note": "Producción completada - WO #2",
      "created_by": 1,
      "created_by_name": "Marcelo Jimenez",
      "created_at": "Fri, 31 Oct 2025 18:30:00 GMT"
    }
  ],
  "message": "OK"
}
```

**Tipos de movimiento:**
- `IN` - Entrada (compra, producción, ajuste positivo)
- `OUT` - Salida (consumo, venta, ajuste negativo)
- `TRANSFER` - Transferencia entre almacenes
- `ADJUST` - Ajuste de inventario

**Razones:**
- `PURCHASE` - Compra
- `CONSUMPTION` - Consumo en producción
- `PRODUCTION` - Producción terminada
- `TRANSFER` - Transferencia
- `ADJUSTMENT` - Ajuste
- `RETURN` - Devolución
- `OTHER` - Otro

---

# 📊 Resumen de Campos

## Campos REQUERIDOS por endpoint:

### POST /api/boms:
- `product_id` (número)
- `version` (string)
- `components` (array con al menos 1 elemento)
  - `component_id` (número)
  - `quantity` (número)

### POST /api/work-orders:
- `product_id` (número - debe tener BOM activa)
- `quantity` (número > 0)

### PUT /api/work-orders/:id/finish:
- Ninguno (todos opcionales, pero si envías body debe ser JSON válido)

---

# ⚠️ Errores Comunes

## 1. Content-Type incorrecto
```http
415 Unsupported Media Type
```
**Solución:** Agregar header `Content-Type: application/json`

## 2. Campo requerido faltante
```json
{
  "success": false,
  "message": "Campo requerido: product_id"
}
```
**Solución:** Verificar que todos los campos REQUERIDOS estén presentes

## 3. Tipo de dato incorrecto
```json
{
  "success": false,
  "message": "Error al crear..."
}
```
**Solución:** Verificar que números sean números, no strings

## 4. Autenticación faltante/inválida
```json
{
  "success": false,
  "message": "Token sin org_id"
}
```
**Solución:** Incluir header `Authorization: Bearer {token}` válido

---

# 🎯 Ejemplos Completos de Flujos

## Flujo 1: Crear y activar BOM
```javascript
// 1. Crear BOM
POST /api/boms
{
  "product_id": 9,
  "version": "1.0",
  "components": [
    {"component_id": 6, "quantity": 3.0, "scrap_percentage": 5.0}
  ]
}

// 2. Activar BOM
PUT /api/boms/3/activate
```

## Flujo 2: Producir un producto
```javascript
// 1. Verificar productos con BOM
GET /api/boms/products-with-active-bom

// 2. Crear Work Order
POST /api/work-orders
{
  "product_id": 8,
  "quantity": 10,
  "warehouse_id": 1
}

// 3. Iniciar producción
PUT /api/work-orders/3/start

// 4. Finalizar producción
PUT /api/work-orders/3/finish
{
  "produced_quantity": 10
}

// 5. Ver movimientos generados
GET /api/movements?reference_id=3
```

---

**Versión:** Sprint 3 - Noviembre 2025  
**Total Endpoints:** 13+ endpoints documentados
