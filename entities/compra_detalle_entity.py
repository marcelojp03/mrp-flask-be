from models.purchase_detail import PurchaseDetail
from myapp import db

class PurchaseDetailEntity:
    def get_all(self):
        purchase_details = PurchaseDetail.query.all()
        return [detail.serialize() for detail in purchase_details]

    def get_by_id(self, detail_id):
        detail = PurchaseDetail.query.get(detail_id)
        return detail.serialize() if detail else None

    def create(self, purchase_id, product_id, quantity, price, total):
        new_detail = PurchaseDetail(
            purchase_id=purchase_id,
            product_id=product_id,
            quantity=quantity,
            price=price, 
            total=total
        )
        db.session.add(new_detail)
        return new_detail

    def update(self, detail_id, product_id, quantity, price, total):
        detail = PurchaseDetail.query.get(detail_id)
        if detail:
            detail.product_id = product_id
            detail.quantity = quantity
            detail.price = price
            detail.total = total
            db.session.commit()
            return detail.serialize()
        return None

    def delete(self, detail_id):
        detail = PurchaseDetail.query.get(detail_id)
        if detail:
            db.session.delete(detail)
            db.session.commit()
            return detail.serialize()
        return None
