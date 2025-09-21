from models.subresource import Subresource
from myapp import db

class SubresourceEntity:
    def get_all(self):
        subrecursos = Subresource.query.all()
        return [subrecurso.serialize() for subrecurso in subrecursos]

    def get_by_resource_id(self, resource_id):
        subrecursos = Subresource.query.filter_by(resource_id=resource_id).all()
        return [subrecurso.serialize() for subrecurso in subrecursos]

    def create(self,idrecurso_padre,nombre,descripcion,url):
        nuevo_recurso = Subresource(
            idrecurso_padre=idrecurso_padre,
            nombre=nombre,
            descripcion=descripcion,
            url=url
        )
        db.session.add(nuevo_recurso)
        db.session.commit()
        return nuevo_recurso.serialize()

    def update(self, rol_id, nombre):
        recurso = Subresource.query.get(rol_id)
        if recurso:
            recurso.nombre = nombre
            db.session.commit()

        return recurso.serialize() if recurso else None

    def delete(self, rol_id):
        recurso = Subresource.query.get(rol_id)
        if recurso:
            #db.session.delete(rol)
            recurso.estado=False
            db.session.commit()

        return recurso.serialize() if recurso else None
    
    def deletePer(self, rol_id):
        recurso = Subresource.query.get(rol_id)
        if recurso:
            db.session.delete(recurso)
            #recurso.estado=False
            db.session.commit()

        return recurso.serialize() if recurso else None
