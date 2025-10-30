from flask import Blueprint, current_app, request
import jwt
from app.responses import Responses
from app.services.auth_service import AuthService

auth_bp = Blueprint('auth', __name__, url_prefix='/api/auth')
auth_service = AuthService()

@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json() or {}
    try:
        result = auth_service.login(
            email=data.get('email') or data.get('correo'),
            password=data.get('password') or data.get('contraseña')
        )
        if not result:
            # credenciales inválidas
            return Responses.error("Credenciales inválidas", http_code=401, code="AUTH_FAILED")
        return Responses.success(result, message="OK")
    except Exception as ex:
        return Responses.from_exception(ex, http_code=500, code="AUTH_ERROR")
    
@auth_bp.route('/refresh', methods=['POST'])
def refresh():
    # Acepta refresh_token desde header Authorization o body
    auth = request.headers.get('Authorization', '')
    data = request.get_json() or {}
    
    token = None
    if auth.startswith('Bearer '):
        token = auth.split(' ', 1)[1].strip()
    elif data.get('refresh_token'):
        token = data['refresh_token']
    
    if not token:
        return Responses.error("Refresh token faltante", http_code=401, code="NO_TOKEN")

    try:
        payload = jwt.decode(token, current_app.config['JWT_SECRET_KEY'], algorithms=['HS256'])
        
        # Verificar que sea un refresh token
        if payload.get('type') != 'refresh':
            return Responses.error("Token inválido (no es refresh token)", http_code=401, code="INVALID_TOKEN_TYPE")
        
    except jwt.ExpiredSignatureError:
        return Responses.error("Refresh token expirado", http_code=401, code="TOKEN_EXPIRED")
    except jwt.InvalidTokenError:
        return Responses.error("Refresh token inválido", http_code=401, code="TOKEN_INVALID")

    # Generar nuevo access_token
    new_access_token = auth_service._encode_token({
        'sub': payload['sub'],
        'email': payload['email'],
        'org_id': payload.get('org_id', 1)
    }, expires_minutes=60)
    
    return Responses.success({
        "access_token": new_access_token,
        "token": new_access_token  # Alias por compatibilidad
    }, message="Token renovado")
