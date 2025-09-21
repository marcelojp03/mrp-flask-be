# entities/producto_entity.py
from models.product import Product
from myapp import db

from entities.producto_almacen_entity import ProductWarehouseEntity

product_warehouse_entity = ProductWarehouseEntity()


class ProductEntity:
    def get_all(self, use_s1=False):
        """Get all products. use_s1=True for S1 optimized response"""
        products = Product.query.all()
        if use_s1:
            return [p.serialize_for_s1() for p in products]
        return [p.serialize() for p in products]

    def get_by_id(self, id, use_s1=False):
        """Get product by ID. use_s1=True for S1 optimized response"""
        p = Product.query.get(id)
        if not p:
            return None
        return p.serialize_for_s1() if use_s1 else p.serialize()

    def get_by_name(self, name, use_s1=False):
        """Get product by name. use_s1=True for S1 optimized response"""
        p = Product.query.filter_by(name=name).first()
        if not p:
            return None
        return p.serialize_for_s1() if use_s1 else p.serialize()

    def get_by_org(self, org_id, use_s1=True):
        """Get products by organization. Default to S1 for better performance"""
        products = Product.query.filter_by(org_id=org_id, status=1).all()
        if use_s1:
            return [p.serialize_for_s1() for p in products]
        return [p.serialize() for p in products]

    def get_active(self, org_id=1):
        """Get active products with stock info for organization"""
        products = Product.query.filter_by(status=1, org_id=org_id).all()
        if not products:
            return None
        result = []
        for prod in products:
            stock = product_warehouse_entity.get_stock(prod.id)
            serialized = prod.serialize_for_s1()  # Use S1 for performance
            serialized['current_stock'] = stock
            result.append(serialized)
        return result

    def get_stockable(self, org_id=1):
        """Get only stockable products (for inventory management)"""
        stockable_types = ['RM', 'WIP', 'FG', 'CONSUMABLE']
        products = Product.query.filter(
            Product.org_id == org_id,
            Product.status == 1,
            Product.item_type.in_(stockable_types)
        ).all()
        return [p.serialize_for_s1() for p in products]

    def get_low_stock(self, org_id=1):
        """Get products with low stock (MRP-ready)"""
        from models.product_warehouse import ProductWarehouse
        from sqlalchemy import and_
        
        low_stock = (Product.query
                     .join(ProductWarehouse)
                     .filter(and_(
                         Product.org_id == org_id,
                         Product.status == 1,
                         ProductWarehouse.current_stock < Product.min_stock,
                         Product.min_stock > 0
                     ))
                     .all())
        
        return [p.serialize_for_s1() for p in low_stock]

    def create(self, org_id=1, code=None, name=None, description=None, 
               item_type='FG', procurement_type='BUY', min_stock=0,
               unit_id=None, category_id=None, subcategory_id=None,
               # Legacy parameters for backward compatibility
               categoryid=None, subcategoryid=None, unitid=None, 
               drawerid=None, price1=None, price2=None,
               assigneddivisions=None, containertype=None, previouscost=None,
               currentcost=None, previouscostdate=None, currentcostdate=None, 
               status=1, hasimage=0, company_id_by=None, created_by=None, 
               updated_by=None):
        """
        Create new product with MRP-ready validation
        S1 focused: validates essential fields, category/subcategory optional
        """
        
        # Use new parameters if provided, fall back to legacy for compatibility
        final_category_id = category_id or categoryid
        final_subcategory_id = subcategory_id or subcategoryid
        final_unit_id = unit_id or unitid
        
        # Validate required fields
        if not code or not name:
            raise ValueError("Code and name are required")
        
        # Create temporary instance for validation
        temp_product = Product(item_type=item_type)
        
        # Validate unit_id requirement based on item_type
        if temp_product.requires_unit() and not final_unit_id:
            raise ValueError(f"unit_id is required for item_type '{item_type}' (stockable items)")
        
        # Optional: clean unit_id for non-stockable items
        if not temp_product.is_stockable():
            final_unit_id = None

        new_product = Product(
            org_id=org_id,
            code=code,
            name=name,
            description=description,
            item_type=item_type,
            procurement_type=procurement_type,
            min_stock=min_stock,
            category_id=final_category_id,  # Optional in S1
            subcategory_id=final_subcategory_id,  # Optional in S1
            unit_id=final_unit_id,
            # Legacy fields for backward compatibility
            drawer_id=drawerid,
            price1=price1,
            price2=price2,
            assigned_divisions=assigneddivisions,
            container_type=containertype,
            previous_cost=previouscost,
            current_cost=currentcost,
            previous_cost_date=previouscostdate,
            current_cost_date=currentcostdate,
            status=status,
            has_image=hasimage,
            company_id_by=company_id_by,
            created_by=created_by,
            updated_by=updated_by
        )
        db.session.add(new_product)
        db.session.commit()
        return new_product.serialize_for_s1()  # Return S1 optimized version

    def update(self, product_id, name=None, description=None, price=None, 
               category_id=None, subcategory_id=None, min_stock=None,
               item_type=None, procurement_type=None, unit_id=None,
               use_s1=True):
        """Update product with MRP fields support"""
        p = Product.query.get(product_id)
        if not p:
            return None
            
        # Update provided fields
        if name is not None:
            p.name = name
        if description is not None:
            p.description = description
        if price is not None:
            p.price1 = price
        if category_id is not None:
            p.category_id = category_id
        if subcategory_id is not None:
            p.subcategory_id = subcategory_id
        if min_stock is not None:
            p.min_stock = min_stock
        if item_type is not None:
            p.item_type = item_type
        if procurement_type is not None:
            p.procurement_type = procurement_type
        if unit_id is not None:
            p.unit_id = unit_id
            
        # Validate unit_id requirement if item_type changed
        if item_type and p.requires_unit() and not p.unit_id:
            raise ValueError(f"unit_id is required for item_type '{item_type}'")
            
        db.session.commit()
        return p.serialize_for_s1() if use_s1 else p.serialize()

    def delete(self, product_id, use_s1=True):
        """Soft delete product"""
        p = Product.query.get(product_id)
        if p:
            p.status = 0
            db.session.commit()
        return p.serialize_for_s1() if (p and use_s1) else (p.serialize() if p else None)

    def delete_permanent(self, product_id):
        """Permanent delete - use with caution"""
        p = Product.query.get(product_id)
        if p:
            db.session.delete(p)
            db.session.commit()
            return True
        return False

    def reactivate(self, product_id, use_s1=True):
        """Reactivate soft-deleted product"""
        p = Product.query.get(product_id)
        if p:
            p.status = 1
            db.session.commit()
        return p.serialize_for_s1() if (p and use_s1) else (p.serialize() if p else None)