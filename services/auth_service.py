# services/auth_service.py
from datetime import datetime, timedelta
from myapp import db
from models.user import User
from werkzeug.security import check_password_hash, generate_password_hash
import jwt
from flask import current_app

class AuthService:
    def _encode_token(self, payload: dict, expires_minutes=60):
        data = payload.copy()
        data['exp'] = datetime.utcnow() + timedelta(minutes=expires_minutes)
        return jwt.encode(data, current_app.config['SECRET_KEY'], algorithm='HS256')

    def login(self, email: str, password: str):
        u: User = User.query.filter_by(email=email).first()
        if not u:
            return None
        # Si las contraseñas fueron guardadas en claro, intenta plan B:
        ok = check_password_hash(u.password, password) if u.password and u.password.startswith('pbkdf2:') else (u.password == password)
        if not ok:
            return None
        token = self._encode_token({'sub': u.id, 'email': u.email})
        return {'token': token, 'user': u.serialize()}

    def hash_password(self, password: str) -> str:
        return generate_password_hash(password)

    def verify(self, token: str):
        try:
            data = jwt.decode(token, current_app.config['SECRET_KEY'], algorithms=['HS256'])
            return data
        except Exception:
            return None
