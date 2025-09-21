# entities/resource_entity.py
from models.resource import Resource
from myapp import db

class ResourceEntity:
    def get_all(self):
        recursos = Resource.query.all()
        return [recurso.serialize() for recurso in recursos]

    def get_by_id(self, id):
        recurso = Resource.query.get(id)
        return recurso.serialize() if recurso else None

    def create(self,idrecurso_padre,nombre,descripcion,url):
        nuevo_recurso = Resource(
            idrecurso_padre=idrecurso_padre,
            nombre=nombre,
            descripcion=descripcion,
            url=url
        )
        db.session.add(nuevo_recurso)
        db.session.commit()
        return nuevo_recurso.serialize()

    def update(self, rol_id, nombre):
        recurso = Resource.query.get(rol_id)
        if recurso:
            recurso.nombre = nombre
            db.session.commit()

        return recurso.serialize() if recurso else None

    def delete(self, rol_id):
        recurso = Resource.query.get(rol_id)
        if recurso:
            #db.session.delete(rol)
            recurso.estado=False
            db.session.commit()

        return recurso.serialize() if recurso else None
    
    def deletePer(self, rol_id):
        recurso = Resource.query.get(rol_id)
        if recurso:
            db.session.delete(recurso)
            #recurso.estado=False
            db.session.commit()

        return recurso.serialize() if recurso else None
