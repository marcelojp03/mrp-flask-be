from myapp import db
from models.purchase import Purchase
from models.purchase_detail import PurchaseDetail

class PurchaseEntity:
    def get_all(self):
        purchases = Purchase.query.all()
        return [purchase.serialize() for purchase in purchases]

    def get_by_id(self, purchase_id):
        purchase = Purchase.query.get(purchase_id)
        return purchase.serialize() if purchase else None
    
    def get_all_with_details(self):
        purchases = Purchase.query.all()
        purchases_with_details = []
        for purchase in purchases:
            details = PurchaseDetail.query.filter_by(purchase_id=purchase.id).all()
            details_serialized = [detail.serialize() for detail in details]
            purchase_serialized = purchase.serialize()
            purchase_serialized['details'] = details_serialized
            purchases_with_details.append(purchase_serialized)
        return purchases_with_details
    
    def get_one_with_detail(self, purchase_id):
        purchase = Purchase.query.get(purchase_id)
        if not purchase:
            return None
        details = PurchaseDetail.query.filter_by(purchase_id=purchase_id).all()
        details_serialized = [detail.serialize() for detail in details]
        purchase_serialized = purchase.serialize()
        purchase_serialized['details'] = details_serialized
        return purchase_serialized
    
    def exist_by_order_number(self, order_number):
        existing = Purchase.query.filter_by(order_number=order_number).first()
        return existing if existing else None

    def create(self, order_number, date, user_id, supplier_id, warehouse_id, total):
        new_purchase = Purchase(
            order_number=order_number, 
            date=date, 
            user_id=user_id, 
            supplier_id=supplier_id, 
            warehouse_id=warehouse_id, 
            total=total
        )
        db.session.add(new_purchase)
        return new_purchase

    def update(self, purchase_id, date, user_id, supplier_id, warehouse_id, total, status):
        purchase = Purchase.query.get(purchase_id)
        if purchase:
            purchase.date = date
            purchase.user_id = user_id
            purchase.supplier_id = supplier_id
            purchase.warehouse_id = warehouse_id
            purchase.total = total
            purchase.status = status
            db.session.commit()
            return purchase.serialize()
        return None

    def delete(self, purchase_id):
        purchase = Purchase.query.get(purchase_id)
        if purchase:
            db.session.delete(purchase)
            db.session.commit()
            return purchase.serialize()
        return None

    def cancel_purchase(self, purchase_id):
        purchase = Purchase.query.get(purchase_id)
        if purchase:
            purchase.status = 'cancelled'
            db.session.commit()
            return True
        return False
