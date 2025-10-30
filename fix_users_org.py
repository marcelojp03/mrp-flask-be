#!/usr/bin/env python3
"""
Asignar organización y plan a usuarios que no tienen
"""
from run import app
from app.db import db
from models.user import User
from models.organization import Organization
from models.user_organization import UserOrganization
from models.org_subscription import OrgSubscription
from models.plan import Plan
from datetime import datetime, timedelta

def fix_users():
    with app.app_context():
        print("=" * 80)
        print("ASIGNACIÓN DE ORGANIZACIONES A USUARIOS")
        print("=" * 80)
        
        # Obtener usuarios sin organización
        all_users = User.query.all()
        users_sin_org = []
        
        for user in all_users:
            user_org = UserOrganization.query.filter_by(user_id=user.id).first()
            if not user_org:
                users_sin_org.append(user)
        
        if not users_sin_org:
            print("\n✅ Todos los usuarios ya tienen organización")
            return
        
        print(f"\n📋 Usuarios sin organización: {len(users_sin_org)}")
        for user in users_sin_org:
            print(f"   - {user.email} (ID: {user.id})")
        
        # Obtener la primera organización disponible (Acme S.A.)
        org = Organization.query.filter_by(code='ACME').first()
        if not org:
            print("\n❌ No se encontró la organización ACME")
            return
        
        print(f"\n🏢 Asignando a organización: {org.name} (ID: {org.id})")
        
        # Verificar que la org tenga suscripción
        sub = OrgSubscription.query.filter_by(org_id=org.id).first()
        if not sub:
            print(f"   ⚠️ La organización no tiene suscripción, creando una...")
            
            # Obtener plan Free
            plan = Plan.query.filter_by(code='free').first()
            if not plan:
                print("   ❌ No se encontró el plan Free")
                return
            
            # Crear suscripción
            sub = OrgSubscription(
                org_id=org.id,
                plan_id=plan.id,
                status='active',
                started_at=datetime.utcnow(),
                trial_until=datetime.utcnow() + timedelta(days=14)
            )
            db.session.add(sub)
            db.session.commit()
            print(f"   ✅ Suscripción creada: Plan {plan.name}, Trial 14 días")
        else:
            plan = Plan.query.get(sub.plan_id)
            print(f"   ✅ Organización tiene suscripción: Plan {plan.name if plan else 'N/A'}")
        
        # Asignar usuarios a la organización
        print(f"\n👥 Asignando usuarios...")
        for user in users_sin_org:
            user_org = UserOrganization(
                user_id=user.id,
                org_id=org.id
            )
            db.session.add(user_org)
            print(f"   ✅ {user.email} → {org.name}")
        
        db.session.commit()
        
        print("\n" + "=" * 80)
        print("✅ TODOS LOS USUARIOS ASIGNADOS CORRECTAMENTE")
        print("=" * 80)
        
        # Verificación final
        print("\n📊 VERIFICACIÓN FINAL:")
        print("-" * 80)
        all_users = User.query.all()
        for user in all_users:
            user_org = UserOrganization.query.filter_by(user_id=user.id).first()
            if user_org:
                org = Organization.query.get(user_org.org_id)
                sub = OrgSubscription.query.filter_by(org_id=org.id).first()
                plan = Plan.query.get(sub.plan_id) if sub else None
                
                status = "✅" if (org and sub and plan) else "⚠️"
                print(f"{status} {user.email}")
                print(f"   Org: {org.name if org else 'N/A'}")
                print(f"   Plan: {plan.name if plan else 'N/A'}")
            else:
                print(f"❌ {user.email} - SIN ORGANIZACIÓN")

if __name__ == '__main__':
    fix_users()
