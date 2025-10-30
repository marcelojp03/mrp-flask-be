-- Migration: Extend Movement table for Work Order references
-- Sprint 3 - Production Traceability

-- Agregar columnas para referencia a Work Orders
ALTER TABLE movement 
ADD COLUMN IF NOT EXISTS reference_type VARCHAR(20),
ADD COLUMN IF NOT EXISTS reference_id INTEGER;

-- Índices para mejorar búsquedas por referencia
CREATE INDEX IF NOT EXISTS idx_movement_reference_type ON movement(reference_type);
CREATE INDEX IF NOT EXISTS idx_movement_reference_id ON movement(reference_id);
CREATE INDEX IF NOT EXISTS idx_movement_reference_composite ON movement(reference_type, reference_id);

-- Comentarios
COMMENT ON COLUMN movement.reference_type IS 'Tipo de referencia: WO (Work Order), PO (Purchase Order), SO (Sales Order), ADJ (Adjustment), etc';
COMMENT ON COLUMN movement.reference_id IS 'ID de la referencia (work_order.id, compra.id, etc)';

-- Constraint para tipos válidos (opcional, puedes agregar más tipos según necesites)
ALTER TABLE movement 
ADD CONSTRAINT ck_movement_reference_type 
CHECK (reference_type IS NULL OR reference_type IN ('WO', 'PO', 'SO', 'ADJ', 'TRANSFER', 'RETURN'));
