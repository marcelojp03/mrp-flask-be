from dataclasses import dataclass
from typing import Optional, List


@dataclass
class BOMEntity:
    """BOM (Bill of Materials) Entity"""
    org_id: int
    product_id: int
    version: str
    is_active: bool = False
    description: Optional[str] = None
    id: Optional[int] = None
    components: Optional[List] = None
    created_at: Optional[str] = None
    updated_at: Optional[str] = None


@dataclass
class BOMComponentEntity:
    """BOM Component Entity"""
    bom_id: int
    component_id: int
    quantity: float
    scrap_percentage: float = 0.0
    unit_id: Optional[int] = None
    sequence: int = 0
    notes: Optional[str] = None
    id: Optional[int] = None
    created_at: Optional[str] = None
