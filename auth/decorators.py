# auth/decorators.py
from functools import wraps
from flask import request, g
import jwt
from flask import current_app
from app.responses import Responses
from datetime import timedelta
from jwt import ExpiredSignatureError, InvalidTokenError, DecodeError

def auth_required(fn):
    @wraps(fn)
    def wrapper(*args, **kwargs):
        auth = request.headers.get('Authorization', '')
        if not auth.startswith('Bearer '):
            return Responses.error("Token faltante", http_code=401, code="NO_TOKEN")

        token = auth.split(' ', 1)[1].strip()
        try:
            payload = jwt.decode(
                token,
                current_app.config['JWT_SECRET_KEY'],
                algorithms=['HS256'],
                leeway=timedelta(seconds=30)
            )
        except ExpiredSignatureError:
            return Responses.error("Token expirado", http_code=401, code="TOKEN_EXPIRED")
        except (DecodeError, InvalidTokenError):
            return Responses.error("Token inválido", http_code=401, code="TOKEN_INVALID")

        g.jwt = payload
        g.user_id = payload.get('sub')
        g.org_id = payload.get('org_id')
        if not g.user_id:
            return Responses.error("Token inválido (sin sub)", http_code=401, code="TOKEN_INVALID")
        return fn(*args, **kwargs)
    return wrapper
