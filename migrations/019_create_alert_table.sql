-- Migration 019: Create alert table
-- Sprint 5 - Sistema de Alertas

SET search_path TO mrp, public;

CREATE TABLE IF NOT EXISTS alert (
    id SERIAL PRIMARY KEY,
    org_id INTEGER NOT NULL REFERENCES organization(id) ON DELETE CASCADE,
    
    -- Tipo y severidad
    type VARCHAR(50) NOT NULL,
    severity VARCHAR(20) NOT NULL DEFAULT 'info' CHECK (severity IN ('info', 'warning', 'critical')),
    
    -- Contenido
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    
    -- Referencias opcionales
    reference_type VARCHAR(50),
    reference_id INTEGER,
    
    -- Metadata JSON
    metadata JSONB,
    
    -- Estado de lectura
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    read_at TIMESTAMP,
    read_by INTEGER REFERENCES "user"(id),
    
    -- Timestamps
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP,
    
    CONSTRAINT chk_alert_read CHECK (
        (is_read = FALSE AND read_at IS NULL AND read_by IS NULL) OR
        (is_read = TRUE AND read_at IS NOT NULL AND read_by IS NOT NULL)
    )
);

-- Índices para performance
CREATE INDEX idx_alert_org_unread ON alert(org_id, is_read);
CREATE INDEX idx_alert_type ON alert(type);
CREATE INDEX idx_alert_severity ON alert(severity);
CREATE INDEX idx_alert_created ON alert(created_at DESC);
CREATE INDEX idx_alert_reference ON alert(reference_type, reference_id);

-- Comentarios
COMMENT ON TABLE alert IS 'Sprint 5 - Sistema de alertas del MRP';
COMMENT ON COLUMN alert.type IS 'Tipo: low_stock, wo_delay, mrp_pending, supplier_expiry';
COMMENT ON COLUMN alert.severity IS 'Severidad: info, warning, critical';
COMMENT ON COLUMN alert.metadata IS 'Datos adicionales en JSON para contexto';
COMMENT ON COLUMN alert.expires_at IS 'Fecha de expiración opcional para alertas temporales';
