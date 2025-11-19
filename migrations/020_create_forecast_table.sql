-- Migration 020: Create forecast table
-- Sprint 5 - Sistema de Pronósticos con AI

SET search_path TO mrp, public;

CREATE TABLE IF NOT EXISTS forecast (
    id SERIAL PRIMARY KEY,
    org_id INTEGER NOT NULL REFERENCES organization(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES product(id) ON DELETE CASCADE,
    
    -- Periodo y cantidad
    period DATE NOT NULL,
    forecasted_quantity NUMERIC(10, 2) NOT NULL CHECK (forecasted_quantity >= 0),
    
    -- Metadata del pronóstico
    confidence_score NUMERIC(5, 2) CHECK (confidence_score >= 0 AND confidence_score <= 100),
    method VARCHAR(50) NOT NULL DEFAULT 'ai' CHECK (method IN ('ai', 'manual', 'statistical')),
    model_used VARCHAR(100),
    
    -- Datos históricos
    historical_periods INTEGER,
    historical_data JSONB,
    
    -- Análisis AI
    ai_insights TEXT,
    ai_prompt_used TEXT,
    
    -- Estado
    status VARCHAR(20) NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'cancelled')),
    
    -- Auditoría
    created_by INTEGER REFERENCES "user"(id),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT uq_forecast_product_period_method UNIQUE (org_id, product_id, period, method)
);

-- Índices para performance
CREATE INDEX idx_forecast_org_product ON forecast(org_id, product_id);
CREATE INDEX idx_forecast_period ON forecast(period);
CREATE INDEX idx_forecast_status ON forecast(status);
CREATE INDEX idx_forecast_method ON forecast(method);

-- Comentarios
COMMENT ON TABLE forecast IS 'Sprint 5 - Pronósticos de demanda generados por AI';
COMMENT ON COLUMN forecast.method IS 'Método: ai (OpenAI), manual, statistical';
COMMENT ON COLUMN forecast.confidence_score IS 'Score 0-100 de confianza del pronóstico';
COMMENT ON COLUMN forecast.historical_data IS 'Snapshot de datos históricos usados en formato JSON';
COMMENT ON COLUMN forecast.ai_insights IS 'Insights y análisis generados por el modelo AI';
