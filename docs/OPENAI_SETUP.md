# Configuración de OpenAI para Reportes con IA

## 🔧 Configuración Requerida

El endpoint `/api/reports/nl` requiere OpenAI para generar SQL desde lenguaje natural.

### 1. Obtener API Key de OpenAI

1. Ir a https://platform.openai.com/api-keys
2. Crear una nueva API key
3. Copiar la key (empieza con `sk-...`)

### 2. Configurar Variables de Entorno

**Windows (PowerShell):**
```powershell
# Temporal (solo para la sesión actual)
$env:OPENAI_API_KEY="sk-proj-tu-api-key-aqui"
$env:LLM_MODEL="gpt-4o-mini"  # Opcional, por defecto usa gpt-4o-mini

# Permanente (agregar al perfil de PowerShell)
[System.Environment]::SetEnvironmentVariable('OPENAI_API_KEY', 'sk-proj-tu-key', 'User')
```

**Windows (CMD):**
```cmd
set OPENAI_API_KEY=sk-proj-tu-api-key-aqui
set LLM_MODEL=gpt-4o-mini
```

**Linux/Mac:**
```bash
export OPENAI_API_KEY="sk-proj-tu-api-key-aqui"
export LLM_MODEL="gpt-4o-mini"  # Opcional
```

### 3. Reiniciar el servidor Flask

```powershell
# Detener servidor (Ctrl+C)
python run.py
```

---

## 💰 Costos de OpenAI

**Modelo gpt-4o-mini (recomendado):**
- Input: $0.150 / 1M tokens
- Output: $0.600 / 1M tokens

**Estimación por reporte:**
- Prompt típico: ~2,000 tokens
- Respuesta típica: ~200 tokens
- **Costo por reporte: ~$0.0005 USD (medio centavo)**

**Para 1000 reportes/mes:** ~$0.50 USD

---

## 🔒 Límites por Plan (SaasGuard)

El sistema tiene límites diarios de reportes IA según el plan:

| Plan | Reportes IA/día | Costo mensual estimado |
|------|-----------------|------------------------|
| Free | 5 | $0.075 (~7 centavos) |
| Starter | 50 | $0.75 |
| Pro | 200 | $3.00 |

---

## 🧪 Probar la Configuración

```powershell
# Verificar que la variable esté configurada
echo $env:OPENAI_API_KEY

# Ejecutar test
python test_nl_endpoint.py
```

**Resultado esperado:**
```json
{
  "success": true,
  "data": {
    "sql": "SELECT COUNT(*) FROM product WHERE org_id = :org_id AND status = true LIMIT 100",
    "columns": ["count"],
    "rows": [[10]]
  },
  "message": "OK"
}
```

---

## 🚫 Alternativa: Deshabilitar Función (Sin IA)

Si **NO** quieres usar OpenAI, puedes:

1. **Ocultar botón/feature en el frontend** (no llamar al endpoint)
2. **Usar solo reportes CSV predefinidos** (`/api/reports/products.csv`, etc.)
3. **Implementar reportes SQL predefinidos** (crear nuevos endpoints con consultas hardcodeadas)

El sistema funcionará perfectamente sin esta feature, solo perderás la capacidad de generar reportes dinámicos con lenguaje natural.

---

## 📚 Documentación del Endpoint

**Endpoint:** `POST /api/reports/nl`

**Request:**
```json
{
  "query": "¿cuántos productos tengo en el almacén principal?",
  "format": "json",  // o "csv"
  "dry_run": false,  // true para solo ver el SQL generado
  "limit": 100       // máximo de filas a retornar
}
```

**Response Exitoso:**
```json
{
  "success": true,
  "data": {
    "sql": "SELECT COUNT(*) FROM product WHERE org_id = :org_id",
    "columns": ["count"],
    "rows": [[25]]
  },
  "message": "OK"
}
```

**Errores Posibles:**
- `500`: "OpenAI no configurado en el servidor" → Falta API key
- `429`: "Límite diario de reportes alcanzado" → SaasGuard bloqueó
- `400`: "Falta 'query'" → Request inválido
- `401`: "Token sin org_id" → Token JWT inválido

---

## 🔐 Seguridad

El sistema tiene múltiples capas de seguridad:

1. **Solo SELECT permitido**: La IA solo puede generar SELECT
2. **Filtrado org_id**: Todas las consultas incluyen filtro por organización
3. **Read-only**: Se ejecuta en transacción de solo lectura
4. **Whitelist de tablas**: Solo accede a tablas permitidas
5. **Rate limiting**: Límite diario según plan (SaasGuard)
6. **Auditoría**: Todas las consultas se registran en `system_log`

---

## 📝 Ejemplo de Uso desde Frontend

```typescript
// Angular
generateReport(query: string) {
  const body = {
    query: query,
    format: 'json',
    dry_run: false
  };
  
  this.http.post('http://localhost:4646/api/reports/nl', body, {
    headers: { Authorization: `Bearer ${this.token}` }
  }).subscribe({
    next: (response: any) => {
      console.log('SQL generado:', response.data.sql);
      console.log('Resultados:', response.data.rows);
      this.displayResults(response.data);
    },
    error: (err) => {
      if (err.status === 500 && err.error.message.includes('OpenAI')) {
        alert('Función de IA no disponible. Contacte al administrador.');
      } else if (err.status === 429) {
        alert('Límite diario de reportes alcanzado');
      }
    }
  });
}
```

---

**Creado:** Noviembre 2025  
**Actualizado:** Sprint 2
