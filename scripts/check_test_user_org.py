import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from app.db import db
from models.user import User
from models.user_organization import UserOrganization
from run import app

with app.app_context():
    u = User.query.filter_by(email='test@test.com').first()
    if u:
        print(f"✅ User encontrado: ID={u.id}, Email={u.email}")
        uo = UserOrganization.query.filter_by(user_id=u.id).all()
        if uo:
            print(f"📂 Organizaciones:")
            for x in uo:
                default_str = " (DEFAULT)" if x.is_default else ""
                print(f"   - Org ID: {x.org_id}{default_str}")
        else:
            print("❌ Usuario SIN organizaciones asignadas")
    else:
        print("❌ Usuario test@test.com NO encontrado")
