import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from run import app
from app.models.user_role import UserRole
from app.models.role import Role

with app.app_context():
    user_roles = UserRole.query.filter_by(user_id=6).all()
    print(f'\n✅ Usuario 6 (test@test.com) tiene {len(user_roles)} roles:\n')
    
    if not user_roles:
        print('❌ SIN ROLES - El menú estará vacío')
    else:
        for ur in user_roles:
            role = Role.query.get(ur.role_id)
            print(f'  - Role ID: {ur.role_id}, Nombre: {role.name if role else "DELETED"}')
