-- Migration 018: Create mrp_proposal table for Sprint 4
-- Tabla de Propuestas MRP (compras o producción)

CREATE TABLE IF NOT EXISTS mrp_proposal (
    id SERIAL PRIMARY KEY,
    org_id INTEGER NOT NULL REFERENCES organization(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES product(id) ON DELETE CASCADE,
    type VARCHAR(10) NOT NULL CHECK (type IN ('BUY', 'MAKE')),
    quantity NUMERIC(15, 2) NOT NULL,
    due_date DATE NOT NULL,
    source_period DATE,
    mps_plan_id INTEGER REFERENCES mps_plan(id) ON DELETE SET NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'proposed' CHECK (status IN ('proposed', 'approved', 'rejected', 'executed')),
    reason TEXT,
    supplier_id INTEGER REFERENCES supplier(id) ON DELETE SET NULL,
    estimated_cost NUMERIC(15, 2),
    warehouse_id INTEGER REFERENCES warehouse(id) ON DELETE SET NULL,
    executed_reference_type VARCHAR(20),
    executed_reference_id INTEGER,
    created_by INTEGER REFERENCES "user"(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved_at TIMESTAMP,
    approved_by INTEGER REFERENCES "user"(id) ON DELETE SET NULL
);

-- Índices para optimizar consultas
CREATE INDEX IF NOT EXISTS idx_mrp_proposal_org_id ON mrp_proposal(org_id);
CREATE INDEX IF NOT EXISTS idx_mrp_proposal_product_id ON mrp_proposal(product_id);
CREATE INDEX IF NOT EXISTS idx_mrp_proposal_type ON mrp_proposal(type);
CREATE INDEX IF NOT EXISTS idx_mrp_proposal_status ON mrp_proposal(status);
CREATE INDEX IF NOT EXISTS idx_mrp_proposal_due_date ON mrp_proposal(due_date);
CREATE INDEX IF NOT EXISTS idx_mrp_proposal_org_status ON mrp_proposal(org_id, status);

-- Comentarios
COMMENT ON TABLE mrp_proposal IS 'Propuestas MRP para compras (BUY) o producción (MAKE) - Sprint 4';
COMMENT ON COLUMN mrp_proposal.type IS 'Tipo de propuesta: BUY (comprar) o MAKE (producir)';
COMMENT ON COLUMN mrp_proposal.status IS 'Estado: proposed, approved, rejected, executed';
COMMENT ON COLUMN mrp_proposal.due_date IS 'Fecha en que se necesita el material/producto';
COMMENT ON COLUMN mrp_proposal.source_period IS 'Periodo del MPS que originó esta propuesta';
COMMENT ON COLUMN mrp_proposal.executed_reference_type IS 'Tipo de referencia ejecutada: WO (Work Order) o PO (Purchase Order)';
COMMENT ON COLUMN mrp_proposal.executed_reference_id IS 'ID de la WO o PO ejecutada';
