# 📊 GUÍA RÁPIDA - Endpoints Dashboard y Stocks

## Para el equipo Frontend

### 🎯 GET `/api/dashboard/kpis`

**Uso:** Dashboard principal, tarjetas de KPIs

**Request:**
```typescript
const token = localStorage.getItem('access_token');

this.http.get('http://localhost:4646/api/dashboard/kpis', {
  headers: { 'Authorization': `Bearer ${token}` }
})
```

**Response:**
```json
{
  "success": true,
  "data": {
    "total_products": 10,          // int - Total productos activos
    "low_stock_count": 4,          // int - Productos con stock bajo
    "movements_today": 0,          // int - Movimientos registrados hoy
    "work_orders_active": 0,       // int - OPs en estado "En Progreso"
    "work_orders_finished_today": 0, // int - OPs finalizadas hoy
    "materials_consumed_today": 0.0  // float - Materiales consumidos (kg/m/etc)
  }
}
```

**Componentes sugeridos:**
```typescript
interface DashboardKPIs {
  total_products: number;
  low_stock_count: number;
  movements_today: number;
  work_orders_active: number;
  work_orders_finished_today: number;
  materials_consumed_today: number;
}

// En el componente
kpis: DashboardKPIs;

loadKPIs() {
  this.dashboardService.getKPIs().subscribe((response: any) => {
    this.kpis = response.data;
  });
}
```

**Tarjetas HTML sugeridas:**
```html
<div class="kpi-card">
  <h3>Productos</h3>
  <p class="value">{{ kpis.total_products }}</p>
</div>

<div class="kpi-card alert" *ngIf="kpis.low_stock_count > 0">
  <h3>Stock Bajo</h3>
  <p class="value">{{ kpis.low_stock_count }}</p>
  <small>productos requieren reorden</small>
</div>

<div class="kpi-card">
  <h3>Movimientos Hoy</h3>
  <p class="value">{{ kpis.movements_today }}</p>
</div>

<div class="kpi-card production">
  <h3>OPs Activas</h3>
  <p class="value">{{ kpis.work_orders_active }}</p>
  <small>en producción</small>
</div>

<div class="kpi-card production">
  <h3>Finalizadas Hoy</h3>
  <p class="value">{{ kpis.work_orders_finished_today }}</p>
</div>

<div class="kpi-card production">
  <h3>Materiales Consumidos</h3>
  <p class="value">{{ kpis.materials_consumed_today | number:'1.2-2' }}</p>
  <small>unidades</small>
</div>
```

---

### ⚠️ GET `/api/stocks/low`

**Uso:** Lista de productos con stock bajo, tabla de alertas

**Request:**
```typescript
const token = localStorage.getItem('access_token');

this.http.get('http://localhost:4646/api/stocks/low', {
  headers: { 'Authorization': `Bearer ${token}` }
})
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 10,
      "code": "CON-DISQ",
      "name": "Discos de corte",
      "description": "Consumible esmeril",
      "item_type": "CONSUMABLE",        // RM | FG | CONSUMABLE
      "procurement_type": "BUY",        // BUY | MAKE
      "current_stock": 20.0,
      "min_stock": 25.0,
      "unit_code": "BOX",
      "unit_id": 5,
      "org_id": 1,
      "status": true
    },
    {
      "id": 7,
      "code": "FG-MESA",
      "name": "Mesa Premium",
      "item_type": "FG",
      "procurement_type": "MAKE",
      "current_stock": 15.0,
      "min_stock": 20.0,
      "unit_code": "EA",
      "unit_id": 1
    }
  ]
}
```

**Interface TypeScript:**
```typescript
interface LowStockProduct {
  id: number;
  code: string;
  name: string;
  description: string;
  item_type: 'RM' | 'FG' | 'CONSUMABLE';
  procurement_type: 'BUY' | 'MAKE';
  current_stock: number;
  min_stock: number;
  unit_code: string;
  unit_id: number;
  org_id: number;
  status: boolean;
}

// En el componente
lowStockProducts: LowStockProduct[] = [];

loadLowStock() {
  this.stockService.getLowStock().subscribe((response: any) => {
    this.lowStockProducts = response.data;
  });
}

// Calcular déficit
getDeficit(product: LowStockProduct): number {
  return product.min_stock - product.current_stock;
}

// Badge de tipo
getTypeBadge(type: string): string {
  const badges = {
    'RM': 'Materia Prima',
    'FG': 'Producto Terminado',
    'CONSUMABLE': 'Consumible'
  };
  return badges[type] || type;
}

// Badge de acción
getActionBadge(procurement: string): string {
  return procurement === 'BUY' ? 'Comprar' : 'Producir';
}
```

**Tabla HTML sugerida:**
```html
<table class="low-stock-table">
  <thead>
    <tr>
      <th>Código</th>
      <th>Producto</th>
      <th>Tipo</th>
      <th>Stock Actual</th>
      <th>Stock Mínimo</th>
      <th>Déficit</th>
      <th>Acción</th>
    </tr>
  </thead>
  <tbody>
    <tr *ngFor="let product of lowStockProducts" class="alert-row">
      <td><code>{{ product.code }}</code></td>
      <td>
        <strong>{{ product.name }}</strong>
        <small>{{ product.description }}</small>
      </td>
      <td>
        <span class="badge" [class.badge-rm]="product.item_type === 'RM'"
                             [class.badge-fg]="product.item_type === 'FG'">
          {{ getTypeBadge(product.item_type) }}
        </span>
      </td>
      <td class="text-danger">
        {{ product.current_stock | number:'1.2-2' }} {{ product.unit_code }}
      </td>
      <td>
        {{ product.min_stock | number:'1.2-2' }} {{ product.unit_code }}
      </td>
      <td class="text-danger">
        <strong>-{{ getDeficit(product) | number:'1.2-2' }}</strong>
      </td>
      <td>
        <button *ngIf="product.procurement_type === 'BUY'" 
                class="btn-buy"
                (click)="createPurchaseOrder(product)">
          🛒 Comprar
        </button>
        <button *ngIf="product.procurement_type === 'MAKE'" 
                class="btn-make"
                (click)="createWorkOrder(product)">
          🏭 Producir
        </button>
      </td>
    </tr>
  </tbody>
</table>

<div *ngIf="lowStockProducts.length === 0" class="no-data">
  ✅ Todos los productos tienen stock suficiente
</div>
```

**Estilos CSS sugeridos:**
```css
.alert-row {
  background-color: #fff3cd;
  border-left: 4px solid #ffc107;
}

.text-danger {
  color: #dc3545;
  font-weight: bold;
}

.badge {
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 0.85em;
}

.badge-rm { background: #17a2b8; color: white; }
.badge-fg { background: #28a745; color: white; }

.btn-buy {
  background: #007bff;
  color: white;
  border: none;
  padding: 6px 12px;
  border-radius: 4px;
  cursor: pointer;
}

.btn-make {
  background: #ffc107;
  color: #000;
  border: none;
  padding: 6px 12px;
  border-radius: 4px;
  cursor: pointer;
}
```

---

### 📋 GET `/api/stocks/reorder-suggestions`

**Uso:** Sugerencias inteligentes de reorden, órdenes de compra automáticas

**Request:**
```typescript
const token = localStorage.getItem('access_token');

this.http.get('http://localhost:4646/api/stocks/reorder-suggestions', {
  headers: { 'Authorization': `Bearer ${token}` }
})
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "product_id": 10,
      "code": "CON-DISQ",
      "name": "Discos de corte",
      "current_stock": 20.0,
      "min_stock": 25.0,
      "suggested_qty": 20.0,           // Cantidad sugerida a ordenar
      "supplier_id": 4,                // ID del proveedor (null si no tiene)
      "lead_time_days": 2,             // Días de entrega (null si no tiene)
      "hint": "Comprar con ~2 días de anticipación"  // Sugerencia (null si no tiene proveedor)
    },
    {
      "product_id": 6,
      "code": "RM-MAD",
      "name": "Madera Cedro",
      "current_stock": 0.0,
      "min_stock": 80.0,
      "suggested_qty": 80.0,
      "supplier_id": 5,
      "lead_time_days": 6,
      "hint": "Comprar con ~6 días de anticipación"
    },
    {
      "product_id": 7,
      "code": "FG-MESA",
      "name": "Mesa Premium",
      "current_stock": 15.0,
      "min_stock": 20.0,
      "suggested_qty": 5.0,
      "supplier_id": null,             // Sin proveedor asignado
      "lead_time_days": null,
      "hint": null
    }
  ]
}
```

**Interface TypeScript:**
```typescript
interface ReorderSuggestion {
  product_id: number;
  code: string;
  name: string;
  current_stock: number;
  min_stock: number;
  suggested_qty: number;
  supplier_id: number | null;
  lead_time_days: number | null;
  hint: string | null;
}

// En el componente
suggestions: ReorderSuggestion[] = [];
withSupplier: ReorderSuggestion[] = [];
withoutSupplier: ReorderSuggestion[] = [];

loadSuggestions() {
  this.stockService.getReorderSuggestions().subscribe((response: any) => {
    this.suggestions = response.data;
    
    // Separar sugerencias con y sin proveedor
    this.withSupplier = this.suggestions.filter(s => s.supplier_id !== null);
    this.withoutSupplier = this.suggestions.filter(s => s.supplier_id === null);
  });
}

// Calcular fecha de entrega esperada
calculateDeliveryDate(leadTimeDays: number | null): string {
  if (!leadTimeDays) return '';
  
  const date = new Date();
  date.setDate(date.getDate() + leadTimeDays);
  return date.toISOString().split('T')[0];
}

// Crear orden de compra automática
createPurchaseOrder(suggestion: ReorderSuggestion) {
  if (!suggestion.supplier_id) {
    this.showError('Este producto no tiene proveedor asignado');
    return;
  }
  
  const order = {
    supplier_id: suggestion.supplier_id,
    items: [{
      product_id: suggestion.product_id,
      quantity: suggestion.suggested_qty
    }],
    expected_delivery: this.calculateDeliveryDate(suggestion.lead_time_days)
  };
  
  this.purchaseService.create(order).subscribe(
    () => this.showSuccess('Orden de compra creada'),
    err => this.showError('Error al crear orden')
  );
}
```

**Tabla HTML sugerida:**
```html
<h3>✅ Con Proveedor Asignado ({{ withSupplier.length }})</h3>
<table class="suggestions-table">
  <thead>
    <tr>
      <th>Código</th>
      <th>Producto</th>
      <th>Stock Actual</th>
      <th>Cantidad a Ordenar</th>
      <th>Lead Time</th>
      <th>Sugerencia</th>
      <th>Acciones</th>
    </tr>
  </thead>
  <tbody>
    <tr *ngFor="let suggestion of withSupplier">
      <td><code>{{ suggestion.code }}</code></td>
      <td><strong>{{ suggestion.name }}</strong></td>
      <td class="text-warning">
        {{ suggestion.current_stock | number:'1.2-2' }}
      </td>
      <td class="text-primary">
        <strong>{{ suggestion.suggested_qty | number:'1.2-2' }}</strong>
      </td>
      <td>
        <span class="badge badge-info">
          {{ suggestion.lead_time_days }} días
        </span>
      </td>
      <td>
        <small class="text-muted">{{ suggestion.hint }}</small>
      </td>
      <td>
        <button class="btn-create-po" 
                (click)="createPurchaseOrder(suggestion)">
          📄 Crear Orden
        </button>
      </td>
    </tr>
  </tbody>
</table>

<h3 class="mt-4">⚠️ Sin Proveedor Asignado ({{ withoutSupplier.length }})</h3>
<table class="suggestions-table">
  <thead>
    <tr>
      <th>Código</th>
      <th>Producto</th>
      <th>Stock Actual</th>
      <th>Cantidad a Ordenar</th>
      <th>Acciones</th>
    </tr>
  </thead>
  <tbody>
    <tr *ngFor="let suggestion of withoutSupplier" class="warning-row">
      <td><code>{{ suggestion.code }}</code></td>
      <td><strong>{{ suggestion.name }}</strong></td>
      <td class="text-danger">
        {{ suggestion.current_stock | number:'1.2-2' }}
      </td>
      <td class="text-primary">
        <strong>{{ suggestion.suggested_qty | number:'1.2-2' }}</strong>
      </td>
      <td>
        <button class="btn-assign-supplier" 
                (click)="assignSupplier(suggestion.product_id)">
          🔗 Asignar Proveedor
        </button>
      </td>
    </tr>
  </tbody>
</table>

<div *ngIf="suggestions.length === 0" class="no-data">
  ✅ No hay productos que requieran reorden
</div>
```

**Estilos CSS adicionales:**
```css
.suggestions-table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 2rem;
}

.suggestions-table th {
  background: #f8f9fa;
  padding: 12px;
  text-align: left;
  border-bottom: 2px solid #dee2e6;
}

.suggestions-table td {
  padding: 10px 12px;
  border-bottom: 1px solid #dee2e6;
}

.warning-row {
  background-color: #fff3cd;
}

.text-warning {
  color: #ffc107;
}

.text-primary {
  color: #007bff;
  font-weight: bold;
}

.badge-info {
  background: #17a2b8;
  color: white;
  padding: 4px 8px;
  border-radius: 4px;
  font-size: 0.85em;
}

.btn-create-po {
  background: #28a745;
  color: white;
  border: none;
  padding: 6px 12px;
  border-radius: 4px;
  cursor: pointer;
}

.btn-assign-supplier {
  background: #ffc107;
  color: #000;
  border: none;
  padding: 6px 12px;
  border-radius: 4px;
  cursor: pointer;
}

.mt-4 {
  margin-top: 2rem;
}
```

---

## 🔐 IMPORTANTE: Autenticación

**TODOS** estos endpoints requieren token JWT:

```typescript
// En cada petición HTTP
headers: { 'Authorization': `Bearer ${token}` }
```

**Mejor práctica:** Crear un HTTP Interceptor que agregue el token automáticamente:

```typescript
// auth.interceptor.ts
@Injectable()
export class AuthInterceptor implements HttpInterceptor {
  intercept(req: HttpRequest<any>, next: HttpHandler) {
    const token = localStorage.getItem('access_token');
    
    if (token) {
      const cloned = req.clone({
        headers: req.headers.set('Authorization', `Bearer ${token}`)
      });
      return next.handle(cloned);
    }
    
    return next.handle(req);
  }
}
```

---

## 📝 Checklist de Implementación

### Dashboard Component
- [ ] Crear interface `DashboardKPIs`
- [ ] Servicio `getDashboardKPIs()` con headers
- [ ] 6 tarjetas de KPIs en el HTML
- [ ] Auto-refresh cada 30 segundos (opcional)
- [ ] Mostrar alerta si `low_stock_count > 0`

### Low Stock Component
- [ ] Crear interface `LowStockProduct`
- [ ] Servicio `getLowStock()` con headers
- [ ] Tabla con todas las columnas
- [ ] Botones de acción (Comprar/Producir)
- [ ] Badge de tipo de producto
- [ ] Cálculo de déficit
- [ ] Mensaje cuando no hay productos con stock bajo

### Interceptor
- [ ] Crear `auth.interceptor.ts`
- [ ] Registrar en `app.module.ts`
- [ ] Verificar que todas las peticiones incluyan token

---

## ✅ Testing

Probar en consola del navegador:

```javascript
// 1. Login
fetch('http://localhost:4646/api/auth/login', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ email: 'marcelojp03@gmail.com', password: 'mrp123' })
})
.then(r => r.json())
.then(d => {
  const token = d.data.access_token;
  localStorage.setItem('access_token', token);
  console.log('Token guardado:', token);
});

// 2. Dashboard KPIs
const token = localStorage.getItem('access_token');
fetch('http://localhost:4646/api/dashboard/kpis', {
  headers: { 'Authorization': `Bearer ${token}` }
})
.then(r => r.json())
.then(d => console.log('KPIs:', d.data));

// 3. Low Stock
fetch('http://localhost:4646/api/stocks/low', {
  headers: { 'Authorization': `Bearer ${token}` }
})
.then(r => r.json())
.then(d => console.log('Stock bajo:', d.data));
```
