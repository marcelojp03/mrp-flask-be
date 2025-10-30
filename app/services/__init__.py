# services/__init__.py
"""
Módulo de servicios de lógica de negocio
"""

# Excepciones personalizadas
class ServiceError(Exception):
    def __init__(self, message, code='BAD_REQUEST', details=None):
        super().__init__(message)
        self.message = message
        self.code = code
        self.details = details or {}

class NotFound(ServiceError):
    def __init__(self, message='Not found', details=None):
        super().__init__(message, code='NOT_FOUND', details=details)

class Conflict(ServiceError):
    def __init__(self, message='Conflict', details=None):
        super().__init__(message, code='CONFLICT', details=details)

class Forbidden(ServiceError):
    def __init__(self, message='Forbidden', details=None):
        super().__init__(message, code='FORBIDDEN', details=details)

# Importar todos los servicios
from . import auth_service
from . import movement_service
from . import organization_service
from . import product_service
from . import product_warehouse_service
from . import resource_service
from . import role_resource_service
from . import role_service
from . import saas_guard_service
from . import stock_service
from . import subresource_service
from . import subscription_service
from . import supplier_item_service
from . import supplier_service
from . import unit_service
from . import user_organization_service
from . import user_role_service
from . import user_service
from . import warehouse_service

__all__ = [
    # Exceptions
    'ServiceError',
    'NotFound',
    'Conflict',
    'Forbidden',
    
    # Services
    'auth_service',
    'movement_service',
    'organization_service',
    'product_service',
    'product_warehouse_service',
    'resource_service',
    'role_resource_service',
    'role_service',
    'saas_guard_service',
    'stock_service',
    'subresource_service',
    'subscription_service',
    'supplier_item_service',
    'supplier_service',
    'unit_service',
    'user_organization_service',
    'user_role_service',
    'user_service',
    'warehouse_service',
]
