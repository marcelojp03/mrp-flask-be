from myapp import db
from models.product_image import ProductImage
import os
import datetime
import hashlib
import base64
from flask import current_app
from PIL import Image
from io import BytesIO


class ProductImageEntity:
    def get_all_by_product_id(self, product_id):
        images = ProductImage.query.filter_by(product_id=product_id).all()
        return [img.serialize() for img in images]

    # Spanish-named wrapper used by controllers
    def get_all_by_producto_id(self, product_id):
        return self.get_all_by_product_id(product_id)

    def save_image_from_base64(self, img_base64, product_id):
        starter = img_base64.find(',')
        img_data = img_base64[starter+1:]
        img_data = bytes(img_data, encoding='ascii')
        im = Image.open(BytesIO(base64.b64decode(img_data))).convert('RGB')

        hash_object = hashlib.sha256(img_base64.encode())
        hash_value = hash_object.hexdigest()[:8]
        filename = f"prod{product_id}-{hash_value}.png"

        path = os.path.join(current_app.config.get('IMAGENES_PRODUCTOS_CARPETA', '.'), filename)
        try:
            im.save(path)
            return filename
        except Exception:
            return None

    def save_record_db(self, product_id, filename):
        try:
            img = ProductImage(name=filename, product_id=product_id)
            db.session.add(img)
        except Exception:
            # Let caller handle commit/rollback
            return None

    # Spanish-named wrapper
    def guardar_registro_bd(self, product_id, filename):
        return self.save_record_db(product_id, filename)

    def guardar_imagen_local(self, img_base64, product_id):
        return self.save_image_from_base64(img_base64, product_id)

    def generate_filename(self, product_id, uploaded_file):
        extension = os.path.splitext(uploaded_file.filename)[1]
        timestamp = datetime.datetime.now().strftime('%Y%m%d%H%M%S')
        hash_value = hashlib.sha256(uploaded_file.read()).hexdigest()[:8]
        return f"prod{product_id}_{timestamp}_{hash_value}{extension}"

    def save_images(self, product_id, files):
        if not files:
            return

        self.delete_product_images(product_id)

        for f in files:
            name = f.filename
            try:
                f.save(os.path.join(current_app.config.get('IMAGENES_CARPETA', '.'), name))
                img_record = ProductImage(name=name, product_id=product_id)
                db.session.add(img_record)
            except Exception:
                # Continue processing other files
                continue

    def delete_product_images(self, product_id):
        images = ProductImage.query.filter_by(product_id=product_id).all()
        if not images:
            return
        for img in images:
            try:
                path = os.path.join(current_app.config.get('IMAGENES_PRODUCTOS_CARPETA', '.'), img.name)
                if os.path.exists(path):
                    os.remove(path)
            except Exception:
                # ignore filesystem errors
                pass
            try:
                db.session.delete(img)
            except Exception:
                pass

    # Spanish wrapper
    def eliminar_imagenes_producto(self, product_id):
        return self.delete_product_images(product_id)

