from dataclasses import dataclass
from typing import Optional
from datetime import datetime


@dataclass
class WorkOrderEntity:
    """Work Order (Orden de Producción) Entity"""
    org_id: int
    product_id: int
    bom_id: int
    quantity: float
    status: str = 'Planificada'
    warehouse_id: Optional[int] = None
    assigned_to: Optional[int] = None
    reference: Optional[str] = None
    notes: Optional[str] = None
    planned_start: Optional[datetime] = None
    planned_end: Optional[datetime] = None
    actual_start: Optional[datetime] = None
    actual_end: Optional[datetime] = None
    created_by: Optional[int] = None
    id: Optional[int] = None
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None
