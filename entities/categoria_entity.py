from myapp import db
from models.category import Category

class CategoryEntity:
    def get_all(self):
        categorias = Category.query.all()
        return [categoria.serialize() for categoria in categorias]

    def get_by_id(self, categoria_id):
        categoria = Category.query.get(categoria_id)
        return categoria.serialize() if categoria else None
    
    def get_by_name(self, name):
        categoria = Category.query.filter_by(name=name).first()
        return categoria.serialize() if categoria else None

    def create(self, name,
               created_by=None, updated_by=None, 
                folder=None, company_id_by=None, 
                code=None, description=None
               ):
        # Crear la nueva instancia de Categoria, incluyendo el 'id' solo si se proporciona
        nueva_categoria = Category(
            code=code,
            name=name,
            description=description,
            created_by=created_by,
            updated_by=updated_by,
            # status=status,
            folder=folder,
            company_id_by=company_id_by
        )
        
        # Añadir la nueva categoría a la sesión
        db.session.add(nueva_categoria)
        db.session.commit()  # Confirmar la transacción en la BD
        return nueva_categoria.serialize()

    def update(self, categoria_id, name, description):
        categoria = Category.query.get(categoria_id)
        if categoria:
            categoria.name = name
            categoria.description = description
            db.session.commit()
            return categoria.serialize()
        return None

    def delete(self, categoria_id):
        categoria = Category.query.get(categoria_id)
        if categoria:
            categoria.status = 0  # Cambiar a un estado que represente eliminado
            db.session.commit()
            return categoria.serialize()
        return None
