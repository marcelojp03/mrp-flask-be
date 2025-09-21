# subcategoria_entity.py
from models.subcategory import Subcategory
from myapp import db

class SubcategoryEntity:
    def get_all(self):
        subcategorias = Subcategory.query.all()
        return [subcategoria.serialize() for subcategoria in subcategorias]

    def get_by_id(self, subcategoria_id):
        subcategoria = Subcategory.query.get(subcategoria_id)
        return subcategoria.serialize() if subcategoria else None

    def get_by_category_id(self, category_id):
        subcategorias = Subcategory.query.filter_by(category_id=category_id).all()
        return [subcategoria.serialize() for subcategoria in subcategorias] if subcategorias else None
    
    def get_by_name(self, name):
        subcategoria = Subcategory.query.filter_by(name=name).first()
        return subcategoria.serialize() if subcategoria else None


    def create(self,category_id, name, description, 
               created_by=None, updated_by=None, 
               subfolder=None, company_id_by=None, 
               code=None
               ):
        nueva_subcategoria = Subcategory(
            category_id=category_id,
            code=code,
            name=name,
            description=description,
            created_by=created_by,
            updated_by=updated_by,
            subfolder=subfolder,
            company_id_by=company_id_by
        )
        db.session.add(nueva_subcategoria)
        db.session.commit()
        return nueva_subcategoria.serialize()

    def update(self, subcategoria_id, nombre, descripcion, categoria_id):
        subcategoria = Subcategory.query.get(subcategoria_id)
        if subcategoria:
            subcategoria.nombre = nombre
            subcategoria.descripcion = descripcion
            subcategoria.categoria_id = categoria_id
            db.session.commit()
            return subcategoria.serialize()
        else:
            return None

    def delete(self, subcategoria_id):
        subcategoria = Subcategory.query.get(subcategoria_id)
        if subcategoria:
            #db.session.delete(subcategoria)
            subcategoria.estado=False
            db.session.commit()
            return subcategoria.serialize()
        else:
            return False


