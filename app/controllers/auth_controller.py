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

@auth_bp.route('/change-password', methods=['PUT'])
def change_password():
    """Endpoint para que el usuario autenticado cambie su propia contraseña"""
    auth = request.headers.get('Authorization', '')
    if not auth.startswith('Bearer '):
        return Responses.error("Token de autorización requerido", http_code=401, code="NO_TOKEN")
    
    token = auth.split(' ', 1)[1].strip()
    
    try:
        payload = jwt.decode(token, current_app.config['JWT_SECRET_KEY'], algorithms=['HS256'])
        user_id = payload.get('sub')
        
        if not user_id:
            return Responses.error("Token inválido", http_code=401, code="INVALID_TOKEN")
        
    except jwt.ExpiredSignatureError:
        return Responses.error("Token expirado", http_code=401, code="TOKEN_EXPIRED")
    except jwt.InvalidTokenError:
        return Responses.error("Token inválido", http_code=401, code="TOKEN_INVALID")
    
    data = request.get_json() or {}
    current_password = data.get('current_password') or data.get('contraseña_actual')
    new_password = data.get('new_password') or data.get('nueva_contraseña')
    
    if not current_password or not new_password:
        return Responses.error(
            "Se requieren los campos 'current_password' y 'new_password'",
            http_code=422,
            code="VALIDATION_ERROR"
        )
    
    try:
        success = auth_service.change_password(user_id, current_password, new_password)
        if not success:
            return Responses.error("Contraseña actual incorrecta", http_code=401, code="WRONG_PASSWORD")
        return Responses.success(message="Contraseña actualizada correctamente")
    except Exception as ex:
        return Responses.from_exception(ex)
