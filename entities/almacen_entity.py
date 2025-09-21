# entities/almacen_entity.py
from models.warehouse import Warehouse
from myapp import db

class WarehouseEntity:
    def get_all(self):
        almacenes = Warehouse.query.all()
        return [almacen.serialize() for almacen in almacenes]

    def get_by_id(self, almacen_id):
        almacen = Warehouse.query.get(almacen_id)
        return almacen.serialize() if almacen else None

    def create(self, name, location):
        nuevo_almacen = Warehouse(
            name = name,
            location = location
        )
        db.session.add(nuevo_almacen)
        db.session.commit()
        return nuevo_almacen.serialize()

    def update(self, id, name, location):
        almacen = Warehouse.query.get(id)
        if almacen:
            almacen.name = name
            almacen.location = location
            db.session.commit()
        return almacen.serialize() if almacen else None

    def delete(self, almacen_id):
        almacen = Warehouse.query.get(almacen_id)
        if almacen:
            # Aquí podrías implementar la lógica para eliminar lógicamente si es necesario
            #db.session.delete(almacen)
            almacen.status = 0
            db.session.commit()
        return almacen.serialize() if almacen else None
    