# entities/role_resource_entity.py
from models.role_resource import RoleResource
from myapp import db
class RoleResourceEntity:
    def get_all(self):
        Rol_Recursos = RoleResource.query.all()
        return [Rol_Recurso.serialize() for Rol_Recurso in Rol_Recursos]

    def get_by_id(self,Rol_Recurso_id):
        Rol_Recurso = Rol_Recurso.query.get(Rol_Recurso_id)
        print("Rol_Recurso buscar entity")
        print(Rol_Recurso)
        return Rol_Recurso.serialize() if Rol_Recurso else None
    
    def get_by_name(self,nombre):
        Rol_Recurso = Rol_Recurso.query.filter_by(nombre=nombre).first()
        print("Rol_Recurso buscar entity")
        print(Rol_Recurso)
        return Rol_Recurso.serialize() if Rol_Recurso else None

    def create(self, rol_id, recurso_id):
        nuevo_Rol_Recurso = RoleResource(
            rol_id=rol_id,
            recurso_id=recurso_id
        )
        db.session.add(nuevo_Rol_Recurso)
        db.session.commit()
        return nuevo_Rol_Recurso.serialize()

