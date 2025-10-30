#!/usr/bin/env python3
"""
Verificar la estructura de usuarios, organizaciones y planes en la BD
"""
from run import app
from app.db import db
from app.models.user import User
from app.models.organization import Organization
from app.models.user_organization import UserOrganization
from app.models.org_subscription import OrgSubscription
from app.models.plan import Plan

def verificar_estructura():
    with app.app_context():
        print("=" * 80)
        print("VERIFICACIÓN DE ESTRUCTURA DE DATOS")
        print("=" * 80)
        
        # 1. Verificar planes
        print("\n1️⃣ PLANES DISPONIBLES")
        print("-" * 80)
        planes = Plan.query.all()
        if planes:
            for plan in planes:
                print(f"   ID: {plan.id} | Code: {plan.code} | Name: {plan.name} | Active: {plan.is_active}")
                print(f"      Límites: Products={plan.max_products}, Warehouses={plan.max_warehouses}, Users={plan.max_users}")
        else:
            print("   ❌ No hay planes en la base de datos")
        
        # 2. Verificar organizaciones
        print("\n2️⃣ ORGANIZACIONES")
        print("-" * 80)
        orgs = Organization.query.all()
        if orgs:
            for org in orgs:
                print(f"   ID: {org.id} | Name: {org.name} | Code: {org.code}")
        else:
            print("   ❌ No hay organizaciones en la base de datos")
        
        # 3. Verificar usuarios
        print("\n3️⃣ USUARIOS")
        print("-" * 80)
        users = User.query.all()
        for user in users:
            print(f"\n   👤 User ID: {user.id} | Email: {user.email} | Name: {user.name}")
            
            # Verificar relación user -> organization
            user_orgs = UserOrganization.query.filter_by(user_id=user.id).all()
            if user_orgs:
                for uo in user_orgs:
                    org = Organization.query.get(uo.org_id)
                    print(f"      ✅ Pertenece a org: ID={uo.org_id} | Name={org.name if org else 'N/A'}")
            else:
                print(f"      ❌ NO pertenece a ninguna organización")
        
        # 4. Verificar suscripciones
        print("\n4️⃣ SUSCRIPCIONES (ORG -> PLAN)")
        print("-" * 80)
        subs = OrgSubscription.query.all()
        if subs:
            for sub in subs:
                org = Organization.query.get(sub.org_id)
                plan = Plan.query.get(sub.plan_id)
                is_trial = sub.trial_until is not None and sub.trial_until > db.func.now()
                print(f"   Org: {org.name if org else 'N/A'} (ID={sub.org_id})")
                print(f"   Plan: {plan.name if plan else 'N/A'} (ID={sub.plan_id})")
                print(f"   Status: {sub.status} | Trial Until: {sub.trial_until} | Started: {sub.started_at}")
                print()
        else:
            print("   ❌ No hay suscripciones en la base de datos")
        
        # 5. Diagnóstico del usuario de prueba
        print("\n5️⃣ DIAGNÓSTICO: marcelojp03@gmail.com")
        print("-" * 80)
        user = User.query.filter_by(email='marcelojp03@gmail.com').first()
        if not user:
            print("   ❌ Usuario no existe")
            return
        
        print(f"   ✅ Usuario existe: ID={user.id}, Name={user.name}")
        
        # Verificar org
        user_org = UserOrganization.query.filter_by(user_id=user.id).first()
        if not user_org:
            print(f"   ❌ Usuario NO tiene organización asignada")
            print(f"      SOLUCIÓN: Ejecutar fix_user_organization.py")
            return
        
        print(f"   ✅ Usuario tiene organización: ID={user_org.org_id}")
        
        org = Organization.query.get(user_org.org_id)
        if not org:
            print(f"   ❌ Organización {user_org.org_id} no existe en la tabla organization")
            return
        
        print(f"   ✅ Organización existe: {org.name} (Code: {org.code})")
        
        # Verificar subscription
        sub = OrgSubscription.query.filter_by(org_id=org.id).first()
        if not sub:
            print(f"   ❌ Organización NO tiene suscripción")
            print(f"      SOLUCIÓN: Ejecutar fix_subscription.py")
            return
        
        print(f"   ✅ Organización tiene suscripción: Plan ID={sub.plan_id}, Status={sub.status}")
        
        plan = Plan.query.get(sub.plan_id)
        if not plan:
            print(f"   ❌ Plan {sub.plan_id} no existe")
            return
        
        print(f"   ✅ Plan existe: {plan.name} (Code: {plan.code})")
        
        print("\n" + "=" * 80)
        print("✅ ESTRUCTURA COMPLETA - TODO BIEN")
        print("=" * 80)

if __name__ == '__main__':
    verificar_estructura()
