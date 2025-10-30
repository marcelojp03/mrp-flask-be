# auth/__init__.py
"""
Módulo de autenticación y decoradores personalizados
"""
from .decorators import auth_required

__all__ = ['auth_required']
