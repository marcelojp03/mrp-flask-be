# app/__init__.py
"""
Módulo de configuración y utilidades de la aplicación

Este __init__.py exporta los componentes reutilizables.
Para importar la app Flask, usa: from app.main import app
"""

from .config import get_config, Config, BaseConfig, DevConfig, ProdConfig
from .responses import Responses

# Si en el futuro se migra a factory pattern, descomentar:
# from .utils import some_utility

__all__ = [
    'get_config',
    'Config',
    'BaseConfig', 
    'DevConfig',
    'ProdConfig',
    'Responses',
]
