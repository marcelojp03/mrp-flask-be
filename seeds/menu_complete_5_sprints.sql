-- ============================================================================
-- MENÚ COMPLETO - 5 SPRINTS
-- Sprint 1: Fundamentos (Auth, Inventario, Proveedores, Dashboard)
-- Sprint 2: SaaS + Logs + Reportes + Backup
-- Sprint 3: Producción (BOM + Work Orders)
-- Sprint 4: Planificación (Demanda, MPS, MRP)
-- Sprint 5: Inteligencia (Forecast, Alertas, Dashboard Avanzado)
-- ============================================================================

-- ============================================================================
-- RECURSOS (8 módulos principales)
-- ============================================================================

INSERT INTO resource (name, description) VALUES
('Inicio', 'Pantalla principal / Dashboard'),
('Inventario', 'Gestión de inventario y stock'),
('Producción', 'BOM, órdenes y ejecución'),
('Proveedores', 'Maestro de proveedores'),
('Planificación', 'Demanda, MPS y MRP'),
('Administración', 'Usuarios, Roles y Seguridad'),
('Reportes', 'Generación de reportes'),
('Sistema', 'Configuración y mantenimiento')
ON CONFLICT (name) DO NOTHING;

-- ============================================================================
-- SUBRECURSOS (por Sprint)
-- ============================================================================

-- ============================================================================
-- SPRINT 1: Fundamentos
-- ============================================================================

-- Inicio (S1)
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Dashboard', 'Indicadores y KPIs', '/dashboard', 'pi pi-home'
FROM resource r WHERE r.name = 'Inicio'
ON CONFLICT DO NOTHING;

-- Inventario (S1)
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Productos', 'ABM de productos', '/dashboard/products', 'pi pi-box'
FROM resource r WHERE r.name = 'Inventario'
ON CONFLICT DO NOTHING;

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Almacenes', 'ABM de almacenes', '/dashboard/warehouses', 'pi pi-building'
FROM resource r WHERE r.name = 'Inventario'
ON CONFLICT DO NOTHING;

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Movimientos', 'Entradas/Salidas/Transferencias/Ajustes', '/dashboard/movements', 'pi pi-exchange'
FROM resource r WHERE r.name = 'Inventario'
ON CONFLICT DO NOTHING;

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Stock Bajo', 'Alertas de stock bajo', '/dashboard/stocks/low', 'pi pi-exclamation-triangle'
FROM resource r WHERE r.name = 'Inventario'
ON CONFLICT DO NOTHING;

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Sugerencias', 'Sugerencias de reposición', '/dashboard/stocks/reorder-suggestions', 'pi pi-refresh'
FROM resource r WHERE r.name = 'Inventario'
ON CONFLICT DO NOTHING;

-- Proveedores (S1)
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Proveedores', 'ABM de proveedores', '/dashboard/suppliers', 'pi pi-truck'
FROM resource r WHERE r.name = 'Proveedores'
ON CONFLICT DO NOTHING;

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Catálogo Proveedor', 'Relación proveedor–producto', '/dashboard/suppliers/supplier-items', 'pi pi-link'
FROM resource r WHERE r.name = 'Proveedores'
ON CONFLICT DO NOTHING;

-- Administración (S1)
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Usuarios', 'ABM usuarios', '/dashboard/users', 'pi pi-user'
FROM resource r WHERE r.name = 'Administración'
ON CONFLICT DO NOTHING;

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Roles', 'ABM roles', '/dashboard/roles', 'pi pi-shield'
FROM resource r WHERE r.name = 'Administración'
ON CONFLICT DO NOTHING;

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Recursos/ACL', 'ABM recursos y subrecursos', '/dashboard/acl', 'pi pi-list'
FROM resource r WHERE r.name = 'Administración'
ON CONFLICT DO NOTHING;

-- ============================================================================
-- SPRINT 2: SaaS + Logs + Reportes + Backup
-- ============================================================================

-- Reportes (S2)
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Exportar CSV', 'Exportar datos a CSV', '/dashboard/reports/csv', 'pi pi-file-export'
FROM resource r WHERE r.name = 'Reportes'
ON CONFLICT DO NOTHING;

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Reportes IA', 'Generador de reportes con IA (limitado)', '/dashboard/reports/ai', 'pi pi-sparkles'
FROM resource r WHERE r.name = 'Reportes'
ON CONFLICT DO NOTHING;

-- Sistema (S2)
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Logs', 'Auditoría del sistema', '/dashboard/system/logs', 'pi pi-file'
FROM resource r WHERE r.name = 'Sistema'
ON CONFLICT DO NOTHING;

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Backup', 'Respaldo de datos por organización', '/dashboard/system/backup', 'pi pi-database'
FROM resource r WHERE r.name = 'Sistema'
ON CONFLICT DO NOTHING;

-- Administración (S2)
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Organizaciones', 'Gestión de empresas multi-tenant', '/dashboard/organizations', 'pi pi-building-columns'
FROM resource r WHERE r.name = 'Administración'
ON CONFLICT DO NOTHING;

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Planes SaaS', 'Gestión de planes y suscripciones', '/dashboard/plans', 'pi pi-credit-card'
FROM resource r WHERE r.name = 'Administración'
ON CONFLICT DO NOTHING;

-- ============================================================================
-- SPRINT 3: Producción (BOM + Work Orders)
-- ============================================================================

-- Producción (S3)
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Lista de Materiales (BOM)', 'Gestión de BOMs por producto', '/dashboard/production/boms', 'pi pi-sitemap'
FROM resource r WHERE r.name = 'Producción'
ON CONFLICT DO NOTHING;

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Órdenes de Producción', 'Gestión de Work Orders', '/dashboard/production/work-orders', 'pi pi-cog'
FROM resource r WHERE r.name = 'Producción'
ON CONFLICT DO NOTHING;

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Ejecución de Producción', 'Iniciar/Finalizar órdenes (operarios)', '/dashboard/production/execution', 'pi pi-play'
FROM resource r WHERE r.name = 'Producción'
ON CONFLICT DO NOTHING;

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Reportes de Producción', 'OPs activas, finalizadas, materiales consumidos', '/dashboard/production/reports', 'pi pi-chart-bar'
FROM resource r WHERE r.name = 'Producción'
ON CONFLICT DO NOTHING;

-- ============================================================================
-- SPRINT 4: Planificación (Demanda, MPS, MRP)
-- ============================================================================

-- Planificación (S4)
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Demanda', 'Carga de demanda de productos', '/dashboard/planning/demand', 'pi pi-database'
FROM resource r WHERE r.name = 'Planificación'
ON CONFLICT DO NOTHING;

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'MPS', 'Plan Maestro de Producción', '/dashboard/planning/mps', 'pi pi-calendar'
FROM resource r WHERE r.name = 'Planificación'
ON CONFLICT DO NOTHING;

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'MRP', 'Requerimientos de Materiales', '/dashboard/planning/mrp', 'pi pi-sitemap'
FROM resource r WHERE r.name = 'Planificación'
ON CONFLICT DO NOTHING;

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Propuestas MRP', 'Aprobar/Rechazar propuestas de compra/producción', '/dashboard/planning/proposals', 'pi pi-check-square'
FROM resource r WHERE r.name = 'Planificación'
ON CONFLICT DO NOTHING;

INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Plan vs Ejecución', 'Comparativa de plan vs real', '/dashboard/planning/plan-vs-execution', 'pi pi-chart-line'
FROM resource r WHERE r.name = 'Planificación'
ON CONFLICT DO NOTHING;

-- ============================================================================
-- SPRINT 5: Inteligencia (Forecast, Alertas, Dashboard Avanzado)
-- ============================================================================

-- Planificación (S5 - Forecast)
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Forecast', 'Pronóstico de demanda (IA simple)', '/dashboard/planning/forecast', 'pi pi-chart-line'
FROM resource r WHERE r.name = 'Planificación'
ON CONFLICT DO NOTHING;

-- Sistema (S5 - Alertas)
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Alertas Inteligentes', 'Notificaciones de stock, retrasos, etc.', '/dashboard/system/alerts', 'pi pi-bell'
FROM resource r WHERE r.name = 'Sistema'
ON CONFLICT DO NOTHING;

-- Reportes (S5 - Dashboard Avanzado)
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'Dashboard Avanzado', 'KPIs, rotación, cumplimiento MPS', '/dashboard/reports/advanced', 'pi pi-chart-pie'
FROM resource r WHERE r.name = 'Reportes'
ON CONFLICT DO NOTHING;

-- Producción (S5 - Móvil avanzado)
INSERT INTO subresource (resource_id, name, description, url, icon)
SELECT r.id, 'App Móvil Producción', 'QR, push notifications, tiempos', '/dashboard/production/mobile', 'pi pi-mobile'
FROM resource r WHERE r.name = 'Producción'
ON CONFLICT DO NOTHING;

-- ============================================================================
-- RESUMEN DE SUBRECURSOS POR SPRINT
-- ============================================================================
-- Sprint 1: 11 subrecursos (Dashboard, Inventario 5, Proveedores 2, Admin 3)
-- Sprint 2: 6 subrecursos (Reportes 2, Sistema 2, Admin 2)
-- Sprint 3: 4 subrecursos (Producción 4)
-- Sprint 4: 5 subrecursos (Planificación 5)
-- Sprint 5: 4 subrecursos (Forecast, Alertas, Dashboard Avanzado, Móvil)
-- TOTAL: 30 subrecursos

SELECT 'Menú completo de 5 sprints creado: 8 recursos, 30 subrecursos' AS status;
