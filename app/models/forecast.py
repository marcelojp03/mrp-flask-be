# models/forecast.py
from app.db import db
from datetime import datetime

class Forecast(db.Model):
    __tablename__ = 'forecast'
    
    id = db.Column(db.Integer, primary_key=True)
    org_id = db.Column(db.Integer, db.ForeignKey('organization.id'), nullable=False)
    product_id = db.Column(db.Integer, db.ForeignKey('product.id'), nullable=False)
    
    # Periodo y cantidad pronosticada
    period = db.Column(db.Date, nullable=False)
    forecasted_quantity = db.Column(db.Numeric(10, 2), nullable=False)
    
    # Metadata del pronóstico
    confidence_score = db.Column(db.Numeric(5, 2))  # 0-100 score de confianza
    method = db.Column(db.String(50), nullable=False, default='ai')  # ai, manual, statistical
    model_used = db.Column(db.String(100))  # gpt-4, linear_regression, etc.
    
    # Datos históricos usados
    historical_periods = db.Column(db.Integer)  # Cantidad de periodos históricos usados
    historical_data = db.Column(db.JSON)  # Snapshot de datos históricos usados
    
    # Análisis AI
    ai_insights = db.Column(db.Text)  # Insights generados por AI
    ai_prompt_used = db.Column(db.Text)  # Prompt usado para generar el pronóstico
    
    # Estado
    status = db.Column(db.String(20), nullable=False, default='draft')  # draft, published, cancelled
    
    # Auditoría
    created_by = db.Column(db.Integer, db.ForeignKey('user.id'))
    created_at = db.Column(db.DateTime, default=datetime.utcnow, nullable=False)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow, nullable=False)
    
    # Relationships
    organization = db.relationship('Organization', backref='forecasts')
    product = db.relationship('Product', backref='forecasts')
    creator = db.relationship('User', foreign_keys=[created_by], backref='created_forecasts')
    
    __table_args__ = (
        db.UniqueConstraint('org_id', 'product_id', 'period', 'method', name='uq_forecast_product_period_method'),
        db.Index('idx_forecast_org_product', 'org_id', 'product_id'),
        db.Index('idx_forecast_period', 'period'),
        db.Index('idx_forecast_status', 'status'),
    )
    
    def serialize(self):
        return {
            'id': self.id,
            'org_id': self.org_id,
            'product_id': self.product_id,
            'product_code': self.product.code if self.product else None,
            'product_name': self.product.name if self.product else None,
            'period': self.period.isoformat() if self.period else None,
            'forecasted_quantity': float(self.forecasted_quantity) if self.forecasted_quantity else None,
            'confidence_score': float(self.confidence_score) if self.confidence_score else None,
            'method': self.method,
            'model_used': self.model_used,
            'historical_periods': self.historical_periods,
            'historical_data': self.historical_data,
            'ai_insights': self.ai_insights,
            'status': self.status,
            'created_by': self.created_by,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None
        }
