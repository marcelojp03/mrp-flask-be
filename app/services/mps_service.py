# services/mps_service.py
from typing import List, Optional, Dict
from datetime import date, datetime
from app.db import db
from app.models.mps_plan import MPSPlan
from app.models.demand import Demand
from app.models.product import Product
from sqlalchemy import func

class MPSService:
    """Servicio para Plan Maestro de Producción - Sprint 4"""
    
    def list(self, org_id: int, product_id: Optional[int] = None,
             period_start: Optional[date] = None, period_end: Optional[date] = None,
             status: Optional[str] = None) -> List[dict]:
        """Listar planes MPS con filtros"""
        query = MPSPlan.query.filter_by(org_id=org_id)
        
        if product_id:
            query = query.filter_by(product_id=product_id)
        
        if period_start:
            query = query.filter(MPSPlan.period >= period_start)
        
        if period_end:
            query = query.filter(MPSPlan.period <= period_end)
        
        if status:
            query = query.filter_by(status=status)
        
        plans = query.order_by(MPSPlan.period.asc(), MPSPlan.product_id.asc()).all()
        return [p.serialize() for p in plans]
    
    def get(self, mps_plan_id: int, org_id: int) -> Optional[dict]:
        """Obtener plan MPS por ID"""
        plan = MPSPlan.query.filter_by(id=mps_plan_id, org_id=org_id).first()
        return plan.serialize() if plan else None
    
    def simulate(self, org_id: int, period_start: date, period_end: date, 
                 product_ids: Optional[List[int]] = None) -> List[dict]:
        """
        Simular MPS basado en demanda confirmada
        Retorna propuestas de plan (no las guarda todavía)
        """
        # Obtener demanda confirmada para el rango de fechas
        query = Demand.query.filter_by(org_id=org_id, status='confirmed')
        query = query.filter(Demand.period >= period_start, Demand.period <= period_end)
        
        if product_ids:
            query = query.filter(Demand.product_id.in_(product_ids))
        
        demands = query.all()
        
        # Agrupar por producto y periodo
        mps_proposals = {}
        for demand in demands:
            key = (demand.product_id, demand.period)
            if key not in mps_proposals:
                mps_proposals[key] = {
                    'product_id': demand.product_id,
                    'product_code': demand.product.code if demand.product else None,
                    'product_name': demand.product.name if demand.product else None,
                    'period': demand.period.isoformat(),
                    'planned_qty': 0,
                    'demand_qty': 0,
                    'demand_ids': []
                }
            
            mps_proposals[key]['planned_qty'] += float(demand.quantity)
            mps_proposals[key]['demand_qty'] += float(demand.quantity)
            mps_proposals[key]['demand_ids'].append(demand.id)
        
        return list(mps_proposals.values())
    
    def publish(self, org_id: int, mps_data: List[dict], created_by: Optional[int] = None) -> List[dict]:
        """
        Publicar plan MPS
        Recibe lista de planes simulados y los guarda como 'published'
        """
        published_plans = []
        
        for data in mps_data:
            # Validar producto
            product = Product.query.filter_by(
                id=data['product_id'], 
                org_id=org_id, 
                status=True
            ).first()
            
            if not product:
                continue
            
            # Crear plan MPS
            mps_plan = MPSPlan(
                org_id=org_id,
                product_id=data['product_id'],
                period=data['period'] if isinstance(data['period'], date) else date.fromisoformat(data['period']),
                planned_qty=data['planned_qty'],
                status='published',
                demand_id=data.get('demand_ids', [None])[0] if data.get('demand_ids') else None,
                notes=data.get('notes'),
                created_by=created_by,
                published_at=datetime.utcnow()
            )
            
            db.session.add(mps_plan)
            published_plans.append(mps_plan)
        
        db.session.commit()
        return [p.serialize() for p in published_plans]
    
    def create(self, org_id: int, product_id: int, period: date, planned_qty: float,
               status: str = 'draft', demand_id: Optional[int] = None,
               notes: Optional[str] = None, created_by: Optional[int] = None) -> dict:
        """Crear plan MPS individual"""
        # Validar producto
        product = Product.query.filter_by(id=product_id, org_id=org_id, status=True).first()
        if not product:
            raise ValueError("Producto no encontrado")
        
        if planned_qty <= 0:
            raise ValueError("La cantidad planificada debe ser mayor a 0")
        
        mps_plan = MPSPlan(
            org_id=org_id,
            product_id=product_id,
            period=period,
            planned_qty=planned_qty,
            status=status,
            demand_id=demand_id,
            notes=notes,
            created_by=created_by
        )
        
        if status == 'published':
            mps_plan.published_at = datetime.utcnow()
        
        db.session.add(mps_plan)
        db.session.commit()
        return mps_plan.serialize()
    
    def update(self, mps_plan_id: int, org_id: int, **kwargs) -> Optional[dict]:
        """Actualizar plan MPS"""
        plan = MPSPlan.query.filter_by(id=mps_plan_id, org_id=org_id).first()
        if not plan:
            return None
        
        # No permitir editar planes publicados
        if plan.status == 'published' and 'status' not in kwargs:
            raise ValueError("No se puede editar un plan publicado")
        
        allowed_fields = ['planned_qty', 'period', 'status', 'notes']
        for key, value in kwargs.items():
            if key in allowed_fields and value is not None:
                setattr(plan, key, value)
        
        if 'status' in kwargs and kwargs['status'] == 'published' and not plan.published_at:
            plan.published_at = datetime.utcnow()
        
        db.session.commit()
        return plan.serialize()
    
    def delete(self, mps_plan_id: int, org_id: int) -> bool:
        """Eliminar plan MPS"""
        plan = MPSPlan.query.filter_by(id=mps_plan_id, org_id=org_id).first()
        if not plan:
            return False
        
        # No permitir eliminar planes publicados
        if plan.status == 'published':
            raise ValueError("No se puede eliminar un plan publicado")
        
        db.session.delete(plan)
        db.session.commit()
        return True
