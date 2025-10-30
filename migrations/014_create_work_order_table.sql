-- Migration: Create Work Order table
-- Sprint 3 - Production Execution

CREATE TABLE IF NOT EXISTS work_order (
    id SERIAL PRIMARY KEY,
    org_id INTEGER NOT NULL REFERENCES organization(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES product(id) ON DELETE CASCADE,
    bom_id INTEGER NOT NULL REFERENCES bom(id) ON DELETE RESTRICT,
    quantity NUMERIC(10, 2) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'Planificada',
    warehouse_id INTEGER REFERENCES warehouse(id),
    assigned_to INTEGER REFERENCES "user"(id),
    reference VARCHAR(100),
    notes TEXT,
    
    -- Fechas
    planned_start TIMESTAMP,
    planned_end TIMESTAMP,
    actual_start TIMESTAMP,
    actual_end TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by INTEGER REFERENCES "user"(id),
    
    CONSTRAINT ck_work_order_quantity_positive CHECK (quantity > 0),
    CONSTRAINT ck_work_order_status_valid CHECK (status IN ('Planificada', 'En Progreso', 'Finalizada', 'Cancelada'))
);

CREATE INDEX idx_work_order_org_id ON work_order(org_id);
CREATE INDEX idx_work_order_product_id ON work_order(product_id);
CREATE INDEX idx_work_order_bom_id ON work_order(bom_id);
CREATE INDEX idx_work_order_status ON work_order(status);
CREATE INDEX idx_work_order_warehouse_id ON work_order(warehouse_id);
CREATE INDEX idx_work_order_assigned_to ON work_order(assigned_to);
CREATE INDEX idx_work_order_created_at ON work_order(created_at);

-- Comentarios
COMMENT ON TABLE work_order IS 'Órdenes de Producción - Gestiona la fabricación de productos';
COMMENT ON COLUMN work_order.status IS 'Estados: Planificada, En Progreso, Finalizada, Cancelada';
COMMENT ON COLUMN work_order.bom_id IS 'BOM utilizada para esta orden (snapshot al momento de creación)';
COMMENT ON COLUMN work_order.quantity IS 'Cantidad a producir';
COMMENT ON COLUMN work_order.reference IS 'Referencia externa (orden de venta, cliente, etc)';
COMMENT ON COLUMN work_order.actual_start IS 'Fecha real de inicio (cuando pasa a En Progreso)';
COMMENT ON COLUMN work_order.actual_end IS 'Fecha real de finalización';
