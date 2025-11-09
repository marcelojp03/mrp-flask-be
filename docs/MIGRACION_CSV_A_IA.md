# 📊 Migración: Exportar CSV → Reportes IA

## ✅ Cambios Realizados

### Backend
- ✅ Eliminado subrecurso "Exportar CSV" (ID: 55)
- ✅ Eliminadas asignaciones de roles
- ✅ Actualizado `seeds/init_data.py` para no recrearlo

### Endpoints Obsoletos (mantener por compatibilidad temporal)
- `GET /api/reports/products.csv` - Usar en su lugar: `POST /api/reports/nl`
- `GET /api/reports/movements.csv` - Usar en su lugar: `POST /api/reports/nl`

---

## 🔄 Migración para Frontend

### Antes (Exportar CSV)
```javascript
// Productos
const response = await fetch('/api/reports/products.csv', {
  headers: { 'Authorization': `Bearer ${token}` }
});

// Movimientos
const response = await fetch('/api/reports/movements.csv?from=2025-01-01&to=2025-12-31', {
  headers: { 'Authorization': `Bearer ${token}` }
});
```

### Después (Reportes IA)
```javascript
// Productos - Más flexible
const response = await fetch('/api/reports/nl', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    query: "lista de productos activos con stock",
    format: "csv",  // o "excel", "pdf", "json"
    limit: 1000
  })
});

// Movimientos - Con lenguaje natural
const response = await fetch('/api/reports/nl', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    query: "movimientos de inventario desde enero 2025",
    format: "csv",
    limit: 5000
  })
});
```

---

## 🎯 Ventajas de la Migración

| Característica | Exportar CSV (Viejo) | Reportes IA (Nuevo) |
|----------------|---------------------|---------------------|
| **Flexibilidad** | ❌ Solo 2 reportes fijos | ✅ Consultas ilimitadas |
| **Formatos** | ❌ Solo CSV | ✅ CSV, Excel, PDF, JSON |
| **Personalización** | ❌ Columnas fijas | ✅ Columnas dinámicas |
| **Interpretación** | ❌ Solo datos crudos | ✅ Análisis con IA |
| **Filtros** | ❌ Solo fechas | ✅ Cualquier filtro |
| **Joins** | ❌ No soportado | ✅ Múltiples tablas |
| **Headers** | ❌ Sin formato | ✅ Estilizados (Excel/PDF) |

---

## 📝 Ejemplos de Reemplazo

### 1. Exportar todos los productos
```javascript
// VIEJO
GET /api/reports/products.csv

// NUEVO (más opciones)
POST /api/reports/nl
{
  "query": "lista completa de productos con categoría y stock",
  "format": "excel",
  "limit": 10000
}
```

### 2. Exportar movimientos con filtros
```javascript
// VIEJO (solo fechas)
GET /api/reports/movements.csv?from=2025-01-01&to=2025-01-31

// NUEVO (más flexible)
POST /api/reports/nl
{
  "query": "movimientos de enero 2025 con producto y almacén",
  "format": "excel",
  "limit": 5000
}
```

### 3. Reportes personalizados (NUEVO)
```javascript
// Antes: imposible sin modificar backend
// Ahora: solo escribe la consulta

POST /api/reports/nl
{
  "query": "productos con stock bajo del mínimo y su proveedor",
  "format": "pdf"
}

POST /api/reports/nl
{
  "query": "top 10 productos con más movimientos este mes",
  "format": "excel"
}
```

---

## 🚀 Botones de Acceso Rápido (Sugeridos para UI)

```javascript
const QUICK_REPORTS = [
  {
    label: "📦 Exportar Productos",
    query: "lista completa de productos activos con stock",
    format: "excel",
    icon: "pi pi-box"
  },
  {
    label: "↔️ Exportar Movimientos",
    query: "movimientos de inventario de los últimos 30 días",
    format: "excel",
    icon: "pi pi-arrow-right-arrow-left"
  },
  {
    label: "⚠️ Stock Bajo",
    query: "productos con stock por debajo del mínimo",
    format: "pdf",
    icon: "pi pi-exclamation-triangle"
  },
  {
    label: "📊 Inventario Total",
    query: "stock total por almacén y categoría",
    format: "excel",
    icon: "pi pi-chart-bar"
  }
];

// Usar en el componente
{QUICK_REPORTS.map(report => (
  <button 
    key={report.label}
    onClick={() => generateReport(report.query, report.format)}
  >
    <i className={report.icon}></i>
    {report.label}
  </button>
))}
```

---

## ⚠️ Notas Importantes

1. **Endpoints viejos siguen funcionando** (por compatibilidad temporal)
   - `/api/reports/products.csv`
   - `/api/reports/movements.csv`
   
2. **Se recomienda migrar** al nuevo sistema lo antes posible

3. **Rate Limits**: El nuevo endpoint tiene límites según plan (5/50/200 reportes/día)

4. **Caché**: Considera implementar caché en frontend para reportes frecuentes

---

## 📚 Documentación Completa

- **API Docs**: `docs/API_REPORTS_AI.md`
- **Ejemplos**: `docs/EJEMPLOS_FRONTEND.js`
- **Backend**: `app/controllers/report_ai_controller.py`
