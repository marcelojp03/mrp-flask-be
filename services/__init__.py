# services/__init__.py
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
