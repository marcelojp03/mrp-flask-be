"""
Resetear Work Order #2 a estado Planificada
"""
import sys
sys.path.insert(0, '.')

from app.db import db
from app.models.work_order import WorkOrder
from run import app

with app.app_context():
    wo = WorkOrder.query.get(2)
    if wo:
        wo.status = 'Planificada'
        wo.actual_start = None
        wo.actual_end = None
        db.session.commit()
        print(f"✅ Work Order #{wo.id} reseteada a 'Planificada'")
    else:
        print("❌ Work Order #2 no encontrada")
