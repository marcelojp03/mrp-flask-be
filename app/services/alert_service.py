# services/alert_service.py
from typing import List, Optional, Dict
from datetime import datetime, timedelta, date
from app.db import db
from app.models.alert import Alert
from app.models.product_warehouse import ProductWarehouse
from app.models.work_order import WorkOrder
from app.models.mrp_proposal import MRPProposal
from app.models.supplier_item import SupplierItem

class AlertService:
    """Servicio para gestión de alertas del sistema - Sprint 5"""
    
    def list(self, org_id: int, is_read: Optional[bool] = None, 
             type: Optional[str] = None, severity: Optional[str] = None,
             limit: int = 50) -> List[dict]:
        """Listar alertas con filtros"""
        query = Alert.query.filter_by(org_id=org_id)
        
        if is_read is not None:
            query = query.filter_by(is_read=is_read)
        
        if type:
            query = query.filter_by(type=type)
        
        if severity:
            query = query.filter_by(severity=severity)
        
        # Filtrar alertas no expiradas
        query = query.filter(
            db.or_(
                Alert.expires_at.is_(None),
                Alert.expires_at > datetime.utcnow()
            )
        )
        
        alerts = query.order_by(Alert.created_at.desc()).limit(limit).all()
        return [a.serialize() for a in alerts]
    
    def get(self, alert_id: int, org_id: int) -> Optional[dict]:
        """Obtener alerta por ID"""
        alert = Alert.query.filter_by(id=alert_id, org_id=org_id).first()
        return alert.serialize() if alert else None
    
    def create(self, org_id: int, type: str, title: str, message: str,
               severity: str = 'info', reference_type: Optional[str] = None,
               reference_id: Optional[int] = None, metadata: Optional[dict] = None,
               expires_at: Optional[datetime] = None) -> dict:
        """Crear nueva alerta"""
        alert = Alert(
            org_id=org_id,
            type=type,
            severity=severity,
            title=title,
            message=message,
            reference_type=reference_type,
            reference_id=reference_id,
            alert_metadata=metadata,
            expires_at=expires_at
        )
        
        db.session.add(alert)
        db.session.commit()
        return alert.serialize()
    
    def mark_read(self, alert_id: int, org_id: int, user_id: int) -> Optional[dict]:
        """Marcar alerta como leída"""
        alert = Alert.query.filter_by(id=alert_id, org_id=org_id).first()
        if not alert:
            return None
        
        alert.is_read = True
        alert.read_at = datetime.utcnow()
        alert.read_by = user_id
        
        db.session.commit()
        return alert.serialize()
    
    def mark_all_read(self, org_id: int, user_id: int, type: Optional[str] = None) -> int:
        """Marcar todas las alertas como leídas"""
        query = Alert.query.filter_by(org_id=org_id, is_read=False)
        
        if type:
            query = query.filter_by(type=type)
        
        count = query.update({
            'is_read': True,
            'read_at': datetime.utcnow(),
            'read_by': user_id
        })
        
        db.session.commit()
        return count
    
    def delete(self, alert_id: int, org_id: int) -> bool:
        """Eliminar alerta"""
        alert = Alert.query.filter_by(id=alert_id, org_id=org_id).first()
        if not alert:
            return False
        
        db.session.delete(alert)
        db.session.commit()
        return True
    
    def get_summary(self, org_id: int) -> dict:
        """Obtener resumen de alertas"""
        total = Alert.query.filter_by(org_id=org_id, is_read=False).count()
        
        by_severity = db.session.query(
            Alert.severity,
            db.func.count(Alert.id)
        ).filter_by(org_id=org_id, is_read=False).group_by(Alert.severity).all()
        
        by_type = db.session.query(
            Alert.type,
            db.func.count(Alert.id)
        ).filter_by(org_id=org_id, is_read=False).group_by(Alert.type).all()
        
        return {
            'total_unread': total,
            'by_severity': {severity: count for severity, count in by_severity},
            'by_type': {type: count for type, count in by_type}
        }
    
    # === Generadores automáticos de alertas ===
    
    def check_low_stock(self, org_id: int) -> List[dict]:
        """
        Verificar stock bajo y generar alertas
        Alerta crítica si stock <= punto de reorden
        """
        alerts_created = []
        
        # Productos con stock bajo - filtrar por org a través de product
        from app.models.product import Product
        low_stock_items = ProductWarehouse.query.join(Product).filter(
            Product.org_id == org_id,
            ProductWarehouse.current_stock <= Product.min_stock
        ).all()
        
        for item in low_stock_items:
            # Verificar si ya existe alerta no leída para este producto
            existing = Alert.query.filter_by(
                org_id=org_id,
                type='low_stock',
                reference_type='product',
                reference_id=item.product_id,
                is_read=False
            ).first()
            
            if not existing:
                alert = self.create(
                    org_id=org_id,
                    type='low_stock',
                    severity='critical' if item.current_stock <= 0 else 'warning',
                    title=f'Stock bajo: {item.product.name}',
                    message=f'El producto {item.product.code} tiene stock de {item.current_stock} en {item.warehouse.name}. Mínimo: {item.product.min_stock}',
                    reference_type='product',
                    reference_id=item.product_id,
                    metadata={
                        'product_code': item.product.code,
                        'warehouse_id': item.warehouse_id,
                        'current_stock': float(item.current_stock),
                        'min_stock': float(item.product.min_stock) if item.product.min_stock else 0.0
                    }
                )
                alerts_created.append(alert)
        
        return alerts_created
    
    def check_wo_delays(self, org_id: int) -> List[dict]:
        """
        Verificar Work Orders retrasadas
        Alerta si WO en progreso con planned_end vencida
        """
        alerts_created = []
        now = datetime.utcnow()
        
        delayed_wos = WorkOrder.query.filter(
            WorkOrder.org_id == org_id,
            WorkOrder.status == 'in_progress',
            WorkOrder.planned_end.isnot(None),
            WorkOrder.planned_end < now
        ).all()
        
        for wo in delayed_wos:
            existing = Alert.query.filter_by(
                org_id=org_id,
                type='wo_delay',
                reference_type='work_order',
                reference_id=wo.id,
                is_read=False
            ).first()
            
            if not existing:
                days_delayed = (now.date() - wo.planned_end.date()).days
                alert = self.create(
                    org_id=org_id,
                    type='wo_delay',
                    severity='critical' if days_delayed > 5 else 'warning',
                    title=f'Orden de trabajo retrasada: WO-{wo.id}',
                    message=f'La orden de trabajo #{wo.id} está retrasada {days_delayed} días. Fecha esperada: {wo.planned_end.isoformat()}',
                    reference_type='work_order',
                    reference_id=wo.id,
                    metadata={
                        'product_id': wo.product_id,
                        'days_delayed': days_delayed,
                        'planned_end': wo.planned_end.isoformat()
                    }
                )
                alerts_created.append(alert)
        
        return alerts_created
    
    def check_mrp_pending(self, org_id: int) -> List[dict]:
        """
        Verificar propuestas MRP pendientes de aprobación
        Alerta si hay propuestas con due_date próxima
        """
        alerts_created = []
        threshold = date.today() + timedelta(days=7)  # Próximos 7 días
        
        pending_proposals = MRPProposal.query.filter(
            MRPProposal.org_id == org_id,
            MRPProposal.status == 'proposed',
            MRPProposal.due_date <= threshold
        ).count()
        
        if pending_proposals > 0:
            # Una sola alerta para todas las propuestas pendientes
            existing = Alert.query.filter_by(
                org_id=org_id,
                type='mrp_pending',
                is_read=False
            ).first()
            
            if not existing:
                alert = self.create(
                    org_id=org_id,
                    type='mrp_pending',
                    severity='warning',
                    title=f'{pending_proposals} propuestas MRP pendientes',
                    message=f'Hay {pending_proposals} propuestas de MRP que requieren aprobación con vencimiento en los próximos 7 días.',
                    reference_type='mrp_proposal',
                    metadata={
                        'count': pending_proposals,
                        'threshold_days': 7
                    },
                    expires_at=datetime.utcnow() + timedelta(days=1)
                )
                alerts_created.append(alert)
        
        return alerts_created
    
    def check_all(self, org_id: int) -> Dict[str, int]:
        """
        Ejecutar todas las verificaciones de alertas
        Retorna resumen de alertas creadas por tipo
        """
        results = {
            'low_stock': len(self.check_low_stock(org_id)),
            'wo_delay': len(self.check_wo_delays(org_id)),
            'mrp_pending': len(self.check_mrp_pending(org_id))
        }
        
        results['total'] = sum(results.values())
        return results
