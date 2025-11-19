-- Migration 017: Create mps_plan table for Sprint 4
-- Tabla de Plan Maestro de Producción (MPS)

CREATE TABLE IF NOT EXISTS mps_plan (
    id SERIAL PRIMARY KEY,
    org_id INTEGER NOT NULL REFERENCES organization(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES product(id) ON DELETE CASCADE,
    period DATE NOT NULL,
    planned_qty NUMERIC(15, 2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'cancelled')),
    demand_id INTEGER REFERENCES demand(id) ON DELETE SET NULL,
    notes TEXT,
    created_by INTEGER REFERENCES "user"(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    published_at TIMESTAMP
);

-- Índices para optimizar consultas
CREATE INDEX IF NOT EXISTS idx_mps_plan_org_id ON mps_plan(org_id);
CREATE INDEX IF NOT EXISTS idx_mps_plan_product_id ON mps_plan(product_id);
CREATE INDEX IF NOT EXISTS idx_mps_plan_period ON mps_plan(period);
CREATE INDEX IF NOT EXISTS idx_mps_plan_status ON mps_plan(status);
CREATE INDEX IF NOT EXISTS idx_mps_plan_org_product_period ON mps_plan(org_id, product_id, period);

-- Comentarios
COMMENT ON TABLE mps_plan IS 'Plan Maestro de Producción (MPS) - Sprint 4';
COMMENT ON COLUMN mps_plan.status IS 'Estado del plan: draft (borrador), published (publicado), cancelled';
COMMENT ON COLUMN mps_plan.period IS 'Periodo del plan (fecha de inicio de semana/mes)';
COMMENT ON COLUMN mps_plan.planned_qty IS 'Cantidad planificada a producir en el periodo';
COMMENT ON COLUMN mps_plan.published_at IS 'Fecha en que se publicó el plan';
