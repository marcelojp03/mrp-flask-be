-- ============================================================================
-- CLEAN DATABASE - MRP System
-- ============================================================================
-- Este script ELIMINA todos los datos de las tablas, preservando la estructura.
-- USAR CON PRECAUCIÓN: Esto borrará TODOS los datos.
-- ============================================================================

-- IMPORTANTE: Ejecutar en orden para respetar las foreign keys

-- ============================================================================
-- 1) DATOS DE NEGOCIO (orden inverso a la creación)
-- ============================================================================

-- Catálogo Proveedor-Producto
TRUNCATE TABLE supplier_item CASCADE;

-- Proveedores
TRUNCATE TABLE supplier CASCADE;

-- Stock
TRUNCATE TABLE product_warehouse CASCADE;

-- Productos
TRUNCATE TABLE product CASCADE;

-- Almacenes
TRUNCATE TABLE warehouse CASCADE;

-- ============================================================================
-- 2) USUARIOS Y PERMISOS
-- ============================================================================

-- User-Organization
TRUNCATE TABLE user_organization CASCADE;

-- User-Role
TRUNCATE TABLE user_role CASCADE;

-- Usuarios
TRUNCATE TABLE "user" CASCADE;

-- Role-Resource (permisos)
TRUNCATE TABLE role_resource CASCADE;

-- ============================================================================
-- 3) MENÚ Y ACL
-- ============================================================================

-- Subrecursos
TRUNCATE TABLE subresource CASCADE;

-- Recursos
TRUNCATE TABLE resource CASCADE;

-- Roles
TRUNCATE TABLE role CASCADE;

-- ============================================================================
-- 4) CONFIGURACIÓN DEL SISTEMA
-- ============================================================================

-- Suscripciones
TRUNCATE TABLE org_subscription CASCADE;

-- Organizaciones
TRUNCATE TABLE organization CASCADE;

-- Unidades
TRUNCATE TABLE unit CASCADE;

-- Planes
TRUNCATE TABLE plan CASCADE;

-- ============================================================================
-- 5) AUDITORÍA Y LOGS (OPCIONAL - Descomentar si quieres limpiar)
-- ============================================================================

-- TRUNCATE TABLE system_log CASCADE;
-- TRUNCATE TABLE bitacora CASCADE;
-- TRUNCATE TABLE bitacora_detalle CASCADE;

-- ============================================================================
-- RESET SEQUENCES (Para que los IDs vuelvan a empezar en 1)
-- ============================================================================

-- Planes
ALTER SEQUENCE IF EXISTS plan_id_seq RESTART WITH 1;

-- Organizaciones
ALTER SEQUENCE IF EXISTS organization_id_seq RESTART WITH 1;

-- Suscripciones
ALTER SEQUENCE IF EXISTS org_subscription_id_seq RESTART WITH 1;

-- Unidades
ALTER SEQUENCE IF EXISTS unit_id_seq RESTART WITH 1;

-- Roles
ALTER SEQUENCE IF EXISTS role_id_seq RESTART WITH 1;

-- Recursos
ALTER SEQUENCE IF EXISTS resource_id_seq RESTART WITH 1;

-- Subrecursos
ALTER SEQUENCE IF EXISTS subresource_id_seq RESTART WITH 1;

-- Role-Resource
ALTER SEQUENCE IF EXISTS role_resource_id_seq RESTART WITH 1;

-- Usuarios
ALTER SEQUENCE IF EXISTS user_id_seq RESTART WITH 1;

-- Almacenes
ALTER SEQUENCE IF EXISTS warehouse_id_seq RESTART WITH 1;

-- Productos
ALTER SEQUENCE IF EXISTS product_id_seq RESTART WITH 1;

-- Proveedores
ALTER SEQUENCE IF EXISTS supplier_id_seq RESTART WITH 1;

-- Supplier Item
ALTER SEQUENCE IF EXISTS supplier_item_id_seq RESTART WITH 1;

-- Product Warehouse
-- ALTER SEQUENCE IF EXISTS product_warehouse_id_seq RESTART WITH 1;

-- ============================================================================
-- FIN DE LIMPIEZA
-- ============================================================================

-- MENSAJE
SELECT 'Base de datos limpiada exitosamente. Los IDs comenzarán desde 1.' AS resultado;
