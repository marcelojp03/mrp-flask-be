# services/auth_service.py
from datetime import datetime, timedelta
from app.db import db
from app.models.user import User
from werkzeug.security import check_password_hash, generate_password_hash
import jwt
from flask import current_app
from app.services.user_organization_service import UserOrganizationService
uosvc = UserOrganizationService()

class AuthService:
    def _encode_token(self, payload: dict, expires_minutes=60):
        key = current_app.config.get('JWT_SECRET_KEY')
        if not isinstance(key, (str, bytes, bytearray)) or not key:
            raise RuntimeError("SECRET_KEY must be a non-empty string/bytes")

        data = payload.copy()
        data['exp'] = datetime.utcnow() + timedelta(minutes=expires_minutes)
        data['iat'] = datetime.utcnow()

        token = jwt.encode(data, key, algorithm='HS256')
        # PyJWT < 2.0 retorna bytes:
        if isinstance(token, (bytes, bytearray)):
            token = token.decode('utf-8')
        return token

    def login(self, email: str, password: str):
        u: User = User.query.filter_by(email=email).first()
        if not u:
            print("usuario no encontrado para email:", email)
            return None
        print("usuario obtenido:", u.serialize())
        # Si las contraseñas fueron guardadas en claro, intenta plan B:
        ok = check_password_hash(u.password, password) if u.password else (u.password == password)
        print("verificación de contraseña:", ok)
        if not ok:
            return None
        
        # obtener org por defecto (o primera)
        org_id = uosvc.get_default_org_id(u.id) or 1

        # Generar access_token (1 hora) y refresh_token (7 días)
        access_token = self._encode_token({'sub': u.id, 'email': u.email, 'org_id': org_id}, expires_minutes=60)
        refresh_token = self._encode_token({'sub': u.id, 'email': u.email, 'org_id': org_id, 'type': 'refresh'}, expires_minutes=10080)  # 7 días
        
        return {
            'token': access_token,  # Mantener por compatibilidad
            'access_token': access_token,
            'refresh_token': refresh_token,
            'user': u.serialize(),
            'org_id': org_id
        }

    def hash_password(self, password: str) -> str:
        return generate_password_hash(password)

    def verify(self, token: str):
        try:
            data = jwt.decode(token, current_app.config['JWT_SECRET_KEY'], algorithms=['HS256'])
            return data
        except Exception:
            return None
