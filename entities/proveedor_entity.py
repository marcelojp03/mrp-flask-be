# entities/proveedor_entity.py
from models.supplier import Supplier
from myapp import db

class SupplierEntity:
    def get_all(self):
        suppliers = Supplier.query.all()
        return [supplier.serialize() for supplier in suppliers]

    def get_by_id(self, supplier_id):
        supplier = Supplier.query.get(supplier_id)
        return supplier.serialize() if supplier else None

    def create(self, name, address, city, email, phone=None, mobile=None,
               company_name=None, company_id=None, created_by=None, updated_by=None):
        new_supplier = Supplier(
            name=name,
            phone=phone,
            mobile=mobile,
            address=address,
            city=city,
            email=email,
            company_id=company_id,
            company_name=company_name,
            created_by=created_by,
            updated_by=updated_by,
        )
        db.session.add(new_supplier)
        db.session.commit()
        return new_supplier.serialize()

    def update(self, supplier_id, name, address, phone, contact):
        supplier = Supplier.query.get(supplier_id)
        if supplier:
            supplier.name = name
            supplier.address = address
            supplier.phone = phone
            supplier.contact = contact
            db.session.commit()
        return supplier.serialize() if supplier else None

    def delete(self, supplier_id):
        supplier = Supplier.query.get(supplier_id)
        if supplier:
            supplier.status = 0
            db.session.commit()
        return supplier.serialize() if supplier else None

    def reactivate(self, supplier_id):
        supplier = Supplier.query.get(supplier_id)
        if supplier:
            supplier.status = 1
            db.session.commit()
        return supplier.serialize() if supplier else None
    