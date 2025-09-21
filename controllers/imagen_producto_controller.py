import os
import base64
from myapp import db
from flask import Blueprint, current_app, request, jsonify, url_for
from entities.imagen_producto_entity import ProductImageEntity
from entities.producto_entity import ProductEntity
from app.responses import Responses

product_image_bp = Blueprint('product_image', __name__, url_prefix='/api/product_image')
product_image_entity = ProductImageEntity()
product_entity = ProductEntity()

@product_image_bp.route('/guardar', methods=['POST'])
def guardar_imagen_producto():
    #Obtener datos de la solicitud
    producto_id = request.json.get('producto_id')
    print("producto id ",producto_id)

    prod_nombre=request.json.get('nombre_producto')
    print("nombre_producto " ,prod_nombre)
    #imagenes = request.files.getlist('imagenes')
    imagenesbase64 = request.json.get('imagenes')
    print("imagenes ",imagenesbase64)
    # Validar datos
    if not producto_id:
        return jsonify(Responses.error('ID de producto no proporcionado')), 400
    if not imagenesbase64:
        # If no images provided, remove existing images and return error
        product_image_entity.eliminar_imagenes_producto(producto_id)
        return jsonify(Responses.error('No se ha seleccionado ninguna imagen')), 400

    #Guardar las imágenes en el servidor y actualizar/crear registros en la base de datos
    #product_image_entity.guardar_imagenes(producto_id, imagenes)

    # Eliminar las imagenes ya guardadas
    product_image_entity.eliminar_imagenes_producto(producto_id)

    # Preparar la respuesta
    imagenes_data = []
    for imagen in imagenesbase64:
        # imagen_url = url_for('static', filename=os.path.join(current_app.config['IMAGENES_CARPETA'], imagen.filename))
        # imagenes_data.append({'nombre_archivo': imagen.filename, 'url': imagen_url})
        # db.session.commit()
        nombre_archivo = product_image_entity.guardar_imagen_local(imagen, producto_id)
        # Build static URL using POSIX style path for filename
        filename = os.path.join(current_app.config['IMAGENES_PRODUCTOS_CARPETA'], nombre_archivo)
        imagen_url = url_for('static', filename=filename)
        imagenes_data.append({'producto_id': producto_id, 'nombre_archivo': nombre_archivo, 'url': imagen_url})
        product_image_entity.guardar_registro_bd(producto_id, nombre_archivo)

    # Commit once after processing all images
    db.session.commit()
    return jsonify(Responses.success({ 'producto_id':producto_id ,'imagenes': imagenes_data}))
    #return jsonify(Responses.success({'mensaje': 'Imágenes guardadas correctamente'}))


@product_image_bp.route('/eliminar/<int:producto_id>', methods=['DELETE'])
def eliminar_imagenes_producto(producto_id):
    # Eliminar imágenes asociadas al producto
    product_image_entity.eliminar_imagenes_producto(producto_id)

    return jsonify(Responses.success({'mensaje': 'Imágenes eliminadas correctamente'}))

@product_image_bp.route('/obtener/<int:producto_id>', methods=['GET'])
def obtener_imagenes_producto(producto_id):
    # Obtener imágenes asociadas al producto
    imagenes = product_image_entity.get_all_by_producto_id(producto_id)
    if not imagenes:
        return jsonify(Responses.error("El producto no tiene imágenes para mostrar")), 404
    # Preparar la respuesta
    imagenes_data = []
    for imagen in imagenes:
        # Leer el archivo de imagen en formato binario
        imagen_path = os.path.join(current_app.config['IMAGENES_PRODUCTOS_CARPETA'], imagen.get('nombre'))
        with open(imagen_path, 'rb') as img_file:
            image_data = base64.b64encode(img_file.read()).decode('utf-8')
            #print("image_data ",str(image_data))

        imagenes_data.append({'id': imagen.get('id'), 'nombre': imagen.get('nombre'), 'data': image_data})

    return jsonify(Responses.success({'imagenes': imagenes_data})), 200