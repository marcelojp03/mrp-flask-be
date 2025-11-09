# 📋 RECOMENDACIONES: ROLES, USUARIOS Y REPORTES DE PRODUCCIÓN

## 🎯 RESUMEN DE DUDAS

### 1️⃣ **Recursos/ACL** - ❌ ELIMINADO
**Decisión:** Subrecurso eliminado porque los recursos son estáticos (fixtures del sistema).  
No tiene sentido una pantalla para administrar algo que no puede modificarse.

### 2️⃣ **Roles** - ¿Cómo se gestionan si los recursos son fijos?
### 3️⃣ **Usuarios** - ¿Cómo se asignan roles?
### 4️⃣ **Reportes Producción** - ¿Qué mostrar sin endpoint?

---

## ~~1️⃣ RECURSOS/ACL (`/dashboard/acl`)~~ ❌ ELIMINADO

**ESTADO:** Este subrecurso ha sido eliminado de los seeds.

**Razón:** Los recursos y subrecursos son fixtures estáticas del sistema definidas en SQL.  
No pueden ser creadas, editadas o eliminadas por usuarios, por lo que una pantalla de administración es innecesaria.

**Alternativa:** Si los administradores necesitan ver la estructura de permisos:
- Usar directamente la pantalla de **Roles** donde pueden ver qué permisos (subrecursos) están asignados
- La pantalla de **Usuarios** muestra los roles asignados a cada usuario

---

## 2️⃣ ROLES (`/dashboard/roles`)

### 🔍 Propósito
Gestión de roles con asignación de permisos basados en los recursos fijos del sistema.

### 📦 Componentes Necesarios

#### A) **Lista de Roles** (DataTable)
```tsx
interface Role {
  id: number;
  name: string;
  description: string;
  status: boolean;
  permissionsCount: number; // Cantidad de subrecursos asignados
}

<DataTable value={roles}>
  <Column field="name" header="Rol" />
  <Column field="description" header="Descripción" />
  <Column field="permissionsCount" header="Permisos" />
  <Column field="status" header="Estado" body={statusBadge} />
  <Column body={actionButtons} />
</DataTable>
```

#### B) **Formulario Crear/Editar Rol**

**Campos básicos:**
```tsx
- Nombre (texto)
- Descripción (textarea)
- Estado (switch activo/inactivo)
```

**Asignación de permisos** (Componente clave):
```tsx
// Opción 1: Lista con Checkboxes
<div className="permissions-grid">
  {resources.map(resource => (
    <Card key={resource.id} title={resource.name}>
      {resource.subresources.map(sub => (
        <div className="field-checkbox" key={sub.id}>
          <Checkbox
            inputId={`perm-${sub.id}`}
            checked={selectedPermissions.includes(sub.id)}
            onChange={(e) => togglePermission(sub.id)}
          />
          <label htmlFor={`perm-${sub.id}`}>
            {sub.name} - {sub.description}
          </label>
        </div>
      ))}
    </Card>
  ))}
</div>

// Opción 2: PickList (más visual)
<PickList
  source={availablePermissions}
  target={assignedPermissions}
  onChange={handlePermissionChange}
  itemTemplate={permissionTemplate}
  sourceHeader="Disponibles"
  targetHeader="Asignados"
/>
```

#### 🔌 Endpoints Necesarios

**Ya existen:**
```bash
GET    /api/roles              # Lista todos los roles
POST   /api/roles              # Crear nuevo rol
PUT    /api/roles/:id          # Actualizar rol
DELETE /api/roles/:id          # Eliminar rol

GET    /api/role-resources     # Ver permisos de roles
POST   /api/role-resources     # Asignar permiso a rol
DELETE /api/role-resources/:role_id/:resource_id/:subresource_id  # Quitar permiso
```

**Endpoint adicional recomendado:**
```bash
GET /api/roles/:id/permissions  # Obtener todos los permisos de un rol específico
```

#### 🔄 Flujo de Trabajo

1. **Crear Rol**:
   - Llenar nombre/descripción
   - Seleccionar permisos (checkboxes de subrecursos)
   - Guardar → Crea el rol + hace múltiples POST a `/api/role-resources`

2. **Editar Rol**:
   - Cargar rol + permisos actuales
   - Modificar checkboxes
   - Guardar → Actualiza rol + sincroniza permisos (agregar/quitar)

3. **Eliminar Rol**:
   - Verificar que no tenga usuarios asignados
   - Confirmar eliminación
   - DELETE → El backend debe eliminar también los role_resources en CASCADE

---

## 3️⃣ USUARIOS (`/dashboard/users`)

### 🔍 Propósito
ABM de usuarios con asignación de roles existentes.

### 📦 Componentes Necesarios

#### A) **Lista de Usuarios** (DataTable)
```tsx
interface User {
  id: number;
  name: string;
  email: string;
  status: boolean;
  roles: string[]; // ["Admin", "Planner"]
  organization: string;
}

<DataTable value={users}>
  <Column field="name" header="Nombre" />
  <Column field="email" header="Email" />
  <Column field="roles" header="Roles" body={rolesTagsTemplate} />
  <Column field="status" header="Estado" body={statusBadge} />
  <Column body={actionButtons} />
</DataTable>

// Template para mostrar roles como tags
const rolesTagsTemplate = (user) => (
  <div className="flex gap-2">
    {user.roles.map(role => (
      <Tag key={role} value={role} severity="info" />
    ))}
  </div>
);
```

#### B) **Formulario Crear/Editar Usuario**

**Campos:**
```tsx
- Nombre (texto)
- Email (email)
- Contraseña (password, solo en creación)
- Foto (file upload opcional)
- Estado (switch activo/inactivo)
- Roles (MultiSelect)
```

**Asignación de roles:**
```tsx
// Cargar roles disponibles
const [availableRoles, setAvailableRoles] = useState([]);
const [selectedRoles, setSelectedRoles] = useState([]);

// MultiSelect de PrimeReact
<MultiSelect
  value={selectedRoles}
  onChange={(e) => setSelectedRoles(e.value)}
  options={availableRoles}
  optionLabel="name"
  placeholder="Seleccionar roles"
  display="chip"
/>

// Al guardar
const handleSave = async () => {
  // 1. Crear/actualizar usuario
  const user = await createUser({name, email, password, status});
  
  // 2. Asignar roles
  for (const roleId of selectedRoles) {
    await assignRole(user.id, roleId); // POST /api/user-roles
  }
};
```

#### 🔌 Endpoints Necesarios

**Ya existen:**
```bash
GET    /api/users              # Lista usuarios
POST   /api/users              # Crear usuario
PUT    /api/users/:id          # Actualizar usuario
DELETE /api/users/:id          # Eliminar usuario

GET    /api/user-roles         # Ver asignaciones usuario-rol
POST   /api/user-roles         # Asignar rol a usuario
DELETE /api/user-roles/:user_id/:role_id  # Quitar rol de usuario
```

#### 🔄 Flujo de Trabajo

1. **Crear Usuario**:
   ```typescript
   // 1. Crear usuario
   const newUser = await api.post('/api/users', {
     name: 'Juan Pérez',
     email: 'juan@acme.com',
     password: 'temp123',
     status: true
   });
   
   // 2. Asignar roles seleccionados
   for (const roleId of selectedRoleIds) {
     await api.post('/api/user-roles', {
       user_id: newUser.id,
       role_id: roleId
     });
   }
   ```

2. **Editar Usuario**:
   ```typescript
   // 1. Cargar usuario actual con sus roles
   const user = await api.get(`/api/users/${id}`);
   const userRoles = await api.get(`/api/user-roles?user_id=${id}`);
   
   // 2. Actualizar datos básicos
   await api.put(`/api/users/${id}`, updatedData);
   
   // 3. Sincronizar roles (quitar los que ya no están, agregar nuevos)
   const currentRoleIds = userRoles.map(ur => ur.role_id);
   const toRemove = currentRoleIds.filter(rid => !newRoleIds.includes(rid));
   const toAdd = newRoleIds.filter(rid => !currentRoleIds.includes(rid));
   
   for (const roleId of toRemove) {
     await api.delete(`/api/user-roles/${id}/${roleId}`);
   }
   for (const roleId of toAdd) {
     await api.post('/api/user-roles', {user_id: id, role_id: roleId});
   }
   ```

---

## 4️⃣ REPORTES PRODUCCIÓN (`/dashboard/production/reports`)

### 🔍 Problema
Subrecurso existe en el menú pero **NO hay endpoint backend**.

### ✅ SOLUCIÓN: Crear endpoint de reportes de producción

---

### 📊 OPCIÓN A: Dashboard de KPIs (Recomendado)

**Endpoint a crear:**
```python
# app/controllers/work_order_controller.py

@work_order_bp.route('/reports/stats', methods=['GET'])
@auth_required
def get_production_stats():
    """
    Estadísticas de producción
    Query params: ?from=YYYY-MM-DD&to=YYYY-MM-DD
    """
    org_id = g.current_user.org_id
    
    # Filtros de fecha
    date_from = request.args.get('from')
    date_to = request.args.get('to')
    
    query = WorkOrder.query.filter_by(org_id=org_id)
    
    if date_from:
        dt_from = datetime.strptime(date_from, '%Y-%m-%d')
        query = query.filter(WorkOrder.created_at >= dt_from)
    
    if date_to:
        dt_to = datetime.strptime(date_to, '%Y-%m-%d')
        query = query.filter(WorkOrder.created_at <= dt_to)
    
    work_orders = query.all()
    
    # Calcular KPIs
    total = len(work_orders)
    by_status = {}
    for wo in work_orders:
        by_status[wo.status] = by_status.get(wo.status, 0) + 1
    
    # BOMs más utilizadas
    bom_usage = {}
    for wo in work_orders:
        bom_id = wo.bom_id
        bom_usage[bom_id] = bom_usage.get(bom_id, 0) + 1
    
    # Top BOMs
    top_boms = sorted(bom_usage.items(), key=lambda x: x[1], reverse=True)[:5]
    top_boms_data = []
    for bom_id, count in top_boms:
        bom = BOM.query.get(bom_id)
        if bom:
            top_boms_data.append({
                'bom_id': bom_id,
                'product_name': bom.product.name if bom.product else 'N/A',
                'count': count
            })
    
    # Producción por mes (últimos 6 meses)
    # ... (código para agrupar por mes)
    
    return Responses.success({
        'summary': {
            'total_work_orders': total,
            'by_status': by_status,
            'completion_rate': round(
                by_status.get(WorkOrder.STATUS_FINISHED, 0) / total * 100, 2
            ) if total > 0 else 0
        },
        'top_boms': top_boms_data,
        # 'monthly_production': [...],
        # 'avg_completion_time': ...
    })
```

**Componente Frontend:**
```tsx
// ProductionReports.tsx
import { Chart } from 'primereact/chart';
import { Card } from 'primereact/card';

const ProductionReports = () => {
  const [stats, setStats] = useState(null);
  
  useEffect(() => {
    fetchStats();
  }, []);
  
  const fetchStats = async () => {
    const response = await api.get('/api/work-orders/reports/stats');
    setStats(response.data);
  };
  
  return (
    <div className="grid">
      {/* KPIs */}
      <div className="col-12 md:col-4">
        <Card title="Total Órdenes">
          <h2>{stats?.summary.total_work_orders}</h2>
        </Card>
      </div>
      
      <div className="col-12 md:col-4">
        <Card title="Tasa Completitud">
          <h2>{stats?.summary.completion_rate}%</h2>
        </Card>
      </div>
      
      {/* Gráfico: Órdenes por Estado */}
      <div className="col-12 md:col-6">
        <Card title="Órdenes por Estado">
          <Chart type="pie" data={statusChartData} />
        </Card>
      </div>
      
      {/* Tabla: Top BOMs */}
      <div className="col-12 md:col-6">
        <Card title="BOMs Más Producidas">
          <DataTable value={stats?.top_boms}>
            <Column field="product_name" header="Producto" />
            <Column field="count" header="Cantidad Órdenes" />
          </DataTable>
        </Card>
      </div>
    </div>
  );
};
```

---

### 📄 OPCIÓN B: Exportación de Reportes (Complementario)

**Endpoints adicionales:**
```python
@work_order_bp.route('/reports/work-orders.csv', methods=['GET'])
@auth_required
def export_work_orders_csv():
    """Exporta Work Orders a CSV"""
    # Similar a report_controller.py
    # ...
    
@work_order_bp.route('/reports/bom-usage.csv', methods=['GET'])
@auth_required
def export_bom_usage_csv():
    """Exporta uso de BOMs a CSV"""
    # ...
```

**Componente Frontend:**
```tsx
<Button
  label="Exportar Work Orders"
  icon="pi pi-download"
  onClick={() => downloadCSV('/api/work-orders/reports/work-orders.csv')}
/>
```

---

### 📈 OPCIÓN C: Reportes con IA (Ya existe `/api/reports/ai/query`)

**Integración:**
```tsx
// Usar el endpoint existente de reportes con IA
const ProductionReportsAI = () => {
  const askReport = async () => {
    const response = await api.post('/api/reports/ai/query', {
      query: "¿Cuántas órdenes de producción se completaron este mes?"
    });
    
    // Mostrar respuesta generada por IA
  };
  
  return (
    <div>
      <h3>Reportes de Producción con IA</h3>
      <InputTextarea 
        placeholder="Ej: ¿Cuál es la tasa de cumplimiento de órdenes?"
        onChange={(e) => setQuery(e.target.value)}
      />
      <Button label="Generar Reporte" onClick={askReport} />
      
      {/* Mostrar respuesta */}
    </div>
  );
};
```

---

## 🎯 RECOMENDACIONES FINALES

### 1. **Recursos/ACL** → Vista de solo lectura
- Mostrar árbol de recursos y subrecursos
- **NO** permitir edición (son fixtures del sistema)
- Útil como referencia para admins

### 2. **Roles** → Gestión completa
- Crear/editar/eliminar roles
- Asignar permisos basados en subrecursos fijos
- UI con checkboxes agrupados por recurso

### 3. **Usuarios** → Asignación de roles existentes
- ABM básico de usuarios
- MultiSelect para asignar múltiples roles
- Sincronización de user_roles al guardar

### 4. **Reportes Producción** → Endpoint creado ✅
- **Dashboard con KPIs**: `GET /api/work-orders/reports/stats`
- Muestra: total órdenes, por estado, top BOMs, tendencias
- Gráficos: Pie (estados), Bar (BOMs), Line (tendencia mensual)
- Opcional: Exportación a CSV

---

## 📝 ENDPOINTS IMPLEMENTADOS

```python
# work_order_controller.py

# ✅ 1. Estadísticas de producción (IMPLEMENTADO)
GET /api/work-orders/reports/stats
    Query params: from, to (fechas)
    Response: {
      summary: {total, by_status, completion_rate, efficiency_rate},
      top_boms: [{bom_id, product_name, count, total_quantity}],
      top_products: [{product_id, product_name, total_quantity}],
      monthly_production: [{month, planned, in_progress, finished, cancelled}]
    }

# 2. Exportación CSV (pendiente, opcional)
GET /api/work-orders/reports/work-orders.csv
GET /api/work-orders/reports/bom-usage.csv

# 3. Permisos de rol (pendiente, mejora UX)
GET /api/roles/:id/permissions
    Response: [{
      resource_id, resource_name,
      subresource_id, subresource_name, url, icon
    }]
```

---

## 🚀 ESTADO DE IMPLEMENTACIÓN

### ✅ Completado
1. ✅ **Endpoint `/api/work-orders/reports/stats`** - Creado y funcional
2. ✅ **Documentación actualizada** en `ENDPOINTS_COMPLETE_LIST.md`
3. ✅ **Subrecurso Recursos/ACL eliminado** de todos los seeds

### 📝 Pendiente (Frontend)
1. **Alta**: `ProductionReports.tsx` (dashboard KPIs)
2. **Alta**: `RolesForm.tsx` (crear/editar con checkboxes de permisos)
3. **Alta**: `UsersForm.tsx` (MultiSelect de roles)
4. ~~**Media**: `ResourcesACL.tsx`~~ ❌ **CANCELADO** (subrecurso eliminado)
5. **Baja**: Exportación CSV de reportes producción

---

## 📊 CAMBIOS REALIZADOS

### Archivos Modificados
1. **`seeds/production_seeds.sql`** - Eliminado INSERT de subrecurso "Recursos/ACL"
2. **`seeds/full_database_seeds.sql`** - Eliminado INSERT de subrecurso "Recursos/ACL"
3. **`seeds/menu_complete_5_sprints.sql`** - Eliminado INSERT de subrecurso "Recursos/ACL"
4. **`app/controllers/work_order_controller.py`** - Agregado endpoint `/reports/stats`
5. **`docs/ENDPOINTS_COMPLETE_LIST.md`** - Documentado nuevo endpoint
6. **`docs/RECOMENDACIONES_ACL_REPORTES.md`** - Este documento

### Resultado
- **Antes**: 3 subrecursos en Administración (Usuarios, Roles, Recursos/ACL)
- **Ahora**: 2 subrecursos en Administración (Usuarios, Roles)

---

**Documento creado:** 2025-01-11  
**Última actualización:** 2025-01-11  
**Autor:** GitHub Copilot  
**Versión:** 2.0

