from flask import Blueprint, request, jsonify
from entities.subcategory_entity import SubcategoryEntity
from app.responses import Responses

subcategory_bp = Blueprint('subcategoria', __name__, url_prefix='/api/subcategorias')
subcategory_entity = SubcategoryEntity()

@subcategory_bp.route('/listado/todos', methods=['GET'])
def get_all():
    subcategories = subcategory_entity.get_all()
    return jsonify(Responses.success(subcategories))

@subcategory_bp.route('/buscar/subcategoria/<int:subcategoria_id>', methods=['GET'])
def get_by_subcategoria_id(subcategoria_id):
    subcategory = subcategory_entity.get_by_id(subcategoria_id)
    if subcategory:
        return jsonify(Responses.success(subcategory))
    else:
        return jsonify(Responses.error(f'Subcategoria no encontrada'))

@subcategory_bp.route('/buscar/<int:categoria_id>', methods=['GET'])
def get_by_id(categoria_id):
    subcategories = subcategory_entity.get_by_category_id(categoria_id)
    if subcategories:
        return jsonify(Responses.success(subcategories))
    else:
        return jsonify(Responses.error(f'Subcategorias para la categoria con ID {categoria_id} no encontrada'))
    
@subcategory_bp.route('/buscar/nombre/<string:name>')
def get_by_name(name):
    subcategory = subcategory_entity.get_by_name(name)
    if subcategory:
        return jsonify(Responses.success(subcategory))
    return jsonify(Responses.error(f'Subcategoría con NOMBRE {name} no encontrada'))

@subcategory_bp.route('/registrar', methods=['POST'])
def create_subcategoria():
    data = request.json
    name = data.get('nombre')
    description = data.get('descripcion')
    categoria_id = data.get('categoria_id')
    if name and categoria_id:
        new_subcategory = subcategory_entity.create(name, description, categoria_id)
        if new_subcategory:
            return jsonify(Responses.success(new_subcategory))
    else:
        return jsonify(Responses.error('El nombre y el ID de la categoría son obligatorios'), 400)

@subcategory_bp.route('/editar/<int:subcategoria_id>', methods=['POST'])
def update_subcategoria(subcategoria_id):
    data = request.json
    name = data.get('nombre')
    description = data.get('descripcion')
    categoria_id = data.get('categoria_id')

    if name and categoria_id:
        updated = subcategory_entity.update(subcategoria_id, name, description, categoria_id)
        if updated:
            return jsonify(Responses.success(updated))
        else:
            return jsonify(Responses.error(f'Subcategoría con ID {subcategoria_id} no encontrada'), 404)
    else:
        return jsonify(Responses.error('El nombre y el ID de la categoría son obligatorios'), 400)

@subcategory_bp.route('/eliminar/<int:subcategoria_id>', methods=['DELETE'])
def delete_subcategoria(subcategoria_id):
    deleted = subcategory_entity.delete(subcategoria_id)
    if deleted:
        return jsonify(Responses.success(f'Subcategoría con ID {subcategoria_id} eliminada correctamente'))
    else:
        return jsonify(Responses.error(f'Subcategoría con ID {subcategoria_id} no encontrada'), 404)

