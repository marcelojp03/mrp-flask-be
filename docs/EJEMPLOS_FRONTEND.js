/**
 * 📊 EJEMPLOS PRÁCTICOS - API de Reportes con IA
 * 
 * Ejemplos listos para copiar y pegar en tu aplicación React/Vue/Angular
 */

// ============================================================================
// EJEMPLO 1: Consulta Simple - Mostrar Tabla
// ============================================================================

async function ejemploConsultaSimple() {
  const token = localStorage.getItem('token');
  
  const response = await fetch('http://localhost:4646/api/reports/nl', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      query: "lista de productos activos con su stock",
      format: "json",
      limit: 10
    })
  });

  const result = await response.json();
  
  if (result.status === 'success') {
    console.log('📋 Columnas:', result.data.columns);
    console.log('📊 Datos:', result.data.rows);
    console.log('💬 Interpretación:', result.data.interpretation);
    console.log('⏱️ Tiempo:', result.data.summary.execution_time_ms, 'ms');
  }
}

// ============================================================================
// EJEMPLO 2: Exportar a Excel
// ============================================================================

async function exportarExcel(query) {
  const token = localStorage.getItem('token');
  
  const response = await fetch('http://localhost:4646/api/reports/nl', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      query: query,
      format: "excel",
      limit: 500  // Más filas para export
    })
  });

  // Descargar archivo
  const blob = await response.blob();
  const url = window.URL.createObjectURL(blob);
  const a = document.createElement('a');
  a.href = url;
  a.download = `reporte_${new Date().toISOString().split('T')[0]}.xlsx`;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  window.URL.revokeObjectURL(url);
}

// Uso:
// exportarExcel("productos con stock bajo del mínimo");

// ============================================================================
// EJEMPLO 3: Exportar a PDF
// ============================================================================

async function exportarPDF(query) {
  const token = localStorage.getItem('token');
  
  const response = await fetch('http://localhost:4646/api/reports/nl', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      query: query,
      format: "pdf",
      limit: 100
    })
  });

  // Abrir en nueva pestaña
  const blob = await response.blob();
  const url = window.URL.createObjectURL(blob);
  window.open(url, '_blank');
}

// Uso:
// exportarPDF("reporte de inventario por almacén");

// ============================================================================
// EJEMPLO 4: Función Genérica Reutilizable
// ============================================================================

class AIReportService {
  constructor(baseURL = 'http://localhost:4646') {
    this.baseURL = baseURL;
  }

  async generate(query, format = 'json', limit = 100) {
    const token = localStorage.getItem('token');
    
    const response = await fetch(`${this.baseURL}/api/reports/nl`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ query, format, limit })
    });

    if (format === 'json') {
      return await response.json();
    } else {
      // Para archivos binarios (CSV, Excel, PDF)
      const blob = await response.blob();
      return blob;
    }
  }

  async downloadFile(blob, filename, extension) {
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `${filename}_${new Date().toISOString().split('T')[0]}.${extension}`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    window.URL.revokeObjectURL(url);
  }

  async exportCSV(query, filename = 'reporte') {
    const blob = await this.generate(query, 'csv', 1000);
    await this.downloadFile(blob, filename, 'csv');
  }

  async exportExcel(query, filename = 'reporte') {
    const blob = await this.generate(query, 'excel', 1000);
    await this.downloadFile(blob, filename, 'xlsx');
  }

  async exportPDF(query, filename = 'reporte') {
    const blob = await this.generate(query, 'pdf', 500);
    await this.downloadFile(blob, filename, 'pdf');
  }

  async previewJSON(query, limit = 10) {
    return await this.generate(query, 'json', limit);
  }
}

// Uso:
/*
const reportService = new AIReportService();

// Preview
const data = await reportService.previewJSON("productos activos");
console.log(data.data.interpretation);

// Export
await reportService.exportExcel("productos con stock");
await reportService.exportPDF("reporte de inventario");
*/

// ============================================================================
// EJEMPLO 5: Hook React con TypeScript
// ============================================================================

/*
import { useState } from 'react';

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

interface UseAIReportReturn {
  data: ReportData | null;
  loading: boolean;
  error: string | null;
  generateReport: (query: string, format?: string, limit?: number) => Promise<void>;
  downloadFile: (blob: Blob, filename: string, extension: string) => void;
}

export function useAIReport(baseURL = 'http://localhost:4646'): UseAIReportReturn {
  const [data, setData] = useState<ReportData | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const generateReport = async (query: string, format = 'json', limit = 100) => {
    setLoading(true);
    setError(null);

    try {
      const token = localStorage.getItem('token');
      const response = await fetch(`${baseURL}/api/reports/nl`, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ query, format, limit })
      });

      if (format === 'json') {
        const result = await response.json();
        if (result.status === 'success') {
          setData(result.data);
        } else {
          setError(result.message);
        }
      } else {
        // Para archivos: descargar directamente
        const blob = await response.blob();
        const extension = format === 'excel' ? 'xlsx' : format;
        downloadFile(blob, 'reporte', extension);
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Error desconocido');
    } finally {
      setLoading(false);
    }
  };

  const downloadFile = (blob: Blob, filename: string, extension: string) => {
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `${filename}_${new Date().toISOString().split('T')[0]}.${extension}`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    window.URL.revokeObjectURL(url);
  };

  return { data, loading, error, generateReport, downloadFile };
}

// Uso en componente:
export function AIReportComponent() {
  const { data, loading, error, generateReport } = useAIReport();
  const [query, setQuery] = useState('');

  return (
    <div>
      <input 
        value={query} 
        onChange={(e) => setQuery(e.target.value)}
        placeholder="Escribe tu consulta..."
      />
      
      <button onClick={() => generateReport(query)}>
        Generar
      </button>
      
      {loading && <p>Cargando...</p>}
      {error && <p className="error">{error}</p>}
      
      {data && (
        <div>
          <p>{data.interpretation}</p>
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
          
          <div>
            <button onClick={() => generateReport(query, 'csv')}>📄 CSV</button>
            <button onClick={() => generateReport(query, 'excel')}>📊 Excel</button>
            <button onClick={() => generateReport(query, 'pdf')}>📕 PDF</button>
          </div>
        </div>
      )}
    </div>
  );
}
*/

// ============================================================================
// EJEMPLO 6: Vue 3 Composition API
// ============================================================================

/*
import { ref } from 'vue';

export function useAIReport() {
  const data = ref(null);
  const loading = ref(false);
  const error = ref(null);

  const generateReport = async (query, format = 'json', limit = 100) => {
    loading.value = true;
    error.value = null;

    try {
      const token = localStorage.getItem('token');
      const response = await fetch('http://localhost:4646/api/reports/nl', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ query, format, limit })
      });

      if (format === 'json') {
        const result = await response.json();
        if (result.status === 'success') {
          data.value = result.data;
        } else {
          error.value = result.message;
        }
      } else {
        const blob = await response.blob();
        const extension = format === 'excel' ? 'xlsx' : format;
        downloadFile(blob, 'reporte', extension);
      }
    } catch (err) {
      error.value = err.message;
    } finally {
      loading.value = false;
    }
  };

  const downloadFile = (blob, filename, extension) => {
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `${filename}_${new Date().toISOString().split('T')[0]}.${extension}`;
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    window.URL.revokeObjectURL(url);
  };

  return { data, loading, error, generateReport };
}
*/

// ============================================================================
// EJEMPLO 7: Queries Comunes Pre-definidas
// ============================================================================

const COMMON_QUERIES = {
  // Inventario
  productosActivos: "lista de productos activos con su stock actual",
  stockBajo: "productos con stock por debajo del mínimo",
  inventarioPorAlmacen: "stock total por almacén",
  productosSinStock: "productos con stock en cero",
  
  // Proveedores
  proveedoresActivos: "lista de proveedores activos con sus datos de contacto",
  productosPorProveedor: "productos agrupados por proveedor",
  
  // Categorías
  productosPorCategoria: "cantidad de productos por categoría",
  categoriasActivas: "categorías activas con sus productos",
  
  // Movimientos
  movimientosRecientes: "últimos 20 movimientos de inventario",
  entradasSemana: "entradas de inventario de esta semana",
  salidasSemana: "salidas de inventario de esta semana",
  
  // Análisis
  topProductos: "top 10 productos con más stock",
  resumenInventario: "resumen total de inventario: productos, stock total, valor",
  almacenesConMasProductos: "almacenes ordenados por cantidad de productos"
};

// Uso:
/*
const reportService = new AIReportService();

// Generar reporte predefinido
const data = await reportService.previewJSON(COMMON_QUERIES.stockBajo);

// O crear botones de acceso rápido:
<button onClick={() => generateReport(COMMON_QUERIES.productosActivos)}>
  Stock Actual
</button>
<button onClick={() => generateReport(COMMON_QUERIES.stockBajo)}>
  Alertas Stock Bajo
</button>
*/

// ============================================================================
// EJEMPLO 8: Manejo de Errores Completo
// ============================================================================

async function generateReportWithErrorHandling(query) {
  const token = localStorage.getItem('token');
  
  try {
    const response = await fetch('http://localhost:4646/api/reports/nl', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        query: query,
        format: "json",
        limit: 100
      })
    });

    const result = await response.json();

    // Manejo específico por código de estado
    switch (response.status) {
      case 200:
        if (result.status === 'success') {
          console.log('✅ Reporte generado:', result.data);
          return result.data;
        }
        break;
      
      case 400:
        console.error('❌ Query inválido:', result.message);
        alert('La consulta no pudo ejecutarse. Intenta reformularla.');
        break;
      
      case 401:
        console.error('🔒 No autorizado');
        alert('Sesión expirada. Por favor inicia sesión nuevamente.');
        window.location.href = '/login';
        break;
      
      case 429:
        console.error('⏱️ Rate limit excedido:', result.message);
        alert('Has alcanzado el límite de reportes diarios. Mejora tu plan para continuar.');
        break;
      
      case 500:
        console.error('💥 Error del servidor:', result.message);
        alert('Error del servidor. Por favor intenta más tarde.');
        break;
      
      default:
        console.error('❓ Error desconocido:', response.status);
        alert('Ocurrió un error inesperado.');
    }
  } catch (error) {
    console.error('🌐 Error de red:', error);
    alert('No se pudo conectar con el servidor. Verifica tu conexión.');
  }
}

// ============================================================================
// EJEMPLO 9: Dry Run (Validar SQL sin ejecutar)
// ============================================================================

async function validarQuery(query) {
  const token = localStorage.getItem('token');
  
  const response = await fetch('http://localhost:4646/api/reports/nl', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      query: query,
      dry_run: true  // Solo genera SQL, no ejecuta
    })
  });

  const result = await response.json();
  
  if (result.status === 'success') {
    console.log('📝 SQL generado:', result.data.sql);
    return result.data.sql;
  } else {
    console.log('❌ Query inválido:', result.message);
    return null;
  }
}

// Uso:
/*
const sql = await validarQuery("productos activos");
if (sql) {
  console.log("SQL válido:", sql);
  // Ahora ejecutar con dry_run=false
}
*/

// ============================================================================
// EJEMPLO 10: Progressive Enhancement (Preview → Export)
// ============================================================================

async function flujoCompletoReporte(query) {
  console.log('📊 Paso 1: Preview con 5 filas...');
  
  // 1. Mostrar preview pequeño
  const preview = await new AIReportService().previewJSON(query, 5);
  
  if (!preview || preview.status !== 'success') {
    console.error('Error en preview');
    return;
  }
  
  console.log('✅ Preview OK:', preview.data.interpretation);
  console.log('📋 Filas:', preview.data.summary.total_rows);
  
  // 2. Preguntar al usuario si quiere exportar
  const exportar = confirm(`Se encontraron ${preview.data.summary.total_rows} resultados. ¿Deseas exportar a Excel?`);
  
  if (exportar) {
    console.log('📥 Paso 2: Exportando todas las filas...');
    await new AIReportService().exportExcel(query, 'reporte_completo');
    console.log('✅ Archivo descargado');
  }
}

// Uso:
// flujoCompletoReporte("productos con stock y proveedor");

// ============================================================================
// RESUMEN DE USO
// ============================================================================

console.log(`
📊 GUÍA RÁPIDA DE USO:

1. Importa AIReportService o useAIReport
2. Haz consultas en lenguaje natural
3. Recibe datos con interpretación en JSON
4. Exporta a CSV/Excel/PDF según necesites

QUERIES DE EJEMPLO:
- "¿cuántos productos tengo?"
- "lista de productos activos"
- "stock por almacén"
- "proveedores de Santa Cruz"
- "movimientos del último mes"

FORMATOS:
- json: Para mostrar en pantalla (con interpretación)
- csv: Descarga simple
- excel: Descarga con formato (headers azules)
- pdf: Reporte profesional

¡Listo para usar! 🚀
`);
