# services/mrp_service.py
from typing import List, Optional, Dict
from datetime import date, datetime, timedelta
from app.db import db
from app.models.mrp_proposal import MRPProposal
from app.models.mps_plan import MPSPlan
from app.models.bom import BOM, BOMComponent
from app.models.product import Product
from app.models.supplier_item import SupplierItem
from app.services.stock_service import StockService

class MRPService:
    """Servicio para Material Requirements Planning - Sprint 4"""
    
    def __init__(self):
        self.stock_service = StockService()
    
    def list_proposals(self, org_id: int, product_id: Optional[int] = None,
                      type: Optional[str] = None, status: Optional[str] = None,
                      due_date_start: Optional[date] = None, due_date_end: Optional[date] = None) -> List[dict]:
        """Listar propuestas MRP con filtros"""
        query = MRPProposal.query.filter_by(org_id=org_id)
        
        if product_id:
            query = query.filter_by(product_id=product_id)
        
        if type:
            query = query.filter_by(type=type)
        
        if status:
            query = query.filter_by(status=status)
        
        if due_date_start:
            query = query.filter(MRPProposal.due_date >= due_date_start)
        
        if due_date_end:
            query = query.filter(MRPProposal.due_date <= due_date_end)
        
        proposals = query.order_by(MRPProposal.due_date.asc(), MRPProposal.product_id.asc()).all()
        return [p.serialize() for p in proposals]
    
    def get_proposal(self, proposal_id: int, org_id: int) -> Optional[dict]:
        """Obtener propuesta por ID"""
        proposal = MRPProposal.query.filter_by(id=proposal_id, org_id=org_id).first()
        return proposal.serialize() if proposal else None
    
    def run(self, org_id: int, period_start: date, period_end: date, 
            created_by: Optional[int] = None) -> Dict:
        """
        Ejecutar MRP reducido
        
        Lógica:
        1. Obtener planes MPS publicados en el rango de fechas
        2. Para cada producto del MPS, explotar su BOM
        3. Calcular necesidades netas: demanda_bruta - stock_disponible
        4. Generar propuestas BUY o MAKE según tipo de producto
        """
        
        # 1. Obtener planes MPS publicados
        mps_plans = MPSPlan.query.filter_by(org_id=org_id, status='published')\
            .filter(MPSPlan.period >= period_start, MPSPlan.period <= period_end)\
            .all()
        
        if not mps_plans:
            return {
                'message': 'No hay planes MPS publicados en el periodo',
                'proposals_created': 0,
                'proposals': []
            }
        
        proposals_created = []
        
        for mps_plan in mps_plans:
            # 2. Obtener BOM activa del producto
            bom = BOM.query.filter_by(
                org_id=org_id,
                product_id=mps_plan.product_id,
                is_active=True
            ).first()
            
            if not bom:
                # Si no hay BOM, crear propuesta MAKE directa
                proposal = self._create_proposal(
                    org_id=org_id,
                    product_id=mps_plan.product_id,
                    type='MAKE',
                    quantity=float(mps_plan.planned_qty),
                    due_date=mps_plan.period,
                    mps_plan_id=mps_plan.id,
                    reason=f'Plan MPS del periodo {mps_plan.period}',
                    created_by=created_by
                )
                proposals_created.append(proposal)
                continue
            
            # 3. Explotar BOM - calcular necesidades de componentes
            components = BOMComponent.query.filter_by(bom_id=bom.id).all()
            
            for component in components:
                # Calcular cantidad necesaria (con scrap)
                base_qty = float(component.quantity) * float(mps_plan.planned_qty)
                scrap_factor = 1 + (float(component.scrap_percentage or 0) / 100)
                required_qty = base_qty * scrap_factor
                
                # Obtener stock actual
                current_stock = self.stock_service.stock_by_product(component.component_id)
                
                # Calcular necesidad neta
                net_requirement = required_qty - current_stock
                
                if net_requirement > 0:
                    # Decidir si BUY o MAKE
                    component_product = Product.query.get(component.component_id)
                    
                    # Verificar si tiene proveedor (BUY) o BOM (MAKE)
                    has_supplier = SupplierItem.query.filter_by(
                        product_id=component.component_id,
                        org_id=org_id
                    ).first() is not None
                    
                    has_bom = BOM.query.filter_by(
                        product_id=component.component_id,
                        org_id=org_id,
                        is_active=True
                    ).first() is not None
                    
                    # Lógica de decisión
                    proposal_type = 'BUY' if has_supplier else ('MAKE' if has_bom else 'BUY')
                    
                    # Calcular lead time (días antes de la fecha necesaria)
                    lead_time_days = 7  # Default
                    supplier_item = None
                    
                    if proposal_type == 'BUY':
                        supplier_item = SupplierItem.query.filter_by(
                            product_id=component.component_id,
                            org_id=org_id
                        ).first()
                        
                        if supplier_item and supplier_item.lead_time_days:
                            lead_time_days = supplier_item.lead_time_days
                    
                    due_date = mps_plan.period - timedelta(days=lead_time_days)
                    
                    # Crear propuesta
                    proposal = self._create_proposal(
                        org_id=org_id,
                        product_id=component.component_id,
                        type=proposal_type,
                        quantity=net_requirement,
                        due_date=due_date,
                        mps_plan_id=mps_plan.id,
                        source_period=mps_plan.period,
                        reason=f'Componente para {bom.product.name} - MPS {mps_plan.period}',
                        supplier_id=supplier_item.supplier_id if supplier_item else None,
                        estimated_cost=float(supplier_item.unit_price * net_requirement) if supplier_item and supplier_item.unit_price else None,
                        created_by=created_by
                    )
                    proposals_created.append(proposal)
        
        return {
            'message': f'{len(proposals_created)} propuestas MRP generadas',
            'proposals_created': len(proposals_created),
            'proposals': [p.serialize() for p in proposals_created]
        }
    
    def _create_proposal(self, org_id: int, product_id: int, type: str, quantity: float,
                        due_date: date, mps_plan_id: Optional[int] = None,
                        source_period: Optional[date] = None, reason: Optional[str] = None,
                        supplier_id: Optional[int] = None, estimated_cost: Optional[float] = None,
                        warehouse_id: Optional[int] = None, created_by: Optional[int] = None) -> MRPProposal:
        """Crear propuesta MRP"""
        proposal = MRPProposal(
            org_id=org_id,
            product_id=product_id,
            type=type,
            quantity=quantity,
            due_date=due_date,
            mps_plan_id=mps_plan_id,
            source_period=source_period,
            status='proposed',
            reason=reason,
            supplier_id=supplier_id,
            estimated_cost=estimated_cost,
            warehouse_id=warehouse_id,
            created_by=created_by
        )
        
        db.session.add(proposal)
        db.session.commit()
        return proposal
    
    def approve_proposal(self, proposal_id: int, org_id: int, approved_by: int) -> Optional[dict]:
        """Aprobar propuesta MRP"""
        proposal = MRPProposal.query.filter_by(id=proposal_id, org_id=org_id).first()
        if not proposal:
            return None
        
        if proposal.status != 'proposed':
            raise ValueError(f"Solo se pueden aprobar propuestas en estado 'proposed'. Estado actual: {proposal.status}")
        
        proposal.status = 'approved'
        proposal.approved_at = datetime.utcnow()
        proposal.approved_by = approved_by
        
        db.session.commit()
        return proposal.serialize()
    
    def reject_proposal(self, proposal_id: int, org_id: int, reason: Optional[str] = None) -> Optional[dict]:
        """Rechazar propuesta MRP"""
        proposal = MRPProposal.query.filter_by(id=proposal_id, org_id=org_id).first()
        if not proposal:
            return None
        
        if proposal.status != 'proposed':
            raise ValueError(f"Solo se pueden rechazar propuestas en estado 'proposed'. Estado actual: {proposal.status}")
        
        proposal.status = 'rejected'
        if reason:
            proposal.reason = f"{proposal.reason}\nMotivo rechazo: {reason}" if proposal.reason else f"Motivo rechazo: {reason}"
        
        db.session.commit()
        return proposal.serialize()
    
    def execute_proposal(self, proposal_id: int, org_id: int, 
                        reference_type: str, reference_id: int) -> Optional[dict]:
        """
        Marcar propuesta como ejecutada
        reference_type: 'WO' para Work Order o 'PO' para Purchase Order
        """
        proposal = MRPProposal.query.filter_by(id=proposal_id, org_id=org_id).first()
        if not proposal:
            return None
        
        if proposal.status != 'approved':
            raise ValueError("Solo se pueden ejecutar propuestas aprobadas")
        
        proposal.status = 'executed'
        proposal.executed_reference_type = reference_type
        proposal.executed_reference_id = reference_id
        
        db.session.commit()
        return proposal.serialize()
