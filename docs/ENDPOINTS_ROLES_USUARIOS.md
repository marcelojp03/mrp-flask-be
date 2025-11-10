# 📚 GUÍA COMPLETA: ENDPOINTS PARA ROLES Y USUARIOS

## 🎯 Resumen de Funcionalidades

### **Componente: ROLES** (`/admin/roles`)
1. ✅ Listar roles
2. ✅ Crear rol
3. ✅ Editar rol
4. ✅ Eliminar rol
5. ✅ **Asignar subrecursos (permisos) a un rol**

### **Componente: USUARIOS** (`/admin/usuarios`)
1. ✅ Listar usuarios (filtrados por organización)
2. ✅ Crear usuario
3. ✅ Editar usuario
4. ✅ Eliminar usuario
5. ✅ **Asignar roles a un usuario**

---

## 🎭 ROLES

### 1. Listar Roles
```http
GET /api/roles
```

**Headers:**
```
Authorization: Bearer <token>
```

**Response:**
```json
{
  "success": true,
  "message": "OK",
  "data": [
    {
      "id": 1,
      "name": "Admin",
      "description": "Administrador del sistema",
      "status": true
    },
    {
      "id": 2,
      "name": "Operador",
      "description": "Usuario de operaciones",
      "status": true
    }
  ]
}
```

---

### 2. Crear Rol
```http
POST /api/roles
```

**Request:**
```json
{
  "name": "Supervisor",
  "description": "Supervisor de producción",
  "status": true
}
```

**Response:**
```json
{
  "success": true,
  "message": "Rol creado",
  "data": {
    "id": 3,
    "name": "Supervisor",
    "description": "Supervisor de producción",
    "status": true
  }
}
```

---

### 3. Editar Rol
```http
PUT /api/roles/:id
```

**Request:**
```json
{
  "name": "Supervisor Senior",
  "description": "Supervisor de producción avanzado"
}
```

---

### 4. Eliminar Rol
```http
DELETE /api/roles/:id
```

---

## 🔐 ASIGNAR PERMISOS (SUBRECURSOS) A ROLES

### 5. Listar Subrecursos Disponibles
```http
GET /api/subresources
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 51,
      "name": "Usuarios",
      "resource_id": 1,
      "resource_name": "Administración",
      "path": "/admin/usuarios",
      "icon": "pi pi-users"
    },
    {
      "id": 52,
      "name": "Roles",
      "resource_id": 1,
      "resource_name": "Administración",
      "path": "/admin/roles",
      "icon": "pi pi-shield"
    },
    {
      "id": 2,
      "name": "Productos",
      "resource_id": 2,
      "resource_name": "Inventario",
      "path": "/inventory/products",
      "icon": "pi pi-box"
    }
  ]
}
```

---

### 6. Obtener Permisos de un Rol
```http
GET /api/role-resources?role_id=2
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 10,
      "role_id": 2,
      "resource_id": 2,
      "subresource_id": 2,
      "role_name": "Operador",
      "resource_name": "Inventario",
      "subresource_name": "Productos"
    }
  ]
}
```

---

### 7. Asignar Permiso a Rol
```http
POST /api/role-resources
```

**Request:**
```json
{
  "role_id": 2,
  "resource_id": 2,
  "subresource_id": 3
}
```

**Response:**
```json
{
  "success": true,
  "message": "Permiso asignado",
  "data": {
    "id": 11,
    "role_id": 2,
    "resource_id": 2,
    "subresource_id": 3
  }
}
```

---

### 8. Quitar Permiso de Rol
```http
DELETE /api/role-resources
```

**Request:**
```json
{
  "role_id": 2,
  "resource_id": 2,
  "subresource_id": 3
}
```

**Response:**
```json
{
  "success": true,
  "message": "Permiso quitado"
}
```

---

## 👥 USUARIOS

### 9. Listar Usuarios (de la Organización Actual)
```http
GET /api/users
```

**Headers:**
```
Authorization: Bearer <token>
```

**Nota:** Este endpoint ahora **filtra automáticamente** por la organización del usuario autenticado (usando `org_id` del JWT).

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Marcelo Jimenez",
      "email": "marcelojp03@gmail.com",
      "photo": null,
      "status": true,
      "roles": [
        {
          "role_id": 1,
          "role": "Admin",
          "user_id": 1
        }
      ]
    },
    {
      "id": 5,
      "name": "Juan Pérez",
      "email": "juan@example.com",
      "photo": null,
      "status": true,
      "roles": [
        {
          "role_id": 2,
          "role": "Operador",
          "user_id": 5
        }
      ]
    }
  ]
}
```

---

### 10. Crear Usuario (con Roles Opcionales)
```http
POST /api/users
```

**Request (con roles):**
```json
{
  "name": "Ana García",
  "email": "ana@example.com",
  "password": "secure123",
  "role_ids": [1, 2]
}
```

**Request (sin roles):**
```json
{
  "name": "Pedro López",
  "email": "pedro@example.com",
  "password": "secure456"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Usuario creado",
  "data": {
    "id": 6,
    "name": "Ana García",
    "email": "ana@example.com",
    "status": true,
    "roles": [
      {"role_id": 1, "role": "Admin", "user_id": 6},
      {"role_id": 2, "role": "Operador", "user_id": 6}
    ]
  }
}
```

---

### 11. Editar Usuario (incluyendo Roles)
```http
PUT /api/users/:id
```

**Request (cambiar roles):**
```json
{
  "name": "Ana García Actualizada",
  "email": "ana.updated@example.com",
  "role_ids": [1]
}
```

**Request (sin cambiar roles):**
```json
{
  "name": "Ana García",
  "status": false
}
```

**Response:**
```json
{
  "success": true,
  "message": "Usuario actualizado",
  "data": {
    "id": 6,
    "name": "Ana García Actualizada",
    "email": "ana.updated@example.com",
    "status": true,
    "roles": [
      {"role_id": 1, "role": "Admin", "user_id": 6}
    ]
  }
}
```

---

### 12. Eliminar Usuario
```http
DELETE /api/users/:id
```

---

### 13. Resetear Contraseña de Usuario (Admin)
```http
PUT /api/users/:id/password
```

**Headers:**
```
Authorization: Bearer <token>
```

**Request:**
```json
{
  "password": "nueva_contraseña_123"
}
```

**Nota:** Este endpoint permite al **administrador** resetear la contraseña de cualquier usuario **sin necesitar la contraseña anterior**. Útil para recuperación de cuentas.

**Response:**
```json
{
  "success": true,
  "message": "Contraseña actualizada correctamente"
}
```

---

### 14. Cambiar Propia Contraseña (Usuario Autenticado)
```http
PUT /api/auth/change-password
```

**Headers:**
```
Authorization: Bearer <token>
```

**Request:**
```json
{
  "current_password": "contraseña_actual",
  "new_password": "nueva_contraseña_123"
}
```

**Nota:** Este endpoint permite al **usuario autenticado** cambiar su **propia contraseña**. Requiere la contraseña actual por seguridad.

**Response:**
```json
{
  "success": true,
  "message": "Contraseña actualizada correctamente"
}
```

**Error (contraseña actual incorrecta):**
```json
{
  "success": false,
  "message": "Contraseña actual incorrecta",
  "code": "WRONG_PASSWORD"
}
```

---

## 🔗 GESTIÓN AVANZADA DE ROLES (Alternativa)

Si prefieres manejar los roles por separado en lugar de incluirlos en el usuario:

### 15. Listar Roles de un Usuario
```http
GET /api/user-roles/user/:user_id
```

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "user_id": 6,
      "role_id": 1,
      "role": "Admin"
    }
  ]
}
```

---

### 16. Asignar Rol Individual a Usuario
```http
POST /api/user-roles
```

**Request:**
```json
{
  "user_id": 6,
  "role_id": 2
}
```

---

### 17. Quitar Rol de Usuario
```http
DELETE /api/user-roles
```

**Request:**
```json
{
  "user_id": 6,
  "role_id": 2
}
```

---

## 📋 FLUJOS RECOMENDADOS PARA EL FRONTEND

### **FLUJO: Crear/Editar ROL con Permisos**

1. **Mostrar formulario de rol:**
   - Campos: `name`, `description`
   
2. **Obtener lista de subrecursos disponibles:**
   ```typescript
   GET /api/subresources
   ```
   - Mostrar como **checkboxes agrupados por recurso** (ej: Administración, Inventario, Producción)

3. **Al cargar un rol existente, obtener sus permisos:**
   ```typescript
   GET /api/role-resources?role_id=${roleId}
   ```
   - Marcar los checkboxes correspondientes

4. **Al guardar:**
   - **Crear rol:** `POST /api/roles` → obtener `role_id`
   - **Asignar permisos:** Por cada subrecurso seleccionado:
     ```typescript
     POST /api/role-resources
     {
       role_id: roleId,
       resource_id: subresource.resource_id,
       subresource_id: subresource.id
     }
     ```
   - **Quitar permisos desmarcados:** Por cada permiso que se desmarcó:
     ```typescript
     DELETE /api/role-resources
     {
       role_id: roleId,
       resource_id: subresource.resource_id,
       subresource_id: subresource.id
     }
     ```

---

### **FLUJO: Crear/Editar USUARIO con Roles**

1. **Mostrar formulario de usuario:**
   - Campos: `name`, `email`, `password` (solo en creación), `status`

2. **Obtener lista de roles disponibles:**
   ```typescript
   GET /api/roles
   ```
   - Mostrar como **MultiSelect** (PrimeNG: p-multiSelect)

3. **Al cargar un usuario existente:**
   - El usuario ya viene con sus roles en la respuesta de `GET /api/users/:id`
   - Pre-seleccionar roles en el MultiSelect

4. **Al guardar:**
   - **Crear usuario:**
     ```typescript
     POST /api/users
     {
       name: "...",
       email: "...",
       password: "...",
       role_ids: [1, 2, 3]  // IDs de roles seleccionados
     }
     ```
   
   - **Actualizar usuario:**
     ```typescript
     PUT /api/users/:id
     {
       name: "...",
       email: "...",
       role_ids: [1, 3]  // Roles actualizados
     }
     ```

---

## 🎨 EJEMPLO DE INTERFAZ (PrimeNG)

### **Componente Roles:**

```html
<p-table [value]="roles">
  <ng-template pTemplate="header">
    <tr>
      <th>ID</th>
      <th>Nombre</th>
      <th>Descripción</th>
      <th>Acciones</th>
    </tr>
  </ng-template>
  <ng-template pTemplate="body" let-role>
    <tr>
      <td>{{role.id}}</td>
      <td>{{role.name}}</td>
      <td>{{role.description}}</td>
      <td>
        <button pButton icon="pi pi-pencil" (click)="editRole(role)"></button>
        <button pButton icon="pi pi-trash" (click)="deleteRole(role)"></button>
      </td>
    </tr>
  </ng-template>
</p-table>

<!-- Dialog para crear/editar rol -->
<p-dialog [(visible)]="displayRoleDialog" [header]="editingRole ? 'Editar Rol' : 'Crear Rol'">
  <div class="p-field">
    <label>Nombre</label>
    <input pInputText [(ngModel)]="roleForm.name" />
  </div>
  
  <div class="p-field">
    <label>Descripción</label>
    <textarea pInputTextarea [(ngModel)]="roleForm.description"></textarea>
  </div>
  
  <div class="p-field">
    <label>Permisos (Subrecursos)</label>
    <div *ngFor="let resource of resources">
      <h4>{{resource.name}}</h4>
      <div *ngFor="let sub of resource.subresources">
        <p-checkbox 
          [binary]="true"
          [(ngModel)]="permissions[sub.id]"
          [label]="sub.name">
        </p-checkbox>
      </div>
    </div>
  </div>
  
  <ng-template pTemplate="footer">
    <button pButton label="Cancelar" (click)="displayRoleDialog=false"></button>
    <button pButton label="Guardar" (click)="saveRole()"></button>
  </ng-template>
</p-dialog>
```

### **Componente Usuarios:**

```html
<p-table [value]="users">
  <ng-template pTemplate="header">
    <tr>
      <th>ID</th>
      <th>Nombre</th>
      <th>Email</th>
      <th>Roles</th>
      <th>Acciones</th>
    </tr>
  </ng-template>
  <ng-template pTemplate="body" let-user>
    <tr>
      <td>{{user.id}}</td>
      <td>{{user.name}}</td>
      <td>{{user.email}}</td>
      <td>
        <span *ngFor="let r of user.roles" class="badge">{{r.role}}</span>
      </td>
      <td>
        <button pButton icon="pi pi-pencil" (click)="editUser(user)"></button>
        <button pButton icon="pi pi-trash" (click)="deleteUser(user)"></button>
      </td>
    </tr>
  </ng-template>
</p-table>

<!-- Dialog para crear/editar usuario -->
<p-dialog [(visible)]="displayUserDialog" [header]="editingUser ? 'Editar Usuario' : 'Crear Usuario'">
  <div class="p-field">
    <label>Nombre</label>
    <input pInputText [(ngModel)]="userForm.name" />
  </div>
  
  <div class="p-field">
    <label>Email</label>
    <input pInputText [(ngModel)]="userForm.email" />
  </div>
  
  <div class="p-field" *ngIf="!editingUser">
    <label>Contraseña</label>
    <input type="password" pInputText [(ngModel)]="userForm.password" />
  </div>
  
  <div class="p-field" *ngIf="editingUser">
    <label>Cambiar Contraseña</label>
    <button pButton label="Resetear Contraseña" icon="pi pi-key" (click)="showResetPasswordDialog(editingUser)"></button>
  </div>
  
  <div class="p-field">
    <label>Roles</label>
    <p-multiSelect 
      [options]="roles" 
      [(ngModel)]="userForm.role_ids"
      optionLabel="name"
      optionValue="id"
      placeholder="Seleccionar roles">
    </p-multiSelect>
  </div>
  
  <ng-template pTemplate="footer">
    <button pButton label="Cancelar" (click)="displayUserDialog=false"></button>
    <button pButton label="Guardar" (click)="saveUser()"></button>
  </ng-template>
</p-dialog>

<!-- Dialog para resetear contraseña (Admin) -->
<p-dialog [(visible)]="displayResetPasswordDialog" header="Resetear Contraseña">
  <div class="p-field">
    <label>Nueva Contraseña para {{resetPasswordUser?.name}}</label>
    <input type="password" pInputText [(ngModel)]="newPassword" placeholder="Nueva contraseña" />
  </div>
  
  <ng-template pTemplate="footer">
    <button pButton label="Cancelar" (click)="displayResetPasswordDialog=false"></button>
    <button pButton label="Resetear" (click)="resetPassword()"></button>
  </ng-template>
</p-dialog>
```

---

## 🚀 EJEMPLO DE CÓDIGO TypeScript

### **roles.component.ts:**

```typescript
export class RolesComponent implements OnInit {
  roles: any[] = [];
  subresources: any[] = [];
  permissions: { [key: number]: boolean } = {};
  roleForm = { name: '', description: '' };
  editingRole: any = null;
  displayRoleDialog = false;

  ngOnInit() {
    this.loadRoles();
    this.loadSubresources();
  }

  loadRoles() {
    this.http.get('/api/roles').subscribe((res: any) => {
      this.roles = res.data;
    });
  }

  loadSubresources() {
    this.http.get('/api/subresources').subscribe((res: any) => {
      this.subresources = res.data;
    });
  }

  editRole(role: any) {
    this.editingRole = role;
    this.roleForm = { ...role };
    this.loadRolePermissions(role.id);
    this.displayRoleDialog = true;
  }

  loadRolePermissions(roleId: number) {
    this.http.get(`/api/role-resources?role_id=${roleId}`).subscribe((res: any) => {
      this.permissions = {};
      res.data.forEach((perm: any) => {
        this.permissions[perm.subresource_id] = true;
      });
    });
  }

  saveRole() {
    const request = this.editingRole 
      ? this.http.put(`/api/roles/${this.editingRole.id}`, this.roleForm)
      : this.http.post('/api/roles', this.roleForm);

    request.subscribe((res: any) => {
      const roleId = res.data.id;
      this.savePermissions(roleId);
    });
  }

  savePermissions(roleId: number) {
    // Asignar permisos seleccionados
    this.subresources.forEach(sub => {
      if (this.permissions[sub.id]) {
        this.http.post('/api/role-resources', {
          role_id: roleId,
          resource_id: sub.resource_id,
          subresource_id: sub.id
        }).subscribe();
      }
    });

    this.displayRoleDialog = false;
    this.loadRoles();
  }
}
```

### **users.component.ts:**

```typescript
export class UsersComponent implements OnInit {
  users: any[] = [];
  roles: any[] = [];
  userForm = { name: '', email: '', password: '', role_ids: [] };
  editingUser: any = null;
  displayUserDialog = false;
  displayResetPasswordDialog = false;
  resetPasswordUser: any = null;
  newPassword: string = '';

  ngOnInit() {
    this.loadUsers();
    this.loadRoles();
  }

  loadUsers() {
    this.http.get('/api/users').subscribe((res: any) => {
      this.users = res.data;
    });
  }

  loadRoles() {
    this.http.get('/api/roles').subscribe((res: any) => {
      this.roles = res.data;
    });
  }

  editUser(user: any) {
    this.editingUser = user;
    this.userForm = {
      name: user.name,
      email: user.email,
      password: '',
      role_ids: user.roles.map((r: any) => r.role_id)
    };
    this.displayUserDialog = true;
  }

  saveUser() {
    const request = this.editingUser
      ? this.http.put(`/api/users/${this.editingUser.id}`, this.userForm)
      : this.http.post('/api/users', this.userForm);

    request.subscribe(() => {
      this.displayUserDialog = false;
      this.loadUsers();
    });
  }

  showResetPasswordDialog(user: any) {
    this.resetPasswordUser = user;
    this.newPassword = '';
    this.displayResetPasswordDialog = true;
  }

  resetPassword() {
    this.http.put(`/api/users/${this.resetPasswordUser.id}/password`, {
      password: this.newPassword
    }).subscribe(() => {
      this.displayResetPasswordDialog = false;
      this.messageService.add({ 
        severity: 'success', 
        summary: 'Éxito', 
        detail: 'Contraseña actualizada correctamente' 
      });
    });
  }
}
```

---

## ✅ RESUMEN

### **Para ROLES:**
- ✅ CRUD básico: `/api/roles`
- ✅ Listar subrecursos: `GET /api/subresources`
- ✅ Asignar permisos: `POST /api/role-resources`
- ✅ Quitar permisos: `DELETE /api/role-resources`

### **Para USUARIOS:**
- ✅ Listar usuarios (filtrados por org): `GET /api/users`
- ✅ Crear usuario con roles: `POST /api/users` + `role_ids: [...]`
- ✅ Actualizar usuario con roles: `PUT /api/users/:id` + `role_ids: [...]`
- ✅ Listar roles disponibles: `GET /api/roles`
- ✅ **Resetear contraseña (Admin):** `PUT /api/users/:id/password`
- ✅ **Cambiar propia contraseña:** `PUT /api/auth/change-password`

### **Cambios Aplicados:**
1. ✅ `GET /api/users` ahora requiere autenticación y filtra por `org_id`
2. ✅ Usuarios de diferentes organizaciones están separados
3. ✅ Ya existen endpoints para asignar roles a usuarios (`role_ids` en POST/PUT)
4. ✅ Ya existen endpoints para asignar permisos a roles (`/api/role-resources`)
5. ✅ **Endpoint separado para cambio de contraseña por admin** (`/api/users/:id/password`)
6. ✅ **Endpoint separado para cambio de contraseña por usuario** (`/api/auth/change-password`)

**No necesitas combinar endpoints** - cada operación tiene su endpoint específico.

### **Seguridad de Contraseñas:**
- ⚠️ Las contraseñas **NUNCA** se muestran en los responses
- ⚠️ Las contraseñas **NUNCA** se incluyen en `GET /api/users` o `GET /api/users/:id`
- ✅ Admin puede resetear contraseñas **sin necesitar la actual**
- ✅ Usuario debe proporcionar contraseña actual para cambiarla
- ✅ Todas las contraseñas se hashean automáticamente con `werkzeug.security`
