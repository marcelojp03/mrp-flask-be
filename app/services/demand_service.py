# services/demand_service.py
from typing import List, Optional
from datetime import date
import logging
from app.db import db
from app.models.demand import Demand
from app.models.product import Product

logger = logging.getLogger(__name__)

class DemandService:
    """Servicio para gestión de demanda - Sprint 4"""
    
    def list(self, org_id: int, product_id: Optional[int] = None, 
             period_start: Optional[date] = None, period_end: Optional[date] = None,
             source: Optional[str] = None, status: Optional[str] = None) -> List[dict]:
        """Listar demandas con filtros"""
        query = Demand.query.filter_by(org_id=org_id)
        
        if product_id:
            query = query.filter_by(product_id=product_id)
        
        if period_start:
            query = query.filter(Demand.period >= period_start)
        
        if period_end:
            query = query.filter(Demand.period <= period_end)
        
        if source:
            query = query.filter_by(source=source)
        
        if status:
            query = query.filter_by(status=status)
        
        demands = query.order_by(Demand.period.asc(), Demand.product_id.asc()).all()
        return [d.serialize() for d in demands]
    
    def get(self, demand_id: int, org_id: int) -> Optional[dict]:
        """Obtener demanda por ID"""
        demand = Demand.query.filter_by(id=demand_id, org_id=org_id).first()
        return demand.serialize() if demand else None
    
    def create(self, org_id: int, product_id: int, period: date, quantity: float,
               source: str = 'manual', status: str = 'draft', 
               notes: Optional[str] = None, created_by: Optional[int] = None) -> dict:
        """Crear nueva demanda"""
        try:
            logger.info(f"📝 Creating demand: org={org_id}, product={product_id}, qty={quantity}, period={period}")
            
            # Validar que el producto existe y pertenece a la org
            product = Product.query.filter_by(id=product_id, org_id=org_id, status=True).first()
            if not product:
                logger.error(f"❌ Product not found: product_id={product_id}, org_id={org_id}")
                raise ValueError("Producto no encontrado o no pertenece a la organización")
            
            if quantity <= 0:
                logger.error(f"❌ Invalid quantity: {quantity}")
                raise ValueError("La cantidad debe ser mayor a 0")
            
            demand = Demand(
                org_id=org_id,
                product_id=product_id,
                period=period,
                quantity=quantity,
                source=source,
                status=status,
                notes=notes,
                created_by=created_by
            )
            
            db.session.add(demand)
            db.session.commit()
            logger.info(f"✅ Demand created successfully: id={demand.id}")
            return demand.serialize()
        except Exception as e:
            logger.error(f"❌ Error creating demand: {str(e)}", exc_info=True)
            db.session.rollback()
            raise
    
    def update(self, demand_id: int, org_id: int, **kwargs) -> Optional[dict]:
        """Actualizar demanda"""
        demand = Demand.query.filter_by(id=demand_id, org_id=org_id).first()
        if not demand:
            return None
        
        # Validar cantidad si se actualiza
        if 'quantity' in kwargs and kwargs['quantity'] is not None:
            if kwargs['quantity'] <= 0:
                raise ValueError("La cantidad debe ser mayor a 0")
        
        # Actualizar campos permitidos
        allowed_fields = ['quantity', 'period', 'source', 'status', 'notes']
        for key, value in kwargs.items():
            if key in allowed_fields and value is not None:
                setattr(demand, key, value)
        
        db.session.commit()
        return demand.serialize()
    
    def delete(self, demand_id: int, org_id: int) -> bool:
        """Eliminar demanda"""
        demand = Demand.query.filter_by(id=demand_id, org_id=org_id).first()
        if not demand:
            return False
        
        db.session.delete(demand)
        db.session.commit()
        return True
    
    def bulk_create(self, org_id: int, demands_data: List[dict], created_by: Optional[int] = None) -> List[dict]:
        """Crear múltiples demandas (útil para import CSV)"""
        created_demands = []
        
        for data in demands_data:
            try:
                demand = self.create(
                    org_id=org_id,
                    product_id=data['product_id'],
                    period=data['period'],
                    quantity=data['quantity'],
                    source=data.get('source', 'import'),
                    status=data.get('status', 'draft'),
                    notes=data.get('notes'),
                    created_by=created_by
                )
                created_demands.append(demand)
            except Exception as e:
                # Log error pero continuar con los demás
                print(f"Error creando demanda: {e}")
                continue
        
        return created_demands
    
    def confirm(self, demand_id: int, org_id: int) -> Optional[dict]:
        """
        Confirmar demanda (cambiar status de draft a confirmed)
        Solo se pueden confirmar demandas en status 'draft'
        """
        demand = Demand.query.filter_by(id=demand_id, org_id=org_id, status='draft').first()
        if not demand:
            return None
        
        demand.status = 'confirmed'
        db.session.commit()
        logger.info(f"✅ Demand confirmed: id={demand_id}")
        return demand.serialize()
    
    def get_summary(self, org_id: int, period_start: Optional[date] = None, 
                   period_end: Optional[date] = None) -> dict:
        """
        Obtener resumen de demandas por estado, fuente y período
        """
        query = Demand.query.filter_by(org_id=org_id)
        
        if period_start:
            query = query.filter(Demand.period >= period_start)
        if period_end:
            query = query.filter(Demand.period <= period_end)
        
        demands = query.all()
        
        # Resumen por estado
        by_status = {}
        for demand in demands:
            by_status[demand.status] = by_status.get(demand.status, 0) + 1
        
        # Resumen por fuente
        by_source = {}
        for demand in demands:
            by_source[demand.source] = by_source.get(demand.source, 0) + 1
        
        # Resumen por período
        by_period = {}
        for demand in demands:
            period_key = demand.period.isoformat()
            if period_key not in by_period:
                by_period[period_key] = {'count': 0, 'total_quantity': 0.0}
            by_period[period_key]['count'] += 1
            by_period[period_key]['total_quantity'] += float(demand.quantity)
        
        # Convertir dict a lista ordenada
        by_period_list = [
            {
                'period': period,
                'count': data['count'],
                'total_quantity': data['total_quantity']
            }
            for period, data in sorted(by_period.items())
        ]
        
        # Total de cantidad
        total_quantity = sum(float(d.quantity) for d in demands)
        
        return {
            'total': len(demands),
            'by_status': by_status,
            'by_source': by_source,
            'by_period': by_period_list,
            'total_quantity': total_quantity
        }
