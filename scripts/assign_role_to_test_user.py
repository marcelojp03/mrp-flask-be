import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from run import app
from models.user_role import UserRole
from models.role import Role

with app.app_context():
    # Mostrar roles disponibles
    roles = Role.query.all()
    print(f'\n📋 Roles disponibles en la base de datos ({len(roles)} total):')
    for role in roles:
        print(f'   ID {role.id}: {role.name}')
    
    if not roles:
        print('\n❌ No hay roles en la base de datos. Ejecuta seeds/init_data.py primero.')
        sys.exit(1)
    
    # Asignar el primer rol al usuario test
    role_id = roles[0].id
    user_id = 6
    
    # Verificar si ya existe
    existing = UserRole.query.filter_by(user_id=user_id, role_id=role_id).first()
    
    if existing:
        print(f'\n⚠️  El usuario 6 ya tiene el rol "{roles[0].name}" asignado')
    else:
        new_user_role = UserRole(user_id=user_id, role_id=role_id)
        from app.db import db
        db.session.add(new_user_role)
        db.session.commit()
        print(f'\n✅ Rol "{roles[0].name}" asignado al usuario test@test.com')
    
    # Verificar
    user_roles = UserRole.query.filter_by(user_id=user_id).all()
    print(f'\n📊 Usuario 6 ahora tiene {len(user_roles)} rol(es):')
    for ur in user_roles:
        role = Role.query.get(ur.role_id)
        print(f'   - {role.name if role else "DELETED"}')
