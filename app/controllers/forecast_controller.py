# controllers/forecast_controller.py
from flask import Blueprint, request, g
from datetime import date
from app.services.forecast_service import ForecastService
from app.responses import Responses
from auth.decorators import auth_required

forecast_bp = Blueprint('forecast', __name__, url_prefix='/api/forecast')
forecast_service = ForecastService()

@forecast_bp.route('', methods=['GET'])
@auth_required
def list_forecasts(org_id, user_id):
    """
    GET /api/forecast
    Listar pronósticos con filtros
    
    Query params:
    - product_id: int
    - period_start: date (YYYY-MM-DD)
    - period_end: date (YYYY-MM-DD)
    - method: statistical (MOVING_AVG, WEIGHTED_AVG, EXP_SMOOTHING, LINEAR_REGRESSION)
    - status: draft|published|cancelled
    """
    try:
        product_id = request.args.get('product_id', type=int)
        period_start = request.args.get('period_start')
        period_end = request.args.get('period_end')
        method = request.args.get('method')
        status = request.args.get('status')
        
        if period_start:
            period_start = date.fromisoformat(period_start)
        if period_end:
            period_end = date.fromisoformat(period_end)
        
        forecasts = forecast_service.list(
            org_id=org_id,
            product_id=product_id,
            period_start=period_start,
            period_end=period_end,
            method=method,
            status=status
        )
        
        return Responses.success(
            data=forecasts,
            message=f'{len(forecasts)} pronósticos encontrados'
        )
    
    except Exception as e:
        return Responses.error(str(e), 500)


@forecast_bp.route('/<int:forecast_id>', methods=['GET'])
@auth_required
def get_forecast(org_id, user_id, forecast_id):
    """GET /api/forecast/:id - Obtener pronóstico por ID"""
    try:
        forecast = forecast_service.get(forecast_id, org_id)
        
        if not forecast:
            return Responses.error('Pronóstico no encontrado', 404)
        
        return Responses.success(data=forecast)
    
    except Exception as e:
        return Responses.error(str(e), 500)


@forecast_bp.route('/generate', methods=['POST'])
@auth_required
def generate_forecast(org_id, user_id):
    """
    POST /api/forecast/generate
    Generar pronósticos usando métodos estadísticos
    
    Body:
    {
        "product_id": 123,
        "periods": 3,  // Número de períodos a pronosticar (default 3)
        "method": "MOVING_AVG",  // MOVING_AVG, WEIGHTED_AVG, EXP_SMOOTHING, LINEAR_REGRESSION
        "historical_periods": 6  // Para métodos estadísticos (default 6)
    }
    
    Métodos disponibles:
    - MOVING_AVG: Media móvil simple
    - WEIGHTED_AVG: Media móvil ponderada (más peso a datos recientes)
    - EXP_SMOOTHING: Suavizamiento exponencial
    - LINEAR_REGRESSION: Regresión lineal con tendencia
    
    Response:
    [
        {
            "id": 1,
            "product_id": 123,
            "period": "2025-02-01",
            "forecasted_quantity": 150.50,
            "confidence_score": 85.5,
            "method": "moving_avg",
            "model_used": "MOVING_AVG (n=6)",
            "status": "draft",
            ...
        }
    ]
    """
    try:
        data = request.get_json()
        
        if 'product_id' not in data:
            return Responses.error('Campo requerido: product_id', 400)
        
        product_id = data['product_id']
        periods = data.get('periods', data.get('periods_ahead', 3))
        method = data.get('method', 'MOVING_AVG').upper()
        historical_periods = data.get('historical_periods', 6)
        
        if periods < 1 or periods > 12:
            return Responses.error('periods debe estar entre 1 y 12', 400)
        
        # Métodos estadísticos
        statistical_methods = ['MOVING_AVG', 'WEIGHTED_AVG', 'EXP_SMOOTHING', 'LINEAR_REGRESSION']
        
        if method in statistical_methods:
            forecasts = forecast_service.generate_statistical(
                org_id=org_id,
                product_id=product_id,
                method=method,
                periods_ahead=periods,
                historical_periods=historical_periods,
                created_by=user_id
            )
            message = f'{len(forecasts)} pronósticos generados con {method}'
        
        else:
            return Responses.error(
                f'Método no válido: {method}. Use: {", ".join(statistical_methods)}',
                400
            )
        
        return Responses.success(
            data=forecasts,
            message=message,
            http_code=201
        )
    
    except ValueError as e:
        return Responses.error(str(e), 400)
    except Exception as e:
        return Responses.error(str(e), 500)


@forecast_bp.route('/historical/<int:product_id>', methods=['GET'])
@auth_required
def get_historical_data(org_id, user_id, product_id):
    """
    GET /api/forecast/historical/:product_id
    Obtener datos históricos de demanda para un producto
    
    Query params:
    - months_back: int (default 6)
    
    Response:
    {
        "product_id": 123,
        "period_start": "2024-08-01",
        "period_end": "2025-01-31",
        "months_analyzed": 6,
        "demands": [...],
        "movements": [...],
        "statistics": {
            "demand_avg": 125.50,
            "demand_min": 80.00,
            "demand_max": 200.00,
            ...
        }
    }
    """
    try:
        months_back = request.args.get('months_back', 6, type=int)
        
        if months_back < 1 or months_back > 24:
            return Responses.error('months_back debe estar entre 1 y 24', 400)
        
        historical = forecast_service.get_historical_data(
            org_id=org_id,
            product_id=product_id,
            months_back=months_back
        )
        
        return Responses.success(data=historical)
    
    except Exception as e:
        return Responses.error(str(e), 500)


@forecast_bp.route('/<int:forecast_id>/publish', methods=['PUT'])
@auth_required
def publish_forecast(org_id, user_id, forecast_id):
    """
    PUT /api/forecast/:id/publish
    Publicar pronóstico (cambiar status a published)
    """
    try:
        forecast = forecast_service.publish(forecast_id, org_id)
        
        if not forecast:
            return Responses.error('Pronóstico no encontrado', 404)
        
        return Responses.success(
            data=forecast,
            message='Pronóstico publicado exitosamente'
        )
    
    except Exception as e:
        return Responses.error(str(e), 500)


@forecast_bp.route('/publish-bulk', methods=['POST'])
@auth_required
def publish_bulk(org_id, user_id):
    """
    POST /api/forecast/publish-bulk
    Publicar múltiples pronósticos
    
    Body:
    {
        "forecast_ids": [1, 2, 3, 4, 5]
    }
    """
    try:
        data = request.get_json()
        
        if 'forecast_ids' not in data or not isinstance(data['forecast_ids'], list):
            return Responses.error('Campo requerido: forecast_ids (array)', 400)
        
        forecasts = forecast_service.bulk_publish(data['forecast_ids'], org_id)
        
        return Responses.success(
            data=forecasts,
            message=f'{len(forecasts)} pronósticos publicados'
        )
    
    except Exception as e:
        return Responses.error(str(e), 500)


@forecast_bp.route('/<int:forecast_id>/convert-to-demand', methods=['POST'])
@auth_required
def convert_to_demand(org_id, user_id, forecast_id):
    """
    POST /api/forecast/:id/convert-to-demand
    Convertir pronóstico publicado en demanda draft
    
    Esto permite que el pronóstico alimente el flujo:
    Forecast → Demand → MPS → MRP
    """
    try:
        demand = forecast_service.convert_to_demand(
            forecast_id=forecast_id,
            org_id=org_id,
            created_by=user_id
        )
        
        return Responses.success(
            data=demand,
            message='Pronóstico convertido a demanda exitosamente',
            http_code=201
        )
    
    except ValueError as e:
        return Responses.error(str(e), 400)
    except Exception as e:
        return Responses.error(str(e), 500)


@forecast_bp.route('/<int:forecast_id>', methods=['DELETE'])
@auth_required
def delete_forecast(org_id, user_id, forecast_id):
    """DELETE /api/forecast/:id - Eliminar pronóstico"""
    try:
        deleted = forecast_service.delete(forecast_id, org_id)
        
        if not deleted:
            return Responses.error('Pronóstico no encontrado', 404)
        
        return Responses.success(message='Pronóstico eliminado exitosamente')
    
    except Exception as e:
        return Responses.error(str(e), 500)
