-- ========================================
-- SEEDS DE PRODUCCIÓN - MRP SYSTEM
-- Solo datos esenciales del sistema
-- ========================================

-- =========================
-- PLANES SAAS (Sprint 2)
-- =========================
INSERT INTO plan (code, name, description, price, max_users, max_products, max_warehouses, max_movements_per_day, max_ai_reports_per_day, is_active)
VALUES
  ('FREE', 'Free', 'Plan gratuito con funcionalidades básicas', 0.00, 3, 50, 1, 50, 5, TRUE),
  ('STARTER', 'Starter', 'Plan para pequeñas empresas', 99.00, 10, 500, 3, 500, 50, TRUE),
  ('PRO', 'Pro', 'Plan profesional sin límites', 299.00, 50, NULL, NULL, NULL, 200, TRUE)
ON CONFLICT (code) DO NOTHING;

-- =========================
-- UNIDADES DE MEDIDA
-- =========================
INSERT INTO unit (code, description) VALUES
  ('EA', 'Unidad'),
  ('KG', 'Kilogramo'),
  ('L', 'Litro'),
  ('M', 'Metro'),
  ('M2', 'Metro cuadrado'),
  ('M3', 'Metro cúbico'),
  ('BOX', 'Caja'),
  ('PAL', 'Pallet')
ON CONFLICT (code) DO NOTHING;

-- =========================
-- ROLES DEL SISTEMA
-- =========================
INSERT INTO role (name, description, status) VALUES
  ('Admin', 'Administrador del sistema', TRUE),
  ('Gerente', 'Gerente de operaciones', TRUE),
  ('Almacenero', 'Encargado de almacén', TRUE),
  ('Consultor', 'Usuario de solo lectura', TRUE)
ON CONFLICT (name) DO NOTHING;

-- =========================
-- RECURSOS (Módulos del menú)
-- =========================
INSERT INTO resource (name, description)
SELECT 'Inicio', 'Pantalla principal / Dashboard'
WHERE NOT EXISTS (SELECT 1 FROM resource WHERE name = 'Inicio');

INSERT INTO resource (name, description)
SELECT 'Inventario', 'Gestión de inventario y stock'
WHERE NOT EXISTS (SELECT 1 FROM resource WHERE name = 'Inventario');

INSERT INTO resource (name, description)
SELECT 'Producción', 'BOM, órdenes y ejecución'
WHERE NOT EXISTS (SELECT 1 FROM resource WHERE name = 'Producción');

INSERT INTO resource (name, description)
SELECT 'Proveedores', 'Maestro de proveedores'
WHERE NOT EXISTS (SELECT 1 FROM resource WHERE name = 'Proveedores');

INSERT INTO resource (name, description)
SELECT 'Planificación', 'Demanda, MPS y MRP'
WHERE NOT EXISTS (SELECT 1 FROM resource WHERE name = 'Planificación');

INSERT INTO resource (name, description)
SELECT 'Administración', 'Usuarios, Roles y Seguridad'
WHERE NOT EXISTS (SELECT 1 FROM resource WHERE name = 'Administración');

INSERT INTO resource (name, description)
SELECT 'Reportes', 'Generación de reportes'
WHERE NOT EXISTS (SELECT 1 FROM resource WHERE name = 'Reportes');

INSERT INTO resource (name, description)
SELECT 'Sistema', 'Configuración y mantenimiento'
WHERE NOT EXISTS (SELECT 1 FROM resource WHERE name = 'Sistema');

-- =========================
-- SUBRECURSOS (Opciones del menú)
-- =========================

-- Inicio
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Dashboard', 'Indicadores y KPIs', '/dashboard', 'pi pi-home'
FROM resource r WHERE r.name = 'Inicio'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Dashboard');

-- Inventario
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Productos', 'ABM de productos', '/dashboard/products', 'pi pi-box'
FROM resource r WHERE r.name = 'Inventario'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Productos');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Almacenes', 'ABM de almacenes', '/dashboard/warehouses', 'pi pi-building'
FROM resource r WHERE r.name = 'Inventario'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Almacenes');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Movimientos', 'Entradas/Salidas/Transferencias/Ajustes', '/dashboard/movements', 'pi pi-exchange'
FROM resource r WHERE r.name = 'Inventario'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Movimientos');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Stock Bajo', 'Alertas de stock bajo', '/dashboard/stocks/low', 'pi pi-exclamation-triangle'
FROM resource r WHERE r.name = 'Inventario'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Stock Bajo');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Sugerencias', 'Sugerencias de reposición', '/dashboard/stocks/reorder-suggestions', 'pi pi-refresh'
FROM resource r WHERE r.name = 'Inventario'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Sugerencias');

-- Producción
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Órdenes (demo)', 'Órdenes de producción (demo)', '/dashboard/work-orders', 'pi pi-cog'
FROM resource r WHERE r.name = 'Producción'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Órdenes (demo)');

-- Proveedores
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Proveedores', 'ABM de proveedores', '/dashboard/suppliers', 'pi pi-truck'
FROM resource r WHERE r.name = 'Proveedores'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Proveedores');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Catálogo Proveedor', 'Relación proveedor–producto', '/dashboard/suppliers/supplier-items', 'pi pi-link'
FROM resource r WHERE r.name = 'Proveedores'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Catálogo Proveedor');

-- Planificación
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Demanda', 'Carga de demanda', '/dashboard/demand', 'pi pi-database'
FROM resource r WHERE r.name = 'Planificación'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Demanda');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'MPS', 'Plan Maestro de Producción', '/dashboard/mps', 'pi pi-calendar'
FROM resource r WHERE r.name = 'Planificación'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'MPS');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'MRP', 'Requerimientos de Materiales', '/dashboard/mrp', 'pi pi-sitemap'
FROM resource r WHERE r.name = 'Planificación'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'MRP');

-- Administración
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Usuarios', 'ABM usuarios', '/dashboard/users', 'pi pi-user'
FROM resource r WHERE r.name = 'Administración'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Usuarios');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Roles', 'ABM roles', '/dashboard/roles', 'pi pi-shield'
FROM resource r WHERE r.name = 'Administración'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Roles');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Recursos/ACL', 'ABM recursos y subrecursos', '/dashboard/acl', 'pi pi-list'
FROM resource r WHERE r.name = 'Administración'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Recursos/ACL');

-- Reportes
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Exportar CSV', 'Exportar datos a CSV', '/dashboard/reports/csv', 'pi pi-file-export'
FROM resource r WHERE r.name = 'Reportes'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Exportar CSV');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Reportes IA', 'Generador de reportes con IA', '/dashboard/reports/ai', 'pi pi-sparkles'
FROM resource r WHERE r.name = 'Reportes'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Reportes IA');

-- Sistema
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Logs', 'Auditoría del sistema', '/dashboard/system/logs', 'pi pi-file'
FROM resource r WHERE r.name = 'Sistema'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Logs');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Backup', 'Respaldo de datos', '/dashboard/system/backup', 'pi pi-database'
FROM resource r WHERE r.name = 'Sistema'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Backup');

-- =========================
-- PERMISOS: ROL ADMIN (Acceso total)
-- =========================
INSERT INTO role_resource (role_id, resource_id, subresource_id)
SELECT r.id AS role_id, s.resource_id, s.id AS subresource_id
FROM role r
JOIN subresource s ON TRUE
WHERE r.name = 'Admin'
  AND NOT EXISTS (
    SELECT 1 FROM role_resource rr
    WHERE rr.role_id = r.id
      AND rr.resource_id = s.resource_id
      AND rr.subresource_id = s.id
  );

-- =========================
-- FIN DE SEEDS DE PRODUCCIÓN
-- =========================
-- NOTAS:
-- 1. NO incluye organizations, users, warehouses, products, suppliers
--    → Se crean vía signup o interfaces del sistema
-- 2. Los roles Gerente, Almacenero, Consultor no tienen permisos asignados
--    → Se configuran según necesidad de cada organización
-- 3. El script es idempotente (puede ejecutarse múltiples veces)
