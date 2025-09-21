from flask import Blueprint, request
from app.responses import Responses
from services.auth_service import AuthService

auth_bp = Blueprint('auth', __name__, url_prefix='/api/auth')
auth_service = AuthService()

@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json() or {}
    try:
        result = auth_service.login(email=data.get('email') or data.get('correo'),
                                    password=data.get('password') or data.get('contraseña'))
        return Responses.success(result)
    except Exception as ex:
        return Responses.from_exception(ex, http_code=401, code="AUTH_FAILED")
