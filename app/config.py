# app/config.py
import os
from datetime import timedelta
from urllib.parse import quote_plus

class BaseConfig:
    """Configuración base para todos los ambientes"""
    
    # Flask
    DEBUG = os.getenv("FLASK_DEBUG", "0") == "1"
    MAX_CONTENT_LENGTH = int(os.getenv("MAX_CONTENT_LENGTH", 10 * 1024 * 1024))  # 10MB default
    
    # Regiones AWS (si usas servicios AWS en el futuro)
    AWS_REGION = os.getenv("AWS_REGION", "us-east-1")
    AWS_REKOGNITION_REGION = os.getenv("AWS_REKOGNITION_REGION") or AWS_REGION
    AWS_TEXTRACT_REGION = os.getenv("AWS_TEXTRACT_REGION") or AWS_REGION
    AWS_PROFILE = os.getenv("AWS_PROFILE")  # opcional (usa CLI default si None)
    
    # Base de datos PostgreSQL
    DB_USER = os.getenv("DB_USER", "postgres")
    DB_PASS = os.getenv("DB_PASS", "admin123*")
    DB_HOST = os.getenv("DB_HOST", "localhost")
    DB_PORT = os.getenv("DB_PORT", "5432")
    DB_NAME = os.getenv("DB_NAME", "mrp")
    DB_SCHEMA = os.getenv("DB_SCHEMA", "public")
    
    # SQLAlchemy - URL encode password para manejar caracteres especiales
    _db_user_encoded = quote_plus(DB_USER)
    _db_pass_encoded = quote_plus(DB_PASS)
    
    SQLALCHEMY_DATABASE_URI = (
        f"postgresql+psycopg2://{_db_user_encoded}:{_db_pass_encoded}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
        f"?options=-csearch_path%3D{DB_SCHEMA}"
        f"&client_encoding=utf8"
    )
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    SQLALCHEMY_ENGINE_OPTIONS = {
        "pool_pre_ping": True,           # Verificar conexión antes de usar
        "pool_recycle": 300,             # Reciclar conexiones cada 5 min
        "pool_size": 10,                 # Tamaño del pool de conexiones
        "max_overflow": 20,              # Conexiones extras permitidas
        "connect_args": {
            "connect_timeout": 10,       # Timeout de conexión
            "client_encoding": "utf8",
        },
    }
    
    # JWT
    JWT_SECRET_KEY = os.getenv("JWT_SECRET_KEY", "uagrm123")
    JWT_ACCESS_TOKEN_EXPIRES = timedelta(
        hours=int(os.getenv("JWT_ACCESS_HOURS", "24"))
    )
    JWT_REFRESH_TOKEN_EXPIRES = timedelta(
        days=int(os.getenv("JWT_REFRESH_DAYS", "30"))
    )
    
    # Carpetas de uploads (si se usan en el futuro)
    IMAGENES_USUARIOS_CARPETA = os.getenv(
        "UPLOADS_USER_FOLDER", 
        "./uploads/users"
    )


class DevConfig(BaseConfig):
    """Configuración para desarrollo local"""
    DEBUG = True
    SQLALCHEMY_ECHO = os.getenv("SQLALCHEMY_ECHO", "0") == "1"  # Log de SQL queries


class ProdConfig(BaseConfig):
    """Configuración para producción"""
    DEBUG = False
    # En producción, las variables de entorno deben estar configuradas
    # No usar valores por defecto inseguros


class Config(DevConfig):
    """Alias para compatibilidad con código existente"""
    pass


def get_config():
    """Retorna la configuración según el ambiente"""
    env = os.getenv("FLASK_ENV", "development")
    
    if env == "production":
        return ProdConfig
    else:
        return DevConfig
