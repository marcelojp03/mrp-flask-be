from flask import Blueprint, current_app, request
import jwt
from app.responses import Responses
from services.auth_service import AuthService

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
    auth = request.headers.get('Authorization', '')
    if not auth.startswith('Bearer '):
        return Responses.error("Token faltante", http_code=401, code="NO_TOKEN")
    token = auth.split(' ', 1)[1].strip()

    try:
        data = jwt.decode(token, current_app.config['JWT_SECRET_KEY'], algorithms=['HS256'], options={"verify_exp": False})
    except jwt.InvalidTokenError:
        return Responses.error("Token inválido", http_code=401, code="TOKEN_INVALID")

    # opcional: valida jti en blacklist/rotación, etc.
    from services.auth_service import AuthService
    new_token = AuthService()._encode_token({'sub': data['sub'], 'email': data['email'], 'org_id': data.get('org_id', 1)})
    return Responses.success({"token": new_token})
