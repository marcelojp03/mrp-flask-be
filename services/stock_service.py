# services/stock_service.py
from typing import Optional, List, Dict
from decimal import Decimal
from myapp import db
from models.product_warehouse import ProductWarehouse
from models.product import Product
from models.supplier_item import SupplierItem

def _to_float(x):
    return float(x) if x is not None else 0.0

class StockService:
    def stock_by_product(self, product_id: int) -> float:
        rows = ProductWarehouse.query.filter_by(product_id=product_id).all()
        total = Decimal('0')
        for r in rows:
            total += r.current_stock or Decimal('0')
        return float(total)

    def stock_by_product_warehouse(self, product_id: int, warehouse_id: int) -> float:
        row = ProductWarehouse.query.filter_by(product_id=product_id, warehouse_id=warehouse_id).first()
        return _to_float(row.current_stock) if row else 0.0

    def low_stock(self, org_id: int = 1) -> List[dict]:
        # productos con stock total < min_stock
        prods = Product.query.filter_by(org_id=org_id, status=True).all()
        out = []
        for p in prods:
            if not p.min_stock or p.min_stock == 0: 
                continue
            total = self.stock_by_product(p.id)
            if total < float(p.min_stock):
                item = p.serialize()
                item['current_stock'] = total
                out.append(item)
        return out

    def reorder_suggestions(self, org_id: int = 1) -> List[Dict]:
        # sugerir reponer max(min_stock - stock_actual, 0)
        prods = Product.query.filter_by(org_id=org_id, status=True).all()
        out = []
        for p in prods:
            ms = float(p.min_stock or 0)
            if ms <= 0: 
                continue
            total = self.stock_by_product(p.id)
            shortage = max(ms - total, 0)
            if shortage <= 0:
                continue

            suggestion = {
                'product_id': p.id,
                'code': p.code,
                'name': p.name,
                'current_stock': total,
                'min_stock': float(p.min_stock),
                'suggested_qty': round(shortage, 2),
                'hint': None,
                'lead_time_days': None,
                'supplier_id': None
            }

            # si hay supplier preferido, agrega LT y moq
            si = SupplierItem.query.filter_by(org_id=org_id, product_id=p.id, is_active=True)\
                                   .order_by(SupplierItem.is_preferred.desc()).first()
            if si:
                suggestion['supplier_id'] = si.supplier_id
                suggestion['lead_time_days'] = si.lead_time_days
                if si.min_order_qty:
                    # redondea a múltiplo del MOQ si conviene
                    moq = float(si.min_order_qty)
                    suggestion['suggested_qty'] = max(moq, suggestion['suggested_qty'])
                if si.lead_time_days is not None:
                    suggestion['hint'] = f"Comprar con ~{si.lead_time_days} días de anticipación"
            out.append(suggestion)
        return out
