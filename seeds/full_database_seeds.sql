-- ============================================================================
-- FULL DATABASE SEEDS - MRP System
-- ============================================================================
-- Este archivo incluye:
-- 1. Datos esenciales del sistema (planes SaaS, unidades, roles)
-- 2. Estructura del menú completa
-- 3. Datos de negocio (organizaciones, productos, almacenes, proveedores)
-- 4. Usuarios con roles asignados
--
-- IMPORTANTE: Las contraseñas están en texto plano.
-- El AuthService las hashea automáticamente en el primer login.
--
-- Idempotente: Se puede ejecutar múltiples veces
-- ============================================================================

-- ============================================================================
-- 1) PLANES SAAS
-- ============================================================================
INSERT INTO plan (code, name, max_users, max_products, max_warehouses, max_movements_per_day, max_ai_reports_per_day, allow_bom, allow_work_orders, allow_mrp, allow_forecast, is_active)
VALUES 
  ('free', 'Free', 3, 50, 1, 50, 10, false, false, false, false, true),
  ('starter', 'Starter', 10, 500, 3, 500, 100, false, false, false, false, true),
  ('pro', 'Pro', 99999, 99999, 99999, 99999, 500, true, true, true, true, true)
ON CONFLICT (code) DO NOTHING;

-- ============================================================================
-- 2) ORGANIZACIONES
-- ============================================================================
INSERT INTO organization (name, code, is_active) VALUES
  ('Acme S.A.', 'ACME', TRUE),
  ('Globex Ltd.', 'GLOBEX', TRUE)
ON CONFLICT (code) DO NOTHING;

-- ============================================================================
-- 3) SUSCRIPCIONES (Plan Starter para ambas orgs)
-- ============================================================================
INSERT INTO org_subscription (org_id, plan_id, status, started_at, trial_until, max_products_override, max_warehouses_override, max_movements_per_day_override)
SELECT o.id, p.id, 'active', CURRENT_DATE, CURRENT_DATE + INTERVAL '14 days', NULL, NULL, NULL
FROM organization o
JOIN plan p ON p.code = 'starter'
WHERE o.code = 'ACME'
  AND NOT EXISTS (SELECT 1 FROM org_subscription os WHERE os.org_id = o.id);

INSERT INTO org_subscription (org_id, plan_id, status, started_at, trial_until, max_products_override, max_warehouses_override, max_movements_per_day_override)
SELECT o.id, p.id, 'active', CURRENT_DATE, CURRENT_DATE + INTERVAL '14 days', NULL, NULL, NULL
FROM organization o
JOIN plan p ON p.code = 'starter'
WHERE o.code = 'GLOBEX'
  AND NOT EXISTS (SELECT 1 FROM org_subscription os WHERE os.org_id = o.id);

-- ============================================================================
-- 4) UNIDADES DE MEDIDA
-- ============================================================================
INSERT INTO unit (code, description, status) VALUES
  ('EA', 'Unidad', true),
  ('KG', 'Kilogramo', true),
  ('L', 'Litro', true),
  ('M', 'Metro', true),
  ('M2', 'Metro cuadrado', true),
  ('M3', 'Metro cúbico', true),
  ('BOX', 'Caja', true),
  ('PAL', 'Pallet', true)
ON CONFLICT (code) DO NOTHING;

-- ============================================================================
-- 5) ROLES (Solo 4 roles principales)
-- ============================================================================
INSERT INTO role (name, description, status) VALUES
  ('Admin', 'Administrador del sistema', TRUE),
  ('Planner', 'Planificador / MRP', TRUE),
  ('Supervisor', 'Supervisor de planta', TRUE),
  ('Operator', 'Operario de planta', TRUE)
ON CONFLICT (name) DO NOTHING;

-- ============================================================================
-- 6) RECURSOS (Módulos del menú) - 5 SPRINTS COMPLETOS
-- ============================================================================
-- Sprint 1: Inicio, Inventario, Proveedores, Administración
-- Sprint 2: Reportes, Sistema
-- Sprint 3: Producción
-- Sprint 4-5: Planificación (con Forecast)
-- ============================================================================

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

-- ============================================================================
-- 7) SUBRECURSOS (Opciones del menú) - 5 SPRINTS COMPLETOS
-- ============================================================================
-- Total: 30 subrecursos distribuidos en 5 sprints
-- ============================================================================

-- ============================================================================
-- SPRINT 1: Fundamentos (11 subrecursos)
-- ============================================================================

-- Inicio (S1)
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Dashboard', 'Indicadores y KPIs', '/dashboard', 'pi pi-home'
FROM resource r WHERE r.name = 'Inicio'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Dashboard');

-- Inventario (S1)
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Productos', 'ABM de productos', '/products', 'pi pi-box'
FROM resource r WHERE r.name = 'Inventario'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Productos');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Almacenes', 'ABM de almacenes', '/warehouses', 'pi pi-building'
FROM resource r WHERE r.name = 'Inventario'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Almacenes');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Movimientos', 'Entradas/Salidas/Transferencias/Ajustes', '/movements', 'pi pi-exchange'
FROM resource r WHERE r.name = 'Inventario'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Movimientos');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Stock Bajo', 'Alertas de stock bajo', '/stocks/low', 'pi pi-exclamation-triangle'
FROM resource r WHERE r.name = 'Inventario'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Stock Bajo');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Sugerencias', 'Sugerencias de reposición', '/stocks/reorder-suggestions', 'pi pi-refresh'
FROM resource r WHERE r.name = 'Inventario'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Sugerencias');

-- Proveedores (S1)
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Proveedores', 'ABM de proveedores', '/suppliers', 'pi pi-truck'
FROM resource r WHERE r.name = 'Proveedores'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Proveedores');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Catálogo Proveedor', 'Relación proveedor–producto', '/supplier-items', 'pi pi-link'
FROM resource r WHERE r.name = 'Proveedores'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Catálogo Proveedor');

-- Administración (S1)
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Usuarios', 'ABM usuarios', '/users', 'pi pi-user'
FROM resource r WHERE r.name = 'Administración'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Usuarios');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Roles', 'ABM roles', '/roles', 'pi pi-shield'
FROM resource r WHERE r.name = 'Administración'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Roles');

-- ============================================================================
-- SPRINT 2: SaaS + Logs + Reportes + Backup (6 subrecursos)
-- ============================================================================

-- Reportes (S2)
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Exportar CSV', 'Exportar datos a CSV', '/reports/csv', 'pi pi-file-export'
FROM resource r WHERE r.name = 'Reportes'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Exportar CSV');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Reportes IA', 'Generador de reportes con IA (limitado)', '/reports/ai', 'pi pi-sparkles'
FROM resource r WHERE r.name = 'Reportes'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Reportes IA');

-- Sistema (S2)
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Logs', 'Auditoría del sistema', '/system/logs', 'pi pi-file'
FROM resource r WHERE r.name = 'Sistema'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Logs');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Backup', 'Respaldo de datos por organización', '/system/backup', 'pi pi-database'
FROM resource r WHERE r.name = 'Sistema'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Backup');

-- Administración (S2)
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Organizaciones', 'Gestión de empresas multi-tenant', '/organizations', 'pi pi-building-columns'
FROM resource r WHERE r.name = 'Administración'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Organizaciones');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Planes SaaS', 'Gestión de planes y suscripciones', '/plans', 'pi pi-credit-card'
FROM resource r WHERE r.name = 'Administración'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Planes SaaS');

-- ============================================================================
-- SPRINT 3: Producción (BOM + Work Orders) (4 subrecursos)
-- ============================================================================

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Lista de Materiales', 'Gestión de BOMs por producto', '/boms', 'pi pi-sitemap'
FROM resource r WHERE r.name = 'Producción'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Lista de Materiales');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Órdenes de Producción', 'Gestión de Work Orders', '/work-orders', 'pi pi-cog'
FROM resource r WHERE r.name = 'Producción'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Órdenes de Producción');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Ejecución', 'Iniciar/Finalizar órdenes (operarios)', '/production/execution', 'pi pi-play'
FROM resource r WHERE r.name = 'Producción'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Ejecución');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Reportes Producción', 'OPs activas, finalizadas, materiales', '/production/reports', 'pi pi-chart-bar'
FROM resource r WHERE r.name = 'Producción'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Reportes Producción');

-- ============================================================================
-- SPRINT 4: Planificación (Demanda, MPS, MRP) (5 subrecursos)
-- ============================================================================

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Demanda', 'Carga de demanda de productos', '/demand', 'pi pi-database'
FROM resource r WHERE r.name = 'Planificación'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Demanda');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'MPS', 'Plan Maestro de Producción', '/mps', 'pi pi-calendar'
FROM resource r WHERE r.name = 'Planificación'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'MPS');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'MRP', 'Requerimientos de Materiales', '/mrp', 'pi pi-sitemap'
FROM resource r WHERE r.name = 'Planificación'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'MRP');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Propuestas', 'Aprobar/Rechazar OC/OP generadas', '/proposals', 'pi pi-check-square'
FROM resource r WHERE r.name = 'Planificación'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Propuestas');

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Plan vs Ejecución', 'Comparativa plan vs real', '/plan-vs-execution', 'pi pi-chart-line'
FROM resource r WHERE r.name = 'Planificación'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Plan vs Ejecución');

-- ============================================================================
-- SPRINT 5: Inteligencia (Forecast, Alertas, Dashboard Avanzado) (4 subrecursos)
-- ============================================================================

-- Planificación - Forecast
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Forecast', 'Pronóstico de demanda (IA simple)', '/forecast', 'pi pi-chart-line'
FROM resource r WHERE r.name = 'Planificación'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Forecast');

-- Sistema - Alertas
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Alertas', 'Notificaciones inteligentes', '/alerts', 'pi pi-bell'
FROM resource r WHERE r.name = 'Sistema'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Alertas');

-- Reportes - Dashboard Avanzado
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Dashboard Avanzado', 'KPIs, rotación, cumplimiento', '/reports/advanced', 'pi pi-chart-pie'
FROM resource r WHERE r.name = 'Reportes'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'Dashboard Avanzado');

-- Producción - App Móvil
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'App Móvil', 'QR, push, tiempos', '/production/mobile', 'pi pi-mobile'
FROM resource r WHERE r.name = 'Producción'
  AND NOT EXISTS (SELECT 1 FROM subresource s WHERE s.resource_id = r.id AND s.name = 'App Móvil');

-- ============================================================================
-- 8) PERMISOS: ROLE_RESOURCE (Asignación por Sprint)
-- ============================================================================

-- Admin → TODOS los subresources (todos los sprints)
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

-- Planner → Inventario + Proveedores + Planificación + Producción (BOM/WO) + Inicio
INSERT INTO role_resource (role_id, resource_id, subresource_id)
SELECT r.id, s.resource_id, s.id
FROM role r
JOIN subresource s ON TRUE
JOIN resource res ON res.id = s.resource_id
WHERE r.name = 'Planner'
  AND (
    res.name IN ('Inventario','Proveedores','Planificación','Inicio')
    OR (res.name = 'Producción' AND s.name IN ('Lista de Materiales', 'Órdenes de Producción', 'Reportes Producción'))
  )
  AND NOT EXISTS (
    SELECT 1 FROM role_resource rr
    WHERE rr.role_id = r.id
      AND rr.resource_id = s.resource_id
      AND rr.subresource_id = s.id
  );

-- Supervisor → Inventario + Producción (solo reportes y órdenes) + Inicio
INSERT INTO role_resource (role_id, resource_id, subresource_id)
SELECT r.id, s.resource_id, s.id
FROM role r
JOIN subresource s ON TRUE
JOIN resource res ON res.id = s.resource_id
WHERE r.name = 'Supervisor'
  AND (
    (res.name = 'Inventario' AND s.name IN ('Movimientos','Stock Bajo','Productos'))
    OR (res.name = 'Producción' AND s.name IN ('Órdenes de Producción', 'Reportes Producción'))
    OR (res.name = 'Inicio' AND s.name = 'Dashboard')
  )
  AND NOT EXISTS (
    SELECT 1 FROM role_resource rr
    WHERE rr.role_id = r.id
      AND rr.resource_id = s.resource_id
      AND rr.subresource_id = s.id
  );

-- Operator → Inventario (Movimientos) + Producción (Ejecución) + Inicio
INSERT INTO role_resource (role_id, resource_id, subresource_id)
SELECT r.id, s.resource_id, s.id
FROM role r
JOIN subresource s ON TRUE
JOIN resource res ON res.id = s.resource_id
WHERE r.name = 'Operator'
  AND (
    (res.name = 'Inventario' AND s.name = 'Movimientos')
    OR (res.name = 'Producción' AND s.name = 'Ejecución')
    OR (res.name = 'Inicio' AND s.name = 'Dashboard')
  )
  AND NOT EXISTS (
    SELECT 1 FROM role_resource rr
    WHERE rr.role_id = r.id
      AND rr.resource_id = s.resource_id
      AND rr.subresource_id = s.id
  );

-- ============================================================================
-- 9) USUARIOS
-- IMPORTANTE: Contraseñas en texto plano, el sistema las hashea en primer login
-- ============================================================================
INSERT INTO "user" (name, email, password, photo, status)
VALUES
  ('Alice Admin', 'admin@acme.com', 'admin123', NULL, TRUE),
  ('Paul Planner', 'planner@acme.com', 'planner123', NULL, TRUE),
  ('Sara Supervisor', 'super@acme.com', 'super123', NULL, TRUE),
  ('Oscar Operator', 'op@acme.com', 'op123', NULL, TRUE)
ON CONFLICT (email) DO NOTHING;

-- ============================================================================
-- 10) USER_ROLE
-- ============================================================================

-- Admin
INSERT INTO user_role (user_id, role_id)
SELECT u.id, r.id FROM "user" u, role r
WHERE u.email = 'admin@acme.com' AND r.name = 'Admin'
  AND NOT EXISTS (SELECT 1 FROM user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id);

-- Planner
INSERT INTO user_role (user_id, role_id)
SELECT u.id, r.id FROM "user" u, role r
WHERE u.email = 'planner@acme.com' AND r.name = 'Planner'
  AND NOT EXISTS (SELECT 1 FROM user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id);

-- Supervisor
INSERT INTO user_role (user_id, role_id)
SELECT u.id, r.id FROM "user" u, role r
WHERE u.email = 'super@acme.com' AND r.name = 'Supervisor'
  AND NOT EXISTS (SELECT 1 FROM user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id);

-- Operator
INSERT INTO user_role (user_id, role_id)
SELECT u.id, r.id FROM "user" u, role r
WHERE u.email = 'op@acme.com' AND r.name = 'Operator'
  AND NOT EXISTS (SELECT 1 FROM user_role ur WHERE ur.user_id = u.id AND ur.role_id = r.id);

-- ============================================================================
-- 11) USER_ORGANIZATION (multi-org, default a ACME)
-- ============================================================================
INSERT INTO user_organization (user_id, org_id, is_default)
SELECT u.id, o.id, TRUE
FROM "user" u
JOIN organization o ON o.code = 'ACME'
WHERE u.email IN ('admin@acme.com', 'planner@acme.com', 'super@acme.com', 'op@acme.com')
  AND NOT EXISTS (SELECT 1 FROM user_organization uo WHERE uo.user_id = u.id AND uo.org_id = o.id);

-- ============================================================================
-- 12) ALMACENES
-- ============================================================================
INSERT INTO warehouse (name, location, org_id)
SELECT 'Principal', 'Parque Industrial', o.id
FROM organization o WHERE o.code = 'ACME'
  AND NOT EXISTS (SELECT 1 FROM warehouse w WHERE w.name = 'Principal' AND w.org_id = o.id);

INSERT INTO warehouse (name, location, org_id)
SELECT 'Secundario', 'Zona Norte', o.id
FROM organization o WHERE o.code = 'ACME'
  AND NOT EXISTS (SELECT 1 FROM warehouse w WHERE w.name = 'Secundario' AND w.org_id = o.id);

INSERT INTO warehouse (name, location, org_id)
SELECT 'Devoluciones', 'Zona Sur', o.id
FROM organization o WHERE o.code = 'ACME'
  AND NOT EXISTS (SELECT 1 FROM warehouse w WHERE w.name = 'Devoluciones' AND w.org_id = o.id);

-- ============================================================================
-- 13) PRODUCTOS
-- ============================================================================

-- Helper: Sanear defaults de created_at/updated_at
ALTER TABLE product ALTER COLUMN created_at SET DEFAULT NOW();
ALTER TABLE product ALTER COLUMN updated_at SET DEFAULT NOW();
UPDATE product SET created_at = NOW() WHERE created_at IS NULL;
UPDATE product SET updated_at = NOW() WHERE updated_at IS NULL;

-- Materia Prima
WITH o AS (SELECT id AS org_id FROM organization WHERE code='ACME')
INSERT INTO product (org_id, code, name, description, unit_id, min_stock, procurement_type, item_type, status)
SELECT o.org_id, 'RM-ALU', 'Aluminio 6061', 'Materia prima aluminio',
       (SELECT id FROM unit WHERE code='KG'), 100.00, 'BUY', 'RM', TRUE
FROM o
WHERE NOT EXISTS (SELECT 1 FROM product pr WHERE pr.code='RM-ALU' AND pr.org_id = o.org_id);

WITH o AS (SELECT id AS org_id FROM organization WHERE code='ACME')
INSERT INTO product (org_id, code, name, description, unit_id, min_stock, procurement_type, item_type, status)
SELECT o.org_id, 'RM-ACERO', 'Acero A36', 'Plancha acero',
       (SELECT id FROM unit WHERE code='KG'), 150.00, 'BUY', 'RM', TRUE
FROM o
WHERE NOT EXISTS (SELECT 1 FROM product pr WHERE pr.code='RM-ACERO' AND pr.org_id = o.org_id);

WITH o AS (SELECT id AS org_id FROM organization WHERE code='ACME')
INSERT INTO product (org_id, code, name, description, unit_id, min_stock, procurement_type, item_type, status)
SELECT o.org_id, 'RM-PINT', 'Pintura Epoxi', 'Pintura industrial',
       (SELECT id FROM unit WHERE code='L'), 50.00, 'BUY', 'RM', TRUE
FROM o
WHERE NOT EXISTS (SELECT 1 FROM product pr WHERE pr.code='RM-PINT' AND pr.org_id = o.org_id);

WITH o AS (SELECT id AS org_id FROM organization WHERE code='ACME')
INSERT INTO product (org_id, code, name, description, unit_id, min_stock, procurement_type, item_type, status)
SELECT o.org_id, 'RM-TORN', 'Tornillos M6', 'Tornillo M6 x 20',
       (SELECT id FROM unit WHERE code='BOX'), 30.00, 'BUY', 'RM', TRUE
FROM o
WHERE NOT EXISTS (SELECT 1 FROM product pr WHERE pr.code='RM-TORN' AND pr.org_id = o.org_id);

WITH o AS (SELECT id AS org_id FROM organization WHERE code='ACME')
INSERT INTO product (org_id, code, name, description, unit_id, min_stock, procurement_type, item_type, status)
SELECT o.org_id, 'RM-MAD', 'Madera Cedro', 'Tabla cepillada',
       (SELECT id FROM unit WHERE code='M'), 80.00, 'BUY', 'RM', TRUE
FROM o
WHERE NOT EXISTS (SELECT 1 FROM product pr WHERE pr.code='RM-MAD' AND pr.org_id = o.org_id);

-- Productos Terminados
WITH o AS (SELECT id AS org_id FROM organization WHERE code='ACME')
INSERT INTO product (org_id, code, name, description, unit_id, min_stock, procurement_type, item_type, status)
SELECT o.org_id, 'FG-MESA', 'Mesa Premium', 'Mesa de aluminio + madera',
       (SELECT id FROM unit WHERE code='EA'), 20.00, 'MAKE', 'FG', TRUE
FROM o
WHERE NOT EXISTS (SELECT 1 FROM product pr WHERE pr.code='FG-MESA' AND pr.org_id = o.org_id);

WITH o AS (SELECT id AS org_id FROM organization WHERE code='ACME')
INSERT INTO product (org_id, code, name, description, unit_id, min_stock, procurement_type, item_type, status)
SELECT o.org_id, 'FG-SILLA', 'Silla Pro', 'Silla aluminio',
       (SELECT id FROM unit WHERE code='EA'), 30.00, 'MAKE', 'FG', TRUE
FROM o
WHERE NOT EXISTS (SELECT 1 FROM product pr WHERE pr.code='FG-SILLA' AND pr.org_id = o.org_id);

-- Consumibles
WITH o AS (SELECT id AS org_id FROM organization WHERE code='ACME')
INSERT INTO product (org_id, code, name, description, unit_id, min_stock, procurement_type, item_type, status)
SELECT o.org_id, 'CON-GUAN', 'Guantes Nitrilo', 'Consumible planta',
       (SELECT id FROM unit WHERE code='BOX'), 30.00, 'BUY', 'CONSUMABLE', TRUE
FROM o
WHERE NOT EXISTS (SELECT 1 FROM product pr WHERE pr.code='CON-GUAN' AND pr.org_id = o.org_id);

WITH o AS (SELECT id AS org_id FROM organization WHERE code='ACME')
INSERT INTO product (org_id, code, name, description, unit_id, min_stock, procurement_type, item_type, status)
SELECT o.org_id, 'CON-DISQ', 'Discos de corte', 'Consumible esmeril',
       (SELECT id FROM unit WHERE code='BOX'), 25.00, 'BUY', 'CONSUMABLE', TRUE
FROM o
WHERE NOT EXISTS (SELECT 1 FROM product pr WHERE pr.code='CON-DISQ' AND pr.org_id = o.org_id);

-- Servicio
WITH o AS (SELECT id AS org_id FROM organization WHERE code='ACME')
INSERT INTO product (org_id, code, name, description, unit_id, min_stock, procurement_type, item_type, status)
SELECT o.org_id, 'SRV-MANT', 'Mantenimiento básico', 'Servicio externo',
       NULL, 0.00, 'BUY', 'SERVICE', TRUE
FROM o
WHERE NOT EXISTS (SELECT 1 FROM product pr WHERE pr.code='SRV-MANT' AND pr.org_id = o.org_id);

-- ============================================================================
-- 14) STOCK INICIAL (product_warehouse)
-- ============================================================================

-- Principal
INSERT INTO product_warehouse (productid, warehouseid, stock)
SELECT p.id, w.id, 250.00
FROM product p
JOIN warehouse w ON w.name = 'Principal' AND w.org_id = p.org_id
WHERE p.code = 'RM-ALU'
  AND NOT EXISTS (SELECT 1 FROM product_warehouse pw WHERE pw.productid = p.id AND pw.warehouseid = w.id);

INSERT INTO product_warehouse (productid, warehouseid, stock)
SELECT p.id, w.id, 180.00
FROM product p
JOIN warehouse w ON w.name = 'Principal' AND w.org_id = p.org_id
WHERE p.code = 'RM-ACERO'
  AND NOT EXISTS (SELECT 1 FROM product_warehouse pw WHERE pw.productid = p.id AND pw.warehouseid = w.id);

INSERT INTO product_warehouse (productid, warehouseid, stock)
SELECT p.id, w.id, 80.00
FROM product p
JOIN warehouse w ON w.name = 'Principal' AND w.org_id = p.org_id
WHERE p.code = 'RM-PINT'
  AND NOT EXISTS (SELECT 1 FROM product_warehouse pw WHERE pw.productid = p.id AND pw.warehouseid = w.id);

INSERT INTO product_warehouse (productid, warehouseid, stock)
SELECT p.id, w.id, 60.00
FROM product p
JOIN warehouse w ON w.name = 'Principal' AND w.org_id = p.org_id
WHERE p.code = 'RM-TORN'
  AND NOT EXISTS (SELECT 1 FROM product_warehouse pw WHERE pw.productid = p.id AND pw.warehouseid = w.id);

INSERT INTO product_warehouse (productid, warehouseid, stock)
SELECT p.id, w.id, 10.00
FROM product p
JOIN warehouse w ON w.name = 'Principal' AND w.org_id = p.org_id
WHERE p.code = 'FG-MESA'
  AND NOT EXISTS (SELECT 1 FROM product_warehouse pw WHERE pw.productid = p.id AND pw.warehouseid = w.id);

INSERT INTO product_warehouse (productid, warehouseid, stock)
SELECT p.id, w.id, 6.00
FROM product p
JOIN warehouse w ON w.name = 'Principal' AND w.org_id = p.org_id
WHERE p.code = 'FG-SILLA'
  AND NOT EXISTS (SELECT 1 FROM product_warehouse pw WHERE pw.productid = p.id AND pw.warehouseid = w.id);

INSERT INTO product_warehouse (productid, warehouseid, stock)
SELECT p.id, w.id, 40.00
FROM product p
JOIN warehouse w ON w.name = 'Principal' AND w.org_id = p.org_id
WHERE p.code = 'CON-GUAN'
  AND NOT EXISTS (SELECT 1 FROM product_warehouse pw WHERE pw.productid = p.id AND pw.warehouseid = w.id);

INSERT INTO product_warehouse (productid, warehouseid, stock)
SELECT p.id, w.id, 20.00
FROM product p
JOIN warehouse w ON w.name = 'Principal' AND w.org_id = p.org_id
WHERE p.code = 'CON-DISQ'
  AND NOT EXISTS (SELECT 1 FROM product_warehouse pw WHERE pw.productid = p.id AND pw.warehouseid = w.id);

-- Secundario
INSERT INTO product_warehouse (productid, warehouseid, stock)
SELECT p.id, w.id, 30.00
FROM product p
JOIN warehouse w ON w.name = 'Secundario' AND w.org_id = p.org_id
WHERE p.code = 'RM-ALU'
  AND NOT EXISTS (SELECT 1 FROM product_warehouse pw WHERE pw.productid = p.id AND pw.warehouseid = w.id);

INSERT INTO product_warehouse (productid, warehouseid, stock)
SELECT p.id, w.id, 25.00
FROM product p
JOIN warehouse w ON w.name = 'Secundario' AND w.org_id = p.org_id
WHERE p.code = 'RM-ACERO'
  AND NOT EXISTS (SELECT 1 FROM product_warehouse pw WHERE pw.productid = p.id AND pw.warehouseid = w.id);

INSERT INTO product_warehouse (productid, warehouseid, stock)
SELECT p.id, w.id, 5.00
FROM product p
JOIN warehouse w ON w.name = 'Secundario' AND w.org_id = p.org_id
WHERE p.code = 'FG-MESA'
  AND NOT EXISTS (SELECT 1 FROM product_warehouse pw WHERE pw.productid = p.id AND pw.warehouseid = w.id);

INSERT INTO product_warehouse (productid, warehouseid, stock)
SELECT p.id, w.id, 3.00
FROM product p
JOIN warehouse w ON w.name = 'Secundario' AND w.org_id = p.org_id
WHERE p.code = 'FG-SILLA'
  AND NOT EXISTS (SELECT 1 FROM product_warehouse pw WHERE pw.productid = p.id AND pw.warehouseid = w.id);

-- Devoluciones
INSERT INTO product_warehouse (productid, warehouseid, stock)
SELECT p.id, w.id, 5.00
FROM product p
JOIN warehouse w ON w.name = 'Devoluciones' AND w.org_id = p.org_id
WHERE p.code = 'RM-ALU'
  AND NOT EXISTS (SELECT 1 FROM product_warehouse pw WHERE pw.productid = p.id AND pw.warehouseid = w.id);

INSERT INTO product_warehouse (productid, warehouseid, stock)
SELECT p.id, w.id, 2.00
FROM product p
JOIN warehouse w ON w.name = 'Devoluciones' AND w.org_id = p.org_id
WHERE p.code = 'CON-GUAN'
  AND NOT EXISTS (SELECT 1 FROM product_warehouse pw WHERE pw.productid = p.id AND pw.warehouseid = w.id);

-- ============================================================================
-- 15) PROVEEDORES
-- ============================================================================
INSERT INTO supplier (name, phone, mobile, address, city, email, org_id, status)
SELECT 'Metales Andinos', '221122', NULL, 'Av. Los Andes 123', 'La Paz', 'ventas@metales.com', o.id, TRUE
FROM organization o WHERE o.code = 'ACME'
  AND NOT EXISTS (SELECT 1 FROM supplier s WHERE s.name = 'Metales Andinos' AND s.org_id = o.id);

INSERT INTO supplier (name, phone, mobile, address, city, email, org_id, status)
SELECT 'Aceros Bolivia', '335500', NULL, 'Calle Acero 77', 'Santa Cruz', 'ventas@acerosbo.com', o.id, TRUE
FROM organization o WHERE o.code = 'ACME'
  AND NOT EXISTS (SELECT 1 FROM supplier s WHERE s.name = 'Aceros Bolivia' AND s.org_id = o.id);

INSERT INTO supplier (name, phone, mobile, address, city, email, org_id, status)
SELECT 'Quimex Industrial', '334455', NULL, 'Calle 7 #456', 'Cochabamba', 'ventas@quimex.com', o.id, TRUE
FROM organization o WHERE o.code = 'ACME'
  AND NOT EXISTS (SELECT 1 FROM supplier s WHERE s.name = 'Quimex Industrial' AND s.org_id = o.id);

INSERT INTO supplier (name, phone, mobile, address, city, email, org_id, status)
SELECT 'FerreCenter', '778899', NULL, 'Av. Panamericana', 'Santa Cruz', 'contacto@ferrecenter.bo', o.id, TRUE
FROM organization o WHERE o.code = 'ACME'
  AND NOT EXISTS (SELECT 1 FROM supplier s WHERE s.name = 'FerreCenter' AND s.org_id = o.id);

INSERT INTO supplier (name, phone, mobile, address, city, email, org_id, status)
SELECT 'Insumos Global', '446677', NULL, 'Av. América 1200', 'Cochabamba', 'ventas@insumosglobal.bo', o.id, TRUE
FROM organization o WHERE o.code = 'ACME'
  AND NOT EXISTS (SELECT 1 FROM supplier s WHERE s.name = 'Insumos Global' AND s.org_id = o.id);

-- ============================================================================
-- 16) SUPPLIER_ITEM (Catálogo Proveedor-Producto)
-- ============================================================================

-- RM-ALU: Metales Andinos (preferido), Insumos Global
INSERT INTO supplier_item (org_id, product_id, supplier_id, price, currency, lead_time_days, min_order_qty, pack_size, is_preferred, is_active)
SELECT o.id, p.id, s.id, 107.5000, 'BOB', 7, 50.00, 10.00, TRUE, TRUE
FROM organization o
JOIN product p ON p.org_id = o.id AND p.code = 'RM-ALU'
JOIN supplier s ON s.org_id = o.id AND s.name = 'Metales Andinos'
WHERE o.code = 'ACME'
  AND NOT EXISTS (
    SELECT 1 FROM supplier_item si
    WHERE si.product_id = p.id AND si.supplier_id = s.id
  );

INSERT INTO supplier_item (org_id, product_id, supplier_id, price, currency, lead_time_days, min_order_qty, pack_size, is_preferred, is_active)
SELECT o.id, p.id, s.id, 112.0000, 'BOB', 10, 30.00, 10.00, FALSE, TRUE
FROM organization o
JOIN product p ON p.org_id = o.id AND p.code = 'RM-ALU'
JOIN supplier s ON s.org_id = o.id AND s.name = 'Insumos Global'
WHERE o.code = 'ACME'
  AND NOT EXISTS (
    SELECT 1 FROM supplier_item si
    WHERE si.product_id = p.id AND si.supplier_id = s.id
  );

-- RM-ACERO: Aceros Bolivia (preferido), Metales Andinos
INSERT INTO supplier_item (org_id, product_id, supplier_id, price, currency, lead_time_days, min_order_qty, pack_size, is_preferred, is_active)
SELECT o.id, p.id, s.id, 89.9000, 'BOB', 6, 80.00, 20.00, TRUE, TRUE
FROM organization o
JOIN product p ON p.org_id = o.id AND p.code = 'RM-ACERO'
JOIN supplier s ON s.org_id = o.id AND s.name = 'Aceros Bolivia'
WHERE o.code = 'ACME'
  AND NOT EXISTS (
    SELECT 1 FROM supplier_item si
    WHERE si.product_id = p.id AND si.supplier_id = s.id
  );

INSERT INTO supplier_item (org_id, product_id, supplier_id, price, currency, lead_time_days, min_order_qty, pack_size, is_preferred, is_active)
SELECT o.id, p.id, s.id, 92.0000, 'BOB', 8, 60.00, 20.00, FALSE, TRUE
FROM organization o
JOIN product p ON p.org_id = o.id AND p.code = 'RM-ACERO'
JOIN supplier s ON s.org_id = o.id AND s.name = 'Metales Andinos'
WHERE o.code = 'ACME'
  AND NOT EXISTS (
    SELECT 1 FROM supplier_item si
    WHERE si.product_id = p.id AND si.supplier_id = s.id
  );

-- RM-PINT: Quimex (preferido), FerreCenter
INSERT INTO supplier_item (org_id, product_id, supplier_id, price, currency, lead_time_days, min_order_qty, pack_size, is_preferred, is_active)
SELECT o.id, p.id, s.id, 58.2500, 'BOB', 5, 20.00, 5.00, TRUE, TRUE
FROM organization o
JOIN product p ON p.org_id = o.id AND p.code = 'RM-PINT'
JOIN supplier s ON s.org_id = o.id AND s.name = 'Quimex Industrial'
WHERE o.code = 'ACME'
  AND NOT EXISTS (
    SELECT 1 FROM supplier_item si
    WHERE si.product_id = p.id AND si.supplier_id = s.id
  );

INSERT INTO supplier_item (org_id, product_id, supplier_id, price, currency, lead_time_days, min_order_qty, pack_size, is_preferred, is_active)
SELECT o.id, p.id, s.id, 61.0000, 'BOB', 4, 15.00, 5.00, FALSE, TRUE
FROM organization o
JOIN product p ON p.org_id = o.id AND p.code = 'RM-PINT'
JOIN supplier s ON s.org_id = o.id AND s.name = 'FerreCenter'
WHERE o.code = 'ACME'
  AND NOT EXISTS (
    SELECT 1 FROM supplier_item si
    WHERE si.product_id = p.id AND si.supplier_id = s.id
  );

-- RM-TORN: FerreCenter (preferido), Insumos Global
INSERT INTO supplier_item (org_id, product_id, supplier_id, price, currency, lead_time_days, min_order_qty, pack_size, is_preferred, is_active)
SELECT o.id, p.id, s.id, 35.0000, 'BOB', 3, 10.00, 10.00, TRUE, TRUE
FROM organization o
JOIN product p ON p.org_id = o.id AND p.code = 'RM-TORN'
JOIN supplier s ON s.org_id = o.id AND s.name = 'FerreCenter'
WHERE o.code = 'ACME'
  AND NOT EXISTS (
    SELECT 1 FROM supplier_item si
    WHERE si.product_id = p.id AND si.supplier_id = s.id
  );

INSERT INTO supplier_item (org_id, product_id, supplier_id, price, currency, lead_time_days, min_order_qty, pack_size, is_preferred, is_active)
SELECT o.id, p.id, s.id, 37.5000, 'BOB', 4, 10.00, 10.00, FALSE, TRUE
FROM organization o
JOIN product p ON p.org_id = o.id AND p.code = 'RM-TORN'
JOIN supplier s ON s.org_id = o.id AND s.name = 'Insumos Global'
WHERE o.code = 'ACME'
  AND NOT EXISTS (
    SELECT 1 FROM supplier_item si
    WHERE si.product_id = p.id AND si.supplier_id = s.id
  );

-- RM-MAD: Insumos Global (preferido)
INSERT INTO supplier_item (org_id, product_id, supplier_id, price, currency, lead_time_days, min_order_qty, pack_size, is_preferred, is_active)
SELECT o.id, p.id, s.id, 70.0000, 'BOB', 6, 25.00, 5.00, TRUE, TRUE
FROM organization o
JOIN product p ON p.org_id = o.id AND p.code = 'RM-MAD'
JOIN supplier s ON s.org_id = o.id AND s.name = 'Insumos Global'
WHERE o.code = 'ACME'
  AND NOT EXISTS (
    SELECT 1 FROM supplier_item si
    WHERE si.product_id = p.id AND si.supplier_id = s.id
  );

-- CON-GUAN: Insumos Global (preferido)
INSERT INTO supplier_item (org_id, product_id, supplier_id, price, currency, lead_time_days, min_order_qty, pack_size, is_preferred, is_active)
SELECT o.id, p.id, s.id, 8.5000, 'BOB', 3, 50.00, 10.00, TRUE, TRUE
FROM organization o
JOIN product p ON p.org_id = o.id AND p.code = 'CON-GUAN'
JOIN supplier s ON s.org_id = o.id AND s.name = 'Insumos Global'
WHERE o.code = 'ACME'
  AND NOT EXISTS (
    SELECT 1 FROM supplier_item si
    WHERE si.product_id = p.id AND si.supplier_id = s.id
  );

-- CON-DISQ: FerreCenter (preferido)
INSERT INTO supplier_item (org_id, product_id, supplier_id, price, currency, lead_time_days, min_order_qty, pack_size, is_preferred, is_active)
SELECT o.id, p.id, s.id, 25.0000, 'BOB', 2, 20.00, 10.00, TRUE, TRUE
FROM organization o
JOIN product p ON p.org_id = o.id AND p.code = 'CON-DISQ'
JOIN supplier s ON s.org_id = o.id AND s.name = 'FerreCenter'
WHERE o.code = 'ACME'
  AND NOT EXISTS (
    SELECT 1 FROM supplier_item si
    WHERE si.product_id = p.id AND si.supplier_id = s.id
  );

-- ============================================================================
-- SPRINT 3: BOMS Y WORK ORDERS DE EJEMPLO
-- ============================================================================

-- ============================================================================
-- 17) BOMS (Listas de Materiales)
-- ============================================================================

-- BOM para FG-MESA (Mesa de madera con tornillos y pintura)
-- Componentes: RM-MAD (Madera), RM-TORN (Tornillos), RM-PINT (Pintura)
INSERT INTO bom (org_id, product_id, version, is_active, description)
SELECT o.id, p.id, '1.0', TRUE, 'BOM estándar para mesa de madera'
FROM organization o
JOIN product p ON p.org_id = o.id AND p.code = 'FG-MESA'
WHERE o.code = 'ACME'
  AND NOT EXISTS (SELECT 1 FROM bom WHERE org_id = o.id AND product_id = p.id AND version = '1.0');

-- Componentes de la BOM FG-MESA
-- 4 unidades de madera
INSERT INTO bom_component (bom_id, component_id, quantity, scrap_percentage, unit_id, sequence, notes)
SELECT b.id, p.id, 4.0, 5.0, u.id, 1, 'Tableros de madera principal'
FROM bom b
JOIN product p_main ON p_main.id = b.product_id AND p_main.code = 'FG-MESA'
JOIN product p ON p.code = 'RM-MAD' AND p.org_id = b.org_id
JOIN unit u ON u.code = 'EA'
WHERE NOT EXISTS (SELECT 1 FROM bom_component WHERE bom_id = b.id AND component_id = p.id);

-- 16 tornillos
INSERT INTO bom_component (bom_id, component_id, quantity, scrap_percentage, unit_id, sequence, notes)
SELECT b.id, p.id, 16.0, 3.0, u.id, 2, 'Tornillos de ensamblaje'
FROM bom b
JOIN product p_main ON p_main.id = b.product_id AND p_main.code = 'FG-MESA'
JOIN product p ON p.code = 'RM-TORN' AND p.org_id = b.org_id
JOIN unit u ON u.code = 'EA'
WHERE NOT EXISTS (SELECT 1 FROM bom_component WHERE bom_id = b.id AND component_id = p.id);

-- 0.5 litros de pintura
INSERT INTO bom_component (bom_id, component_id, quantity, scrap_percentage, unit_id, sequence, notes)
SELECT b.id, p.id, 0.5, 8.0, u.id, 3, 'Pintura de acabado'
FROM bom b
JOIN product p_main ON p_main.id = b.product_id AND p_main.code = 'FG-MESA'
JOIN product p ON p.code = 'RM-PINT' AND p.org_id = b.org_id
JOIN unit u ON u.code = 'L'
WHERE NOT EXISTS (SELECT 1 FROM bom_component WHERE bom_id = b.id AND component_id = p.id);

-- BOM para FG-SILLA (Silla de madera y aluminio)
-- Componentes: RM-MAD (Madera), RM-ALU (Aluminio), RM-TORN (Tornillos)
INSERT INTO bom (org_id, product_id, version, is_active, description)
SELECT o.id, p.id, '1.0', TRUE, 'BOM estándar para silla'
FROM organization o
JOIN product p ON p.org_id = o.id AND p.code = 'FG-SILLA'
WHERE o.code = 'ACME'
  AND NOT EXISTS (SELECT 1 FROM bom WHERE org_id = o.id AND product_id = p.id AND version = '1.0');

-- Componentes de la BOM FG-SILLA
-- 2 unidades de madera
INSERT INTO bom_component (bom_id, component_id, quantity, scrap_percentage, unit_id, sequence, notes)
SELECT b.id, p.id, 2.0, 4.0, u.id, 1, 'Tableros para asiento y respaldo'
FROM bom b
JOIN product p_main ON p_main.id = b.product_id AND p_main.code = 'FG-SILLA'
JOIN product p ON p.code = 'RM-MAD' AND p.org_id = b.org_id
JOIN unit u ON u.code = 'EA'
WHERE NOT EXISTS (SELECT 1 FROM bom_component WHERE bom_id = b.id AND component_id = p.id);

-- 1.5 kg de aluminio (estructura)
INSERT INTO bom_component (bom_id, component_id, quantity, scrap_percentage, unit_id, sequence, notes)
SELECT b.id, p.id, 1.5, 6.0, u.id, 2, 'Estructura de aluminio'
FROM bom b
JOIN product p_main ON p_main.id = b.product_id AND p_main.code = 'FG-SILLA'
JOIN product p ON p.code = 'RM-ALU' AND p.org_id = b.org_id
JOIN unit u ON u.code = 'KG'
WHERE NOT EXISTS (SELECT 1 FROM bom_component WHERE bom_id = b.id AND component_id = p.id);

-- 12 tornillos
INSERT INTO bom_component (bom_id, component_id, quantity, scrap_percentage, unit_id, sequence, notes)
SELECT b.id, p.id, 12.0, 3.0, u.id, 3, 'Tornillos de ensamblaje'
FROM bom b
JOIN product p_main ON p_main.id = b.product_id AND p_main.code = 'FG-SILLA'
JOIN product p ON p.code = 'RM-TORN' AND p.org_id = b.org_id
JOIN unit u ON u.code = 'EA'
WHERE NOT EXISTS (SELECT 1 FROM bom_component WHERE bom_id = b.id AND component_id = p.id);

-- ============================================================================
-- 18) WORK ORDERS (Órdenes de Producción de ejemplo)
-- ============================================================================

-- Work Order 1: Producir 5 MESAS (Estado: Planificada)
INSERT INTO work_order (org_id, product_id, bom_id, quantity, status, warehouse_id, reference, notes, planned_start, planned_end, created_by)
SELECT o.id, p.id, b.id, 5.00, 'Planificada', w.id, 'OP-2025-001', 'Orden inicial de producción de mesas', 
       CURRENT_DATE + INTERVAL '1 day', CURRENT_DATE + INTERVAL '3 days', u.id
FROM organization o
JOIN product p ON p.org_id = o.id AND p.code = 'FG-MESA'
JOIN bom b ON b.product_id = p.id AND b.version = '1.0' AND b.is_active = TRUE
JOIN warehouse w ON w.org_id = o.id AND w.name = 'Principal'
JOIN "user" u ON u.email = 'planner@acme.com'
WHERE o.code = 'ACME'
  AND NOT EXISTS (SELECT 1 FROM work_order WHERE org_id = o.id AND reference = 'OP-2025-001');

-- Work Order 2: Producir 10 SILLAS (Estado: Planificada)
INSERT INTO work_order (org_id, product_id, bom_id, quantity, status, warehouse_id, reference, notes, planned_start, planned_end, created_by, assigned_to)
SELECT o.id, p.id, b.id, 10.00, 'Planificada', w.id, 'OP-2025-002', 'Orden de producción de sillas para stock', 
       CURRENT_DATE + INTERVAL '2 days', CURRENT_DATE + INTERVAL '5 days', u_creator.id, u_assigned.id
FROM organization o
JOIN product p ON p.org_id = o.id AND p.code = 'FG-SILLA'
JOIN bom b ON b.product_id = p.id AND b.version = '1.0' AND b.is_active = TRUE
JOIN warehouse w ON w.org_id = o.id AND w.name = 'Principal'
JOIN "user" u_creator ON u_creator.email = 'planner@acme.com'
JOIN "user" u_assigned ON u_assigned.email = 'op@acme.com'
WHERE o.code = 'ACME'
  AND NOT EXISTS (SELECT 1 FROM work_order WHERE org_id = o.id AND reference = 'OP-2025-002');

-- ============================================================================
-- FIN DE SEEDS COMPLETOS - SPRINTS 1-3
-- ============================================================================

-- RESUMEN COMPLETO:
-- ✓ 3 Planes SaaS (Free, Starter, Pro)
-- ✓ 2 Organizaciones (ACME, GLOBEX) con suscripción Starter
-- ✓ 8 Unidades de medida
-- ✓ 4 Roles (Admin, Planner, Supervisor, Operator)
-- ✓ 8 Recursos con 30 Subrecursos (menú completo 5 sprints)
--   - Sprint 1: 11 subrecursos (Dashboard, Inventario, Proveedores, Admin)
--   - Sprint 2: 6 subrecursos (Reportes, Sistema, Org/Planes)
--   - Sprint 3: 4 subrecursos (Producción: BOM, WO, Ejecución, Reportes)
--   - Sprint 4: 5 subrecursos (Planificación: Demanda, MPS, MRP, Propuestas, Plan vs Ejecución)
--   - Sprint 5: 4 subrecursos (Forecast, Alertas, Dashboard Avanzado, App Móvil)
-- ✓ Permisos asignados:
--   - Admin: Todos los 30 subrecursos
--   - Planner: Inventario + Proveedores + Planificación + Producción (BOM/WO) + Inicio
--   - Supervisor: Inventario parcial + Producción (WO/Reportes) + Inicio
--   - Operator: Movimientos + Ejecución Producción + Inicio
-- ✓ 4 Usuarios (admin@acme.com, planner@acme.com, super@acme.com, op@acme.com)
-- ✓ 3 Almacenes (Principal, Secundario, Devoluciones)
-- ✓ 10 Productos (5 RM, 2 FG, 2 Consumibles, 1 Servicio)
-- ✓ Stock inicial en 3 almacenes con cantidades realistas
-- ✓ 5 Proveedores bolivianos (La Paz, Santa Cruz, Cochabamba)
-- ✓ 10 relaciones supplier_item con precios en BOB
-- ✓ 2 BOMs activas (FG-MESA v1.0, FG-SILLA v1.0)
-- ✓ 2 Work Orders planificadas (OP-2025-001: 5 mesas, OP-2025-002: 10 sillas)

-- Contraseñas de usuarios (se hashean automáticamente en primer login):
-- admin@acme.com: admin123
-- planner@acme.com: planner123
-- super@acme.com: super123
-- op@acme.com: op123

SELECT 'Seeds completos cargados exitosamente - Sprints 1-3' AS status;
--
-- NOTAS:
-- 1. Contraseñas en texto plano (admin123, planner123, etc.)
--    El sistema las hashea automáticamente en el primer login
-- 2. Todos los usuarios pertenecen a la org ACME
-- 3. Tabla product_warehouse usa productid, warehouseid, stock
-- 4. Idempotente: puede ejecutarse múltiples veces sin duplicar
