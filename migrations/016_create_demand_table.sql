-- Migration 016: Create demand table for Sprint 4
-- Tabla de demanda proyectada/histórica de productos

CREATE TABLE IF NOT EXISTS demand (
    id SERIAL PRIMARY KEY,
    org_id INTEGER NOT NULL REFERENCES organization(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES product(id) ON DELETE CASCADE,
    period DATE NOT NULL,
    quantity NUMERIC(15, 2) NOT NULL,
    source VARCHAR(20) NOT NULL DEFAULT 'manual' CHECK (source IN ('manual', 'import', 'forecast')),
    status VARCHAR(20) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'confirmed', 'cancelled')),
    notes TEXT,
    created_by INTEGER REFERENCES "user"(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices para optimizar consultas
CREATE INDEX IF NOT EXISTS idx_demand_org_id ON demand(org_id);
CREATE INDEX IF NOT EXISTS idx_demand_product_id ON demand(product_id);
CREATE INDEX IF NOT EXISTS idx_demand_period ON demand(period);
CREATE INDEX IF NOT EXISTS idx_demand_status ON demand(status);
CREATE INDEX IF NOT EXISTS idx_demand_org_product_period ON demand(org_id, product_id, period);

-- Comentarios
COMMENT ON TABLE demand IS 'Demanda proyectada o histórica de productos por periodo - Sprint 4';
COMMENT ON COLUMN demand.source IS 'Fuente de la demanda: manual, import (CSV), forecast (IA)';
COMMENT ON COLUMN demand.status IS 'Estado de la demanda: draft, confirmed, cancelled';
COMMENT ON COLUMN demand.period IS 'Fecha de inicio del periodo (puede ser inicio de semana o mes)';
