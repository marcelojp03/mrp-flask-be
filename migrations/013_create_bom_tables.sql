-- Migration: Create BOM (Bill of Materials) tables
-- Sprint 3 - Production Planning

-- Tabla BOM (Lista de Materiales)
CREATE TABLE IF NOT EXISTS bom (
    id SERIAL PRIMARY KEY,
    org_id INTEGER NOT NULL REFERENCES organization(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES product(id) ON DELETE CASCADE,
    version VARCHAR(50) NOT NULL DEFAULT '1.0',
    is_active BOOLEAN NOT NULL DEFAULT FALSE,
    description VARCHAR(500),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uq_bom_product_version UNIQUE (org_id, product_id, version)
);

CREATE INDEX idx_bom_org_id ON bom(org_id);
CREATE INDEX idx_bom_product_id ON bom(product_id);
CREATE INDEX idx_bom_is_active ON bom(is_active);

-- Tabla BOM Component (Componentes de la BOM)
CREATE TABLE IF NOT EXISTS bom_component (
    id SERIAL PRIMARY KEY,
    bom_id INTEGER NOT NULL REFERENCES bom(id) ON DELETE CASCADE,
    component_id INTEGER NOT NULL REFERENCES product(id) ON DELETE CASCADE,
    quantity NUMERIC(10, 4) NOT NULL,
    scrap_percentage NUMERIC(5, 2) NOT NULL DEFAULT 0.0,
    unit_id INTEGER REFERENCES unit(id),
    sequence INTEGER DEFAULT 0,
    notes VARCHAR(500),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uq_bom_component UNIQUE (bom_id, component_id),
    CONSTRAINT ck_bom_component_quantity_positive CHECK (quantity > 0),
    CONSTRAINT ck_bom_component_scrap_range CHECK (scrap_percentage >= 0 AND scrap_percentage <= 100)
);

CREATE INDEX idx_bom_component_bom_id ON bom_component(bom_id);
CREATE INDEX idx_bom_component_component_id ON bom_component(component_id);

-- Comentarios
COMMENT ON TABLE bom IS 'Bill of Materials (Lista de Materiales) - Define qué componentes se necesitan para fabricar un producto';
COMMENT ON TABLE bom_component IS 'Componentes de la BOM - Materiales y cantidades necesarias';

COMMENT ON COLUMN bom.version IS 'Versión de la BOM (ej: 1.0, 1.1, 2.0)';
COMMENT ON COLUMN bom.is_active IS 'Solo una versión de BOM puede estar activa por producto';
COMMENT ON COLUMN bom_component.quantity IS 'Cantidad necesaria del componente';
COMMENT ON COLUMN bom_component.scrap_percentage IS 'Porcentaje de desperdicio esperado (0-100)';
COMMENT ON COLUMN bom_component.sequence IS 'Orden de los componentes en la lista';
