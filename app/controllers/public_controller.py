# controllers/public_controller.py
from flask import Blueprint, request, jsonify
from app.db import db
from app.responses import Responses
from app.models.organization import Organization
from app.models.user import User
from app.models.user_organization import UserOrganization
from app.models.user_role import UserRole
from app.models.warehouse import Warehouse
from app.models.plan import Plan
from app.models.org_subscription import OrgSubscription
from app.services.auth_service import AuthService
from werkzeug.security import generate_password_hash
from datetime import datetime, timedelta

public_bp = Blueprint('public', __name__, url_prefix='/api/public')

@public_bp.route('/plans', methods=['GET'])
def list_plans():
    """Lista planes activos para landing público"""
    try:
        plans = Plan.query.filter_by(is_active=True).order_by(Plan.id).all()
        return Responses.success([p.serialize() for p in plans])  # Ya retorna (jsonify, 200)
    except Exception as ex:
        return Responses.error(f'Error al obtener planes: {ex}', 500)


@public_bp.route('/signup', methods=['POST'])
def signup():
    """
    Registro SaaS: crea organización + usuario admin + suscripción + bootstrap inicial
    Body: {org_name, org_code, admin_name, admin_email, password, plan_code}
    """
    data = request.get_json() or {}
    org_name = (data.get('org_name') or '').strip()
    org_code = (data.get('org_code') or '').strip().upper()
    plan_code = (data.get('plan_code') or 'free').strip().lower()
    admin_name = (data.get('admin_name') or '').strip()
    admin_email = (data.get('admin_email') or '').strip().lower()
    password = (data.get('password') or '').strip()

    # Validar campos obligatorios
    if not all([org_name, org_code, admin_name, admin_email, password]):
        return Responses.error('Faltan campos obligatorios', 400)

    if len(password) < 6:
        return Responses.error('La contraseña debe tener al menos 6 caracteres', 400)

    try:
        # A) Validar org_code único
        exists_code = db.session.query(Organization.id).filter_by(code=org_code).first()
        if exists_code:
            return Responses.error('El código de organización ya existe', 409)

        # B) Validar org_name no repetido (case-insensitive)
        exists_name = db.session.query(Organization.id).filter(
            db.func.lower(Organization.name) == org_name.lower()
        ).first()
        if exists_name:
            return Responses.error('El nombre de la empresa ya existe', 409)

        # C) Validar email único
        exists_user = db.session.query(User.id).filter(
            db.func.lower(User.email) == admin_email
        ).first()
        if exists_user:
            return Responses.error('El email ya está registrado', 409)

        # D) Validar plan_code
        plan = Plan.query.filter_by(code=plan_code, is_active=True).first()
        if not plan:
            return Responses.error('Plan inválido o inactivo', 400)

        # === TRANSACCIÓN ===
        # 1) Crear organización
        org = Organization(name=org_name, code=org_code, is_active=True)
        db.session.add(org)
        db.session.flush()

        # 2) Crear usuario admin
        hashed_pw = generate_password_hash(password)
        user = User(name=admin_name, email=admin_email, password=hashed_pw, status=True)
        db.session.add(user)
        db.session.flush()

        # 3) Relación user_organization (is_default=true)
        uo = UserOrganization(user_id=user.id, org_id=org.id, is_default=True)
        db.session.add(uo)

        # 4) Crear suscripción con trial de 14 días
        trial_until = datetime.utcnow() + timedelta(days=14)
        sub = OrgSubscription(
            org_id=org.id,
            plan_id=plan.id,
            status='active',
            trial_until=trial_until
        )
        db.session.add(sub)

        # 5) Asignar ROL "Admin"
        admin_role = db.session.execute(
            db.text("SELECT id FROM role WHERE LOWER(name)='admin' LIMIT 1")
        ).scalar()
        if admin_role:
            ur = UserRole(user_id=user.id, role_id=admin_role)
            db.session.add(ur)

        # 6) Bootstrap: crear almacén "Principal" si no existe
        warehouse = Warehouse(name='Principal', location='Sucursal Central', org_id=org.id)
        db.session.add(warehouse)

        db.session.commit()

        # 7) Generar token automático post-signup
        auth_svc = AuthService()
        token_obj = auth_svc.login(admin_email, password)

        if not token_obj:
            return Responses.error('Cuenta creada pero no se pudo autenticar', 500)

        return Responses.success(token_obj, 'Cuenta creada exitosamente', http_code=201)

    except Exception as ex:
        db.session.rollback()
        return Responses.error(f'No se pudo crear la cuenta: {ex}', 400)
