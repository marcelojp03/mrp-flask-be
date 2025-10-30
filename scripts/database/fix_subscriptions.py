import sys
import os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from run import app
from app.models.org_subscription import OrgSubscription
from app.models.organization import Organization
from app.models.plan import Plan
from datetime import datetime, timedelta
from app.db import db

with app.app_context():
    print("\n=== VERIFICAR SUSCRIPCIONES ===\n")
    
    # Listar todas las orgs
    orgs = Organization.query.all()
    print(f"📊 Total organizaciones: {len(orgs)}")
    
    for org in orgs:
        sub = OrgSubscription.query.filter_by(org_id=org.id).first()
        if sub:
            plan = Plan.query.get(sub.plan_id)
            print(f"\n✅ Org {org.id} ({org.name})")
            print(f"   Plan: {plan.name if plan else 'N/A'}")
            print(f"   Status: {sub.status}")
        else:
            print(f"\n❌ Org {org.id} ({org.name}) - SIN SUSCRIPCIÓN")
            
            # Crear suscripción Free por defecto
            free_plan = Plan.query.filter_by(code='free').first()
            if free_plan:
                new_sub = OrgSubscription(
                    org_id=org.id,
                    plan_id=free_plan.id,
                    status='active',
                    trial_until=datetime.utcnow() + timedelta(days=14)
                )
                db.session.add(new_sub)
                print(f"   ✅ Suscripción Free creada")
    
    db.session.commit()
    print("\n=== FIN ===\n")
