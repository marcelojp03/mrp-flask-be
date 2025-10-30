-- Seeds para Sprint 3: BOMs y Work Orders de ejemplo
-- Requisito: Ejecutar después de full_database_seeds.sql

-- =============================================================================
-- BOMs (Bill of Materials) para productos de ejemplo
-- =============================================================================

-- BOM para FG-MESA (Mesa de madera)
-- Componentes: Madera (RM-MAD), Tornillos (RM-TORN), Pintura (RM-PINT)
INSERT INTO bom (org_id, product_id, version, is_active, description, created_at, updated_at)
SELECT 
    1 AS org_id,
    p.id AS product_id,
    '1.0' AS version,
    TRUE AS is_active,
    'BOM para fabricación de mesa estándar' AS description,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
FROM product p
WHERE p.code = 'FG-MESA' AND p.org_id = 1
ON CONFLICT DO NOTHING;

-- Componentes de la BOM para Mesa
INSERT INTO bom_component (bom_id, component_id, quantity, scrap_percentage, sequence, notes, created_at)
SELECT 
    b.id AS bom_id,
    p_comp.id AS component_id,
    CASE 
        WHEN p_comp.code = 'RM-MAD' THEN 2.5    -- 2.5 unidades de madera
        WHEN p_comp.code = 'RM-TORN' THEN 20.0  -- 20 tornillos
        WHEN p_comp.code = 'RM-PINT' THEN 0.5   -- 0.5 litros de pintura
    END AS quantity,
    CASE 
        WHEN p_comp.code = 'RM-MAD' THEN 5.0    -- 5% desperdicio en madera
        WHEN p_comp.code = 'RM-PINT' THEN 10.0  -- 10% desperdicio en pintura
        ELSE 0.0
    END AS scrap_percentage,
    CASE 
        WHEN p_comp.code = 'RM-MAD' THEN 1
        WHEN p_comp.code = 'RM-TORN' THEN 2
        WHEN p_comp.code = 'RM-PINT' THEN 3
    END AS sequence,
    CASE 
        WHEN p_comp.code = 'RM-MAD' THEN 'Madera para tablero y patas'
        WHEN p_comp.code = 'RM-TORN' THEN 'Tornillos de ensamble'
        WHEN p_comp.code = 'RM-PINT' THEN 'Pintura de acabado'
    END AS notes,
    CURRENT_TIMESTAMP
FROM bom b
INNER JOIN product p ON b.product_id = p.id
CROSS JOIN product p_comp
WHERE p.code = 'FG-MESA' 
  AND p.org_id = 1
  AND b.org_id = 1
  AND b.version = '1.0'
  AND p_comp.code IN ('RM-MAD', 'RM-TORN', 'RM-PINT')
  AND p_comp.org_id = 1
ON CONFLICT (bom_id, component_id) DO NOTHING;


-- BOM para FG-SILLA (Silla de oficina)
-- Componentes: Madera (RM-MAD), Tornillos (RM-TORN), Pintura (RM-PINT)
INSERT INTO bom (org_id, product_id, version, is_active, description, created_at, updated_at)
SELECT 
    1 AS org_id,
    p.id AS product_id,
    '1.0' AS version,
    TRUE AS is_active,
    'BOM para fabricación de silla de oficina' AS description,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
FROM product p
WHERE p.code = 'FG-SILLA' AND p.org_id = 1
ON CONFLICT DO NOTHING;

-- Componentes de la BOM para Silla
INSERT INTO bom_component (bom_id, component_id, quantity, scrap_percentage, sequence, notes, created_at)
SELECT 
    b.id AS bom_id,
    p_comp.id AS component_id,
    CASE 
        WHEN p_comp.code = 'RM-MAD' THEN 1.2    -- 1.2 unidades de madera
        WHEN p_comp.code = 'RM-TORN' THEN 15.0  -- 15 tornillos
        WHEN p_comp.code = 'RM-PINT' THEN 0.3   -- 0.3 litros de pintura
    END AS quantity,
    CASE 
        WHEN p_comp.code = 'RM-MAD' THEN 5.0
        WHEN p_comp.code = 'RM-PINT' THEN 10.0
        ELSE 0.0
    END AS scrap_percentage,
    CASE 
        WHEN p_comp.code = 'RM-MAD' THEN 1
        WHEN p_comp.code = 'RM-TORN' THEN 2
        WHEN p_comp.code = 'RM-PINT' THEN 3
    END AS sequence,
    CASE 
        WHEN p_comp.code = 'RM-MAD' THEN 'Madera para asiento y respaldo'
        WHEN p_comp.code = 'RM-TORN' THEN 'Tornillos de ensamble'
        WHEN p_comp.code = 'RM-PINT' THEN 'Pintura de acabado'
    END AS notes,
    CURRENT_TIMESTAMP
FROM bom b
INNER JOIN product p ON b.product_id = p.id
CROSS JOIN product p_comp
WHERE p.code = 'FG-SILLA' 
  AND p.org_id = 1
  AND b.org_id = 1
  AND b.version = '1.0'
  AND p_comp.code IN ('RM-MAD', 'RM-TORN', 'RM-PINT')
  AND p_comp.org_id = 1
ON CONFLICT (bom_id, component_id) DO NOTHING;


-- =============================================================================
-- Work Orders de ejemplo (Órdenes de Producción)
-- =============================================================================

-- Work Order #1: Producir 5 mesas (Planificada)
INSERT INTO work_order (
    org_id, product_id, bom_id, quantity, status, warehouse_id, 
    reference, notes, planned_start, planned_end, 
    created_by, created_at, updated_at
)
SELECT 
    1 AS org_id,
    p.id AS product_id,
    b.id AS bom_id,
    5.00 AS quantity,
    'Planificada' AS status,
    w.id AS warehouse_id,
    'ORD-001' AS reference,
    'Orden de producción para cliente A - Lote inicial de mesas' AS notes,
    CURRENT_TIMESTAMP + INTERVAL '1 day' AS planned_start,
    CURRENT_TIMESTAMP + INTERVAL '3 days' AS planned_end,
    (SELECT id FROM "user" WHERE email = 'planner@acme.com' LIMIT 1) AS created_by,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
FROM product p
INNER JOIN bom b ON b.product_id = p.id AND b.is_active = TRUE
INNER JOIN warehouse w ON w.name = 'Almacén Principal' AND w.org_id = 1
WHERE p.code = 'FG-MESA' AND p.org_id = 1
LIMIT 1;


-- Work Order #2: Producir 10 sillas (Planificada)
INSERT INTO work_order (
    org_id, product_id, bom_id, quantity, status, warehouse_id,
    assigned_to, reference, notes, planned_start, planned_end,
    created_by, created_at, updated_at
)
SELECT 
    1 AS org_id,
    p.id AS product_id,
    b.id AS bom_id,
    10.00 AS quantity,
    'Planificada' AS status,
    w.id AS warehouse_id,
    (SELECT id FROM "user" WHERE email = 'op@acme.com' LIMIT 1) AS assigned_to,
    'ORD-002' AS reference,
    'Producción de sillas para stock' AS notes,
    CURRENT_TIMESTAMP + INTERVAL '2 days' AS planned_start,
    CURRENT_TIMESTAMP + INTERVAL '5 days' AS planned_end,
    (SELECT id FROM "user" WHERE email = 'planner@acme.com' LIMIT 1) AS created_by,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
FROM product p
INNER JOIN bom b ON b.product_id = p.id AND b.is_active = TRUE
INNER JOIN warehouse w ON w.name = 'Almacén Principal' AND w.org_id = 1
WHERE p.code = 'FG-SILLA' AND p.org_id = 1
LIMIT 1;


-- Work Order #3: Producir 3 mesas (En Progreso - para testing)
-- Esta OP está en progreso, útil para ver el dashboard con OPs activas
INSERT INTO work_order (
    org_id, product_id, bom_id, quantity, status, warehouse_id,
    assigned_to, reference, notes, planned_start, actual_start,
    created_by, created_at, updated_at
)
SELECT 
    1 AS org_id,
    p.id AS product_id,
    b.id AS bom_id,
    3.00 AS quantity,
    'En Progreso' AS status,
    w.id AS warehouse_id,
    (SELECT id FROM "user" WHERE email = 'op@acme.com' LIMIT 1) AS assigned_to,
    'ORD-003' AS reference,
    'Producción urgente para cliente B' AS notes,
    CURRENT_TIMESTAMP - INTERVAL '1 hour' AS planned_start,
    CURRENT_TIMESTAMP - INTERVAL '30 minutes' AS actual_start,
    (SELECT id FROM "user" WHERE email = 'super@acme.com' LIMIT 1) AS created_by,
    CURRENT_TIMESTAMP - INTERVAL '2 hours',
    CURRENT_TIMESTAMP
FROM product p
INNER JOIN bom b ON b.product_id = p.id AND b.is_active = TRUE
INNER JOIN warehouse w ON w.name = 'Almacén Principal' AND w.org_id = 1
WHERE p.code = 'FG-MESA' AND p.org_id = 1
LIMIT 1;


-- =============================================================================
-- RESUMEN DE SEEDS S3
-- =============================================================================
-- BOMs creadas: 2 (Mesa v1.0, Silla v1.0)
-- Componentes por BOM: 3 (Madera, Tornillos, Pintura con cantidades y scrap%)
-- Work Orders: 3 (2 Planificadas, 1 En Progreso)
-- 
-- Para probar el flujo completo:
-- 1. Iniciar OP #1 o #2 via API: PUT /api/work-orders/:id/start
--    - Generará movimientos OUT de componentes
--    - Decrementará stock de materias primas
-- 2. Finalizar OP via API: PUT /api/work-orders/:id/finish  
--    - Generará movimiento IN del producto terminado
--    - Incrementará stock de productos terminados
-- 3. Ver dashboard con: GET /api/dashboard/kpis
--    - work_orders_active
--    - work_orders_finished_today
--    - materials_consumed_today
-- =============================================================================

SELECT 'Seeds de Sprint 3 (BOMs y Work Orders) cargados exitosamente' AS status;
