-- ========================================
-- DATA DE DESARROLLO (SOLO PARA TESTING)
-- NO ejecutar en producción
-- ========================================

-- Prerrequisito: production_seeds.sql debe estar ejecutado

-- =========================
-- ORGANIZACIÓN DE PRUEBA
-- =========================
INSERT INTO organization (name, code, is_active) VALUES
  ('Demo Corp', 'DEMO', TRUE)
ON CONFLICT DO NOTHING;

-- =========================
-- USUARIO DE PRUEBA
-- =========================
-- Contraseña: demo123 (texto plano para desarrollo)
INSERT INTO "user" (name, email, password, status) VALUES
  ('Demo Admin', 'demo@demo.com', 'demo123', TRUE)
ON CONFLICT (email) DO NOTHING;

-- =========================
-- ASIGNAR ROL ADMIN AL USUARIO DEMO
-- =========================
INSERT INTO user_role (user_id, role_id)
SELECT u.id, r.id FROM "user" u, role r
WHERE u.email = 'demo@demo.com' AND r.name = 'Admin'
ON CONFLICT DO NOTHING;

-- =========================
-- ASIGNAR USUARIO A ORGANIZACIÓN
-- =========================
INSERT INTO user_organization (user_id, org_id, is_default)
SELECT u.id, o.id, TRUE
FROM "user" u
JOIN organization o ON o.code = 'DEMO'
WHERE u.email = 'demo@demo.com'
ON CONFLICT DO NOTHING;

-- =========================
-- SUSCRIPCIÓN (Plan Free con trial)
-- =========================
INSERT INTO org_subscription (org_id, plan_id, status, trial_until, started_at)
SELECT o.id, p.id, 'active', NOW() + INTERVAL '14 days', NOW()
FROM organization o
JOIN plan p ON p.code = 'FREE'
WHERE o.code = 'DEMO'
ON CONFLICT DO NOTHING;

-- =========================
-- ALMACÉN PRINCIPAL
-- =========================
INSERT INTO warehouse (name, location, org_id)
SELECT 'Principal', 'Almacén Central', o.id
FROM organization o
WHERE o.code = 'DEMO'
ON CONFLICT DO NOTHING;

-- =========================
-- PRODUCTOS DEMO
-- =========================
WITH demo_org AS (SELECT id FROM organization WHERE code='DEMO'),
     unit_ea AS (SELECT id FROM unit WHERE code='EA'),
     unit_kg AS (SELECT id FROM unit WHERE code='KG'),
     unit_l AS (SELECT id FROM unit WHERE code='L')
INSERT INTO product (org_id, code, name, description, unit_id, min_stock, procurement_type, item_type, status)
SELECT demo_org.id, 'DEMO-001', 'Producto Demo 1', 'Materia prima demo', unit_kg.id, 50.00, 'BUY', 'RM', TRUE
FROM demo_org, unit_kg
UNION ALL
SELECT demo_org.id, 'DEMO-002', 'Producto Demo 2', 'Producto terminado demo', unit_ea.id, 10.00, 'MAKE', 'FG', TRUE
FROM demo_org, unit_ea
UNION ALL
SELECT demo_org.id, 'DEMO-003', 'Producto Demo 3', 'Consumible demo', unit_l.id, 20.00, 'BUY', 'CONSUMABLE', TRUE
FROM demo_org, unit_l
ON CONFLICT DO NOTHING;

-- =========================
-- STOCK INICIAL
-- =========================
INSERT INTO product_warehouse (product_id, warehouse_id, current_stock)
SELECT p.id, w.id, 100.00
FROM product p
JOIN warehouse w ON w.org_id = p.org_id
WHERE p.code IN ('DEMO-001', 'DEMO-002', 'DEMO-003')
  AND w.name = 'Principal'
ON CONFLICT DO NOTHING;

-- =========================
-- PROVEEDOR DEMO
-- =========================
INSERT INTO supplier (name, phone, email, org_id, status)
SELECT 'Proveedor Demo', '555-0000', 'ventas@demo.com', o.id, TRUE
FROM organization o
WHERE o.code = 'DEMO'
ON CONFLICT DO NOTHING;

-- ========================================
-- NOTA: Esta data es SOLO para desarrollo
-- Eliminar antes de producción con:
-- DELETE FROM user_organization WHERE org_id IN (SELECT id FROM organization WHERE code='DEMO');
-- DELETE FROM user_role WHERE user_id IN (SELECT id FROM "user" WHERE email='demo@demo.com');
-- DELETE FROM "user" WHERE email='demo@demo.com';
-- DELETE FROM organization WHERE code='DEMO';
-- ========================================
