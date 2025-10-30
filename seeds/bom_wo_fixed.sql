-- ============================================================================
-- 17) BOMs (Listas de Materiales) - DATOS DE PRODUCCIÓN
-- ============================================================================

-- BOM para FG-MESA (org_id=1, product FG-MESA id=7)
INSERT INTO bom (org_id, product_id, version, is_active, description)
VALUES (1, 7, '1.0', TRUE, 'BOM estándar para mesa de madera')
ON CONFLICT DO NOTHING;

-- Componentes BOM FG-MESA (bom_id se obtiene de la BOM recién creada)
-- 4 unidades de RM-MAD (id=6), unit EA (id=1)
INSERT INTO bom_component (bom_id, component_id, quantity, scrap_percentage, unit_id, sequence, notes)
SELECT b.id, 6, 4.0, 5.0, 1, 1, 'Tableros de madera principal'
FROM bom b
WHERE b.org_id = 1 AND b.product_id = 7 AND b.version = '1.0';

-- 16 tornillos RM-TORN (id=5), unit EA (id=1)
INSERT INTO bom_component (bom_id, component_id, quantity, scrap_percentage, unit_id, sequence, notes)
SELECT b.id, 5, 16.0, 3.0, 1, 2, 'Tornillos de ensamblaje'
FROM bom b
WHERE b.org_id = 1 AND b.product_id = 7 AND b.version = '1.0';

-- 0.5 L de RM-PINT (id=4), unit L (id=3)
INSERT INTO bom_component (bom_id, component_id, quantity, scrap_percentage, unit_id, sequence, notes)
SELECT b.id, 4, 0.5, 8.0, 3, 3, 'Pintura de acabado'
FROM bom b
WHERE b.org_id = 1 AND b.product_id = 7 AND b.version = '1.0';

-- BOM para FG-SILLA (org_id=1, product FG-SILLA id=8)
INSERT INTO bom (org_id, product_id, version, is_active, description)
VALUES (1, 8, '1.0', TRUE, 'BOM estándar para silla')
ON CONFLICT DO NOTHING;

-- Componentes BOM FG-SILLA
-- 2 unidades de RM-MAD (id=6), unit EA (id=1)
INSERT INTO bom_component (bom_id, component_id, quantity, scrap_percentage, unit_id, sequence, notes)
SELECT b.id, 6, 2.0, 4.0, 1, 1, 'Tableros para asiento y respaldo'
FROM bom b
WHERE b.org_id = 1 AND b.product_id = 8 AND b.version = '1.0';

-- 1.5 kg de RM-ALU (id=2), unit KG (id=2)
INSERT INTO bom_component (bom_id, component_id, quantity, scrap_percentage, unit_id, sequence, notes)
SELECT b.id, 2, 1.5, 6.0, 2, 2, 'Estructura de aluminio'
FROM bom b
WHERE b.org_id = 1 AND b.product_id = 8 AND b.version = '1.0';

-- 12 tornillos RM-TORN (id=5), unit EA (id=1)
INSERT INTO bom_component (bom_id, component_id, quantity, scrap_percentage, unit_id, sequence, notes)
SELECT b.id, 5, 12.0, 3.0, 1, 3, 'Tornillos de ensamblaje'
FROM bom b
WHERE b.org_id = 1 AND b.product_id = 8 AND b.version = '1.0';

-- ============================================================================
-- 18) WORK ORDERS (Órdenes de Producción)
-- ============================================================================

-- WO 1: 5 MESAS (user planner id=2, warehouse Principal id=1)
INSERT INTO work_order (org_id, product_id, bom_id, quantity, status, warehouse_id, reference, notes, planned_start, planned_end, created_by)
SELECT 1, 7, b.id, 5.00, 'Planificada', 1, 'OP-2025-001', 'Orden inicial de mesas',
       CURRENT_DATE + INTERVAL '1 day', CURRENT_DATE + INTERVAL '3 days', 2
FROM bom b
WHERE b.org_id = 1 AND b.product_id = 7 AND b.version = '1.0';

-- WO 2: 10 SILLAS (assigned to operator id=4)
INSERT INTO work_order (org_id, product_id, bom_id, quantity, status, warehouse_id, reference, notes, planned_start, planned_end, created_by, assigned_to)
SELECT 1, 8, b.id, 10.00, 'Planificada', 1, 'OP-2025-002', 'Orden de sillas para stock',
       CURRENT_DATE + INTERVAL '2 days', CURRENT_DATE + INTERVAL '5 days', 2, 4
FROM bom b
WHERE b.org_id = 1 AND b.product_id = 8 AND b.version = '1.0';
