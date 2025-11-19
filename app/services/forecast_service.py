# services/forecast_service.py
from typing import List, Optional, Dict
from datetime import date, datetime, timedelta
from decimal import Decimal
import json
import numpy as np
import pandas as pd

from app.db import db
from app.models.forecast import Forecast
from app.models.demand import Demand
from app.models.product import Product
from app.models.movement import Movement
from app.models.organization import Organization

class ForecastService:
    """Servicio para generación de pronósticos estadísticos - Sprint 5"""
    
    def __init__(self):
        pass
    
    def list(self, org_id: int, product_id: Optional[int] = None,
             period_start: Optional[date] = None, period_end: Optional[date] = None,
             method: Optional[str] = None, status: Optional[str] = None) -> List[dict]:
        """Listar pronósticos con filtros"""
        query = Forecast.query.filter_by(org_id=org_id)
        
        if product_id:
            query = query.filter_by(product_id=product_id)
        
        if period_start:
            query = query.filter(Forecast.period >= period_start)
        
        if period_end:
            query = query.filter(Forecast.period <= period_end)
        
        if method:
            query = query.filter_by(method=method)
        
        if status:
            query = query.filter_by(status=status)
        
        forecasts = query.order_by(Forecast.period.asc(), Forecast.product_id.asc()).all()
        return [f.serialize() for f in forecasts]
    
    def get(self, forecast_id: int, org_id: int) -> Optional[dict]:
        """Obtener pronóstico por ID"""
        forecast = Forecast.query.filter_by(id=forecast_id, org_id=org_id).first()
        return forecast.serialize() if forecast else None
    
    def get_historical_data(self, org_id: int, product_id: int, months_back: int = 6) -> Dict:
        """
        Obtener datos históricos de demanda y movimientos
        Retorna dict con datos formateados para AI
        """
        end_date = date.today()
        start_date = end_date - timedelta(days=months_back * 30)
        
        # Obtener demanda histórica
        demands = Demand.query.filter(
            Demand.org_id == org_id,
            Demand.product_id == product_id,
            Demand.period >= start_date,
            Demand.period <= end_date,
            Demand.status == 'confirmed'
        ).order_by(Demand.period.asc()).all()
        
        # Obtener movimientos de salida (ventas)
        movements = Movement.query.filter(
            Movement.org_id == org_id,
            Movement.product_id == product_id,
            Movement.movement_type == 'OUT',
            Movement.created_at >= start_date,
            Movement.created_at <= end_date
        ).order_by(Movement.created_at.asc()).all()
        
        # Formatear datos
        demand_data = [
            {
                'period': d.period.isoformat(),
                'quantity': float(d.quantity),
                'source': d.source
            }
            for d in demands
        ]
        
        movement_data = [
            {
                'date': m.created_at.isoformat(),
                'quantity': abs(float(m.quantity)),
                'reason': m.reason
            }
            for m in movements
        ]
        
        # Calcular estadísticas
        demand_quantities = [float(d.quantity) for d in demands]
        movement_quantities = [abs(float(m.quantity)) for m in movements]
        
        stats = {
            'demand_count': len(demands),
            'demand_avg': sum(demand_quantities) / len(demand_quantities) if demand_quantities else 0,
            'demand_min': min(demand_quantities) if demand_quantities else 0,
            'demand_max': max(demand_quantities) if demand_quantities else 0,
            'movement_count': len(movements),
            'movement_avg': sum(movement_quantities) / len(movement_quantities) if movement_quantities else 0
        }
        
        return {
            'product_id': product_id,
            'period_start': start_date.isoformat(),
            'period_end': end_date.isoformat(),
            'months_analyzed': months_back,
            'demands': demand_data,
            'movements': movement_data,
            'statistics': stats
        }
    
    def generate_statistical(self, org_id: int, product_id: int, method: str,
                            periods_ahead: int = 3, historical_periods: int = 6,
                            created_by: Optional[int] = None) -> List[dict]:
        """
        Generar pronósticos usando métodos estadísticos
        
        Args:
            org_id: ID de la organización
            product_id: ID del producto
            method: Método a usar ('MOVING_AVG', 'WEIGHTED_AVG', 'EXP_SMOOTHING', 'LINEAR_REGRESSION')
            periods_ahead: Número de períodos a pronosticar
            historical_periods: Períodos históricos a considerar
            created_by: ID del usuario
        
        Returns:
            Lista de pronósticos generados
        """
        # Obtener producto
        product = Product.query.filter_by(id=product_id, org_id=org_id).first()
        if not product:
            raise ValueError('Producto no encontrado')
        
        # Obtener datos históricos
        historical = self.get_historical_data(org_id, product_id, months_back=historical_periods)
        
        # Extraer cantidades históricas (demandas + movimientos OUT)
        demand_quantities = [float(d['quantity']) for d in historical['demands']]
        movement_quantities = [float(m['quantity']) for m in historical['movements']]
        
        # Combinar en serie temporal
        time_series = demand_quantities + movement_quantities
        
        if len(time_series) == 0:
            # Sin datos históricos, usar promedio conservador
            time_series = [0]
        
        # Generar pronósticos según el método
        if method == 'MOVING_AVG':
            forecasts = self._moving_average(time_series, periods_ahead, window=min(3, len(time_series)))
        elif method == 'WEIGHTED_AVG':
            forecasts = self._weighted_average(time_series, periods_ahead)
        elif method == 'EXP_SMOOTHING':
            forecasts = self._exponential_smoothing(time_series, periods_ahead, alpha=0.3)
        elif method == 'LINEAR_REGRESSION':
            forecasts = self._linear_regression(time_series, periods_ahead)
        else:
            raise ValueError(f'Método no soportado: {method}')
        
        # Crear pronósticos en BD
        forecasts_created = []
        start_period = date.today().replace(day=1)
        
        for i, (quantity, confidence) in enumerate(forecasts):
            period = start_period + timedelta(days=30 * (i + 1))
            
            forecast = Forecast(
                org_id=org_id,
                product_id=product_id,
                period=period,
                forecasted_quantity=Decimal(str(max(0, quantity))),  # No negativos
                confidence_score=Decimal(str(confidence)),
                method='statistical',  # DB constraint allows: 'ai', 'manual', 'statistical'
                model_used=f'{method} (n={len(time_series)})',
                historical_periods=len(time_series),
                historical_data=historical,
                status='draft',
                created_by=created_by
            )
            
            db.session.add(forecast)
            forecasts_created.append(forecast)
        
        db.session.commit()
        
        return [f.serialize() for f in forecasts_created]
    
    def _moving_average(self, data: List[float], periods: int, window: int = 3) -> List[tuple]:
        """Media móvil simple"""
        if len(data) == 0:
            return [(0, 50) for _ in range(periods)]
        
        # Calcular promedio de ventana
        window_size = min(window, len(data))
        recent_data = data[-window_size:]
        avg = np.mean(recent_data)
        
        # Calcular confianza basada en variabilidad
        std = np.std(recent_data) if len(recent_data) > 1 else avg * 0.3
        confidence = max(30, min(95, 100 - (std / (avg + 1)) * 50))
        
        # Pronóstico constante
        return [(avg, confidence) for _ in range(periods)]
    
    def _weighted_average(self, data: List[float], periods: int) -> List[tuple]:
        """Media móvil ponderada (más peso a datos recientes)"""
        if len(data) == 0:
            return [(0, 50) for _ in range(periods)]
        
        # Crear pesos exponenciales (más reciente = más peso)
        n = len(data)
        weights = np.exp(np.linspace(-2, 0, n))
        weights = weights / weights.sum()
        
        # Calcular promedio ponderado
        weighted_avg = np.average(data, weights=weights)
        
        # Confianza basada en consistencia
        std = np.std(data)
        confidence = max(40, min(90, 100 - (std / (weighted_avg + 1)) * 40))
        
        return [(weighted_avg, confidence) for _ in range(periods)]
    
    def _exponential_smoothing(self, data: List[float], periods: int, alpha: float = 0.3) -> List[tuple]:
        """Suavizamiento exponencial simple"""
        if len(data) == 0:
            return [(0, 50) for _ in range(periods)]
        
        # Inicializar con primer valor
        forecast = data[0]
        
        # Aplicar suavizamiento a datos históricos
        for value in data[1:]:
            forecast = alpha * value + (1 - alpha) * forecast
        
        # Confianza basada en tendencia
        if len(data) > 3:
            recent_trend = (data[-1] - data[-3]) / 3
            volatility = np.std(data[-6:]) if len(data) >= 6 else np.std(data)
            confidence = max(35, min(85, 100 - (volatility / (forecast + 1)) * 50))
        else:
            confidence = 60
        
        # Proyectar hacia adelante
        return [(forecast, confidence) for _ in range(periods)]
    
    def _linear_regression(self, data: List[float], periods: int) -> List[tuple]:
        """Regresión lineal para detectar tendencia"""
        if len(data) < 2:
            avg = data[0] if data else 0
            return [(avg, 50) for _ in range(periods)]
        
        # Crear serie temporal
        x = np.arange(len(data))
        y = np.array(data)
        
        # Calcular pendiente e intercepto
        coefficients = np.polyfit(x, y, 1)
        slope, intercept = coefficients
        
        # Proyectar hacia adelante
        forecasts = []
        for i in range(1, periods + 1):
            future_x = len(data) + i - 1
            forecast_value = slope * future_x + intercept
            
            # Calcular confianza basada en R²
            y_pred = slope * x + intercept
            ss_res = np.sum((y - y_pred) ** 2)
            ss_tot = np.sum((y - np.mean(y)) ** 2)
            r_squared = 1 - (ss_res / (ss_tot + 1e-10))
            confidence = max(30, min(90, r_squared * 100))
            
            forecasts.append((max(0, forecast_value), confidence))
        
        return forecasts

    
    def publish(self, forecast_id: int, org_id: int) -> Optional[dict]:
        """Publicar pronóstico (cambiar status a published)"""
        forecast = Forecast.query.filter_by(id=forecast_id, org_id=org_id).first()
        if not forecast:
            return None
        
        forecast.status = 'published'
        db.session.commit()
        return forecast.serialize()
    
    def bulk_publish(self, forecast_ids: List[int], org_id: int) -> List[dict]:
        """Publicar múltiples pronósticos"""
        forecasts = Forecast.query.filter(
            Forecast.id.in_(forecast_ids),
            Forecast.org_id == org_id
        ).all()
        
        for forecast in forecasts:
            forecast.status = 'published'
        
        db.session.commit()
        return [f.serialize() for f in forecasts]
    
    def convert_to_demand(self, forecast_id: int, org_id: int, created_by: Optional[int] = None) -> dict:
        """
        Convertir pronóstico publicado en demanda
        Útil para alimentar el flujo MPS → MRP
        """
        forecast = Forecast.query.filter_by(id=forecast_id, org_id=org_id, status='published').first()
        if not forecast:
            raise ValueError('Pronóstico no encontrado o no está publicado')
        
        # Crear demanda desde pronóstico
        demand = Demand(
            org_id=org_id,
            product_id=forecast.product_id,
            period=forecast.period,
            quantity=forecast.forecasted_quantity,
            source='forecast',
            status='draft',
            notes=f'Generado desde pronóstico AI #{forecast.id}. Confianza: {forecast.confidence_score}%',
            created_by=created_by
        )
        
        db.session.add(demand)
        db.session.commit()
        
        return demand.serialize()
    
    def delete(self, forecast_id: int, org_id: int) -> bool:
        """Eliminar pronóstico"""
        forecast = Forecast.query.filter_by(id=forecast_id, org_id=org_id).first()
        if not forecast:
            return False
        
        db.session.delete(forecast)
        db.session.commit()
        return True
