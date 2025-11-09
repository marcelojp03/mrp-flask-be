# models/__init__.py
"""
Módulo de modelos SQLAlchemy (ORM)
"""

# Sprint 1 - Core MRP
from .organization import Organization
from .user import User
from .role import Role
from .user_role import UserRole
from .resource import Resource
from .subresource import Subresource
from .role_resource import RoleResource
from .unit import Unit
from .product import Product
from .warehouse import Warehouse
from .product_warehouse import ProductWarehouse
from .movement import Movement
from .supplier import Supplier
from .supplier_item import SupplierItem
# from .category import Category  # Categoria está en entities
from .drawer import Drawer
from .purchase import Purchase
from .purchase_detail import PurchaseDetail

# Sprint 2 - SaaS Features
from .plan import Plan
from .org_subscription import OrgSubscription
from .user_organization import UserOrganization
from .system_log import SystemLog
from .report_audit import ReportAudit

# Sprint 3 - Production
from .bom import BOM
from .work_order import WorkOrder

__all__ = [
    # Core
    'Organization',
    'User',
    'Role',
    'UserRole',
    'Resource',
    'Subresource',
    'RoleResource',
    
    # Inventory
    'Unit',
    'Product',
    'Warehouse',
    'ProductWarehouse',
    'Movement',
    'Supplier',
    'SupplierItem',
    # 'Category',  # Categoria está en entities
    'Drawer',
    'Purchase',
    'PurchaseDetail',
    
    # SaaS
    'Plan',
    'OrgSubscription',
    'UserOrganization',
    'SystemLog',
    'ReportAudit',
    
    # Production (Sprint 3)
    'BOM',
    'WorkOrder',
]
