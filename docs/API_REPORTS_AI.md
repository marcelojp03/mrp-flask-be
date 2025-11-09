# 📊 API de Reportes con IA - Documentación para Frontend

## Endpoint Principal

### POST `/api/reports/nl`

Genera reportes dinámicos usando lenguaje natural. La IA convierte tu pregunta en SQL, ejecuta la consulta y devuelve resultados con interpretación en lenguaje natural.

---

## 🔐 Autenticación

```javascript
headers: {
  'Authorization': `Bearer ${token}`,
  'Content-Type': 'application/json'
}
```

---

## 📥 Request Body

```typescript
{
  query: string;           // Pregunta en lenguaje natural (REQUERIDO)
  format?: string;         // 'json' | 'csv' | 'excel' | 'pdf' (default: 'json')
  limit?: number;          // Máximo de filas (default: 100)
  dry_run?: boolean;       // Solo genera SQL sin ejecutar (default: false)
}
```

### Ejemplos de Queries

```javascript
// Consultas simples
"lista de productos activos"
"¿cuántos proveedores tengo?"
"muéstrame los almacenes"

// Agregaciones
"productos por categoría"
"total de stock por almacén"

// Filtros
"productos con stock bajo del mínimo"
"proveedores de la ciudad de Santa Cruz"

// Joins
"productos con su categoría y proveedor"
"movimientos de inventario del último mes"
```

---

## 📤 Response Formats

### 1. JSON (Interactive Display)

**Request:**
```javascript
const response = await fetch('/api/reports/nl', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    query: "lista de productos activos",
    format: "json",
    limit: 10
  })
});

const data = await response.json();
```

**Response:**
```json
{
  "status": "success",
  "message": "OK",
  "data": {
    "sql": "SELECT name, code, description FROM product WHERE org_id = 1 AND status = TRUE LIMIT 10",
    "columns": ["name", "code", "description"],
    "rows": [
      ["Producto A", "PROD-001", "Descripción del producto A"],
      ["Producto B", "PROD-002", "Descripción del producto B"]
    ],
    "interpretation": "Se encontraron 10 productos activos. Los productos incluyen Producto A, Producto B, entre otros. Todos tienen estado activo y pertenecen a la organización.",
    "summary": {
      "total_rows": 10,
      "execution_time_ms": 1250
    },
    "export_options": ["json", "csv", "excel", "pdf"]
  }
}
```

**Uso en Frontend:**
```javascript
// Mostrar interpretación
<p className="interpretation">{data.interpretation}</p>

// Mostrar tabla
<table>
  <thead>
    <tr>
      {data.columns.map(col => <th key={col}>{col}</th>)}
    </tr>
  </thead>
  <tbody>
    {data.rows.map((row, i) => (
      <tr key={i}>
        {row.map((cell, j) => <td key={j}>{cell}</td>)}
      </tr>
    ))}
  </tbody>
</table>

// Botones de exportación
{data.export_options.map(format => (
  <button onClick={() => exportReport(format)}>{format.toUpperCase()}</button>
))}
```

---

### 2. CSV (Comma-Separated Values)

**Request:**
```javascript
const response = await fetch('/api/reports/nl', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    query: "lista de productos",
    format: "csv",
    limit: 100
  })
});

const blob = await response.blob();
const url = window.URL.createObjectURL(blob);
const a = document.createElement('a');
a.href = url;
a.download = `reporte_${new Date().toISOString().split('T')[0]}.csv`;
a.click();
```

**Response:**
```
Content-Type: text/csv; charset=utf-8
Content-Disposition: attachment; filename=report_2025-11-05.csv

name,code,description
Producto A,PROD-001,Descripción del producto A
Producto B,PROD-002,Descripción del producto B
```

---

### 3. Excel (.xlsx)

**Request:**
```javascript
const response = await fetch('/api/reports/nl', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    query: "productos con stock",
    format: "excel",  // o "xlsx"
    limit: 200
  })
});

const blob = await response.blob();
const url = window.URL.createObjectURL(blob);
const a = document.createElement('a');
a.href = url;
a.download = `reporte_${new Date().toISOString().split('T')[0]}.xlsx`;
a.click();
```

**Response:**
```
Content-Type: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
Content-Disposition: attachment; filename=report_2025-11-05.xlsx

[Binary Excel file with styled headers: blue background, white text, bold]
```

**Características del Excel:**
- Headers con fondo azul (#366092) y texto blanco
- Ancho de columnas auto-ajustado
- Formato profesional listo para análisis

---

### 4. PDF (Portable Document Format)

**Request:**
```javascript
const response = await fetch('/api/reports/nl', {
  method: 'POST',
  headers: {
    'Authorization': `Bearer ${token}`,
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    query: "reporte de inventario",
    format: "pdf",
    limit: 50
  })
});

const blob = await response.blob();
const url = window.URL.createObjectURL(blob);
window.open(url);  // Abre en nueva pestaña
// O para descargar:
// const a = document.createElement('a');
// a.href = url;
// a.download = 'reporte.pdf';
// a.click();
```

**Response:**
```
Content-Type: application/pdf
Content-Disposition: attachment; filename=report_2025-11-05.pdf

[Binary PDF with formatted table, title, and date]
```

---

## 🎯 Componente React Completo (Ejemplo)

```tsx
import React, { useState } from 'react';

interface ReportData {
  sql: string;
  columns: string[];
  rows: any[][];
  interpretation: string;
  summary: {
    total_rows: number;
    execution_time_ms: number;
  };
  export_options: string[];
}

export const AIReportGenerator: React.FC = () => {
  const [query, setQuery] = useState('');
  const [loading, setLoading] = useState(false);
  const [data, setData] = useState<ReportData | null>(null);
  const [error, setError] = useState('');

  const generateReport = async (format: string = 'json') => {
    setLoading(true);
    setError('');

    try {
      const response = await fetch('/api/reports/nl', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${localStorage.getItem('token')}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          query,
          format,
          limit: 100
        })
      });

      if (format === 'json') {
        const result = await response.json();
        if (result.status === 'success') {
          setData(result.data);
        } else {
          setError(result.message);
        }
      } else {
        // Para CSV, Excel, PDF: descargar archivo
        const blob = await response.blob();
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        
        const extension = format === 'excel' ? 'xlsx' : format;
        a.download = `reporte_${new Date().toISOString().split('T')[0]}.${extension}`;
        a.click();
        window.URL.revokeObjectURL(url);
      }
    } catch (err) {
      setError('Error al generar el reporte');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="ai-report-generator">
      <h2>📊 Generador de Reportes con IA</h2>
      
      {/* Input */}
      <div className="query-input">
        <textarea
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          placeholder="Escribe tu consulta en lenguaje natural..."
          rows={3}
        />
        <button 
          onClick={() => generateReport('json')} 
          disabled={!query || loading}
        >
          {loading ? 'Generando...' : 'Generar Reporte'}
        </button>
      </div>

      {/* Error */}
      {error && (
        <div className="error-message">{error}</div>
      )}

      {/* Results */}
      {data && (
        <div className="results">
          {/* Interpretación en lenguaje natural */}
          <div className="interpretation">
            <h3>💬 Análisis</h3>
            <p>{data.interpretation}</p>
          </div>

          {/* Estadísticas */}
          <div className="summary">
            <span>📊 {data.summary.total_rows} filas</span>
            <span>⏱️ {data.summary.execution_time_ms}ms</span>
          </div>

          {/* Botones de exportación */}
          <div className="export-buttons">
            {data.export_options.map(format => (
              <button 
                key={format}
                onClick={() => generateReport(format)}
                className={`export-btn export-${format}`}
              >
                {format === 'json' && '📋 JSON'}
                {format === 'csv' && '📄 CSV'}
                {format === 'excel' && '📊 Excel'}
                {format === 'pdf' && '📕 PDF'}
              </button>
            ))}
          </div>

          {/* Tabla de datos */}
          <div className="data-table">
            <table>
              <thead>
                <tr>
                  {data.columns.map(col => (
                    <th key={col}>{col}</th>
                  ))}
                </tr>
              </thead>
              <tbody>
                {data.rows.map((row, i) => (
                  <tr key={i}>
                    {row.map((cell, j) => (
                      <td key={j}>{cell}</td>
                    ))}
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {/* SQL generado (colapsable) */}
          <details className="sql-detail">
            <summary>Ver SQL generado</summary>
            <code>{data.sql}</code>
          </details>
        </div>
      )}
    </div>
  );
};
```

---

## 🚨 Manejo de Errores

```typescript
// Rate limit excedido (429)
{
  "status": "error",
  "message": "Límite diario de reportes IA alcanzado para el plan Free (5/día)",
  "data": null
}

// Query inválido (400)
{
  "status": "error",
  "message": "No se pudo ejecutar el reporte: sintaxis inválida",
  "data": null
}

// Sin autenticación (401)
{
  "status": "error",
  "message": "Token sin org_id",
  "data": null
}

// Error de servidor (500)
{
  "status": "error",
  "message": "OpenAI no configurado en el servidor",
  "data": null
}
```

---

## 📊 Límites por Plan (SaaS)

| Plan     | Reportes IA/día |
|----------|----------------|
| Free     | 5              |
| Starter  | 50             |
| Pro      | 200            |

---

## 💡 Consejos de UX

1. **Loading State**: Muestra spinner mientras `loading === true` (la IA tarda 1-4 segundos)

2. **Query Suggestions**: Ofrece ejemplos de consultas comunes:
   ```javascript
   const suggestions = [
     "¿Cuántos productos tengo?",
     "Productos con stock bajo",
     "Lista de proveedores activos",
     "Movimientos de esta semana"
   ];
   ```

3. **Preview antes de exportar**: Siempre muestra primero en JSON, luego permite exportar

4. **Feedback visual**: Muestra `execution_time_ms` y `total_rows` para dar contexto

5. **SQL visible**: Permite ver el SQL generado para usuarios avanzados

6. **Auto-retry**: El backend tiene auto-corrección, pero puedes reintentar en frontend si falla

---

## 🔍 Ejemplos de Uso

### Caso 1: Dashboard - KPIs Rápidos
```javascript
// "¿cuántos productos activos tengo?"
// Mostrar solo el número en un card grande
```

### Caso 2: Análisis - Tabla Completa
```javascript
// "productos con stock, categoría y proveedor"
// Tabla completa con paginación
```

### Caso 3: Export - Descarga Directa
```javascript
// "reporte de inventario completo"
// Botón que descarga Excel directamente
```

### Caso 4: Preview + Export
```javascript
// 1. Ver primero en JSON (5 filas)
// 2. Si está bien, exportar a PDF (todas las filas)
```

---

## ✅ Checklist de Integración

- [ ] Agregar input para query en lenguaje natural
- [ ] Implementar loading state (spinner/skeleton)
- [ ] Mostrar interpretación de resultados
- [ ] Renderizar tabla con columns + rows
- [ ] Agregar botones de exportación (CSV, Excel, PDF)
- [ ] Manejar errores (rate limit, invalid query)
- [ ] Mostrar SQL generado (colapsable)
- [ ] Agregar sugerencias de queries comunes
- [ ] Implementar lógica de descarga de archivos
- [ ] Testear con diferentes tipos de consultas

---

## 🎨 Estilos Sugeridos

```css
.interpretation {
  background: #f0f7ff;
  border-left: 4px solid #366092;
  padding: 16px;
  margin: 16px 0;
  border-radius: 4px;
}

.export-buttons {
  display: flex;
  gap: 8px;
  margin: 16px 0;
}

.export-btn {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.3s;
}

.export-csv { background: #10b981; color: white; }
.export-excel { background: #217346; color: white; }
.export-pdf { background: #dc2626; color: white; }
.export-json { background: #6366f1; color: white; }

.data-table {
  overflow-x: auto;
  margin: 16px 0;
}

.data-table table {
  width: 100%;
  border-collapse: collapse;
}

.data-table th {
  background: #366092;
  color: white;
  padding: 12px;
  text-align: left;
}

.data-table td {
  padding: 10px 12px;
  border-bottom: 1px solid #e5e7eb;
}

.sql-detail {
  margin-top: 16px;
  padding: 12px;
  background: #f9fafb;
  border-radius: 4px;
}

.sql-detail code {
  display: block;
  padding: 12px;
  background: #1f2937;
  color: #10b981;
  border-radius: 4px;
  overflow-x: auto;
  font-family: 'Courier New', monospace;
}
```
