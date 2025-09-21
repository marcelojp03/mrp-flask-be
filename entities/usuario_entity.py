# entities/usuario_entity.py
from models.user import User
from entities.user_role_entity import UserRoleEntity
from flask import current_app
from myapp import db
import base64
import os
from PIL import Image
from io import BytesIO
import hashlib

user_role_entity=UserRoleEntity


class UserEntity:
    def get_all(self):
        users = User.query.all()
        # usuarios_con_roles=[]
        # for usuario in users:    
        #     usuario_serializado=usuario.serialize()
        #     roles_usuario = user_role_entity.get_by_user_id(self, usuario.id)
        #     print(roles_usuario)
        #     if roles_usuario:
        #             usuario_serializado['roles'] = roles_usuario
        #             # usuario_serializado['rol_id'] = roles_usuario['rol_id']

        #     usuarios_con_roles.append(usuario_serializado)

        # return usuarios_con_roles if users else None
        return [user.serialize() for user in users]

    def get_by_id(self, user_id):
        usuario = User.query.get(user_id)
        if usuario:
            usuario_serializado = usuario.serialize()
            # roles_usuario = user_role_entity.get_by_user_id(self, usuario.id)
            # print(roles_usuario)
            # if roles_usuario:
            #         usuario_serializado['roles'] = roles_usuario
            #         # usuario_serializado['rol_id'] = roles_usuario['rol_id']
            foto_nombre = usuario.photo
            if foto_nombre:
                ruta_imagen = os.path.join(current_app.config['IMAGENES_USUARIOS_CARPETA'], foto_nombre)
                with open(ruta_imagen, 'rb') as f:
                    imagen_bytes = f.read()
                    imagen_base64 = base64.b64encode(imagen_bytes).decode('utf-8')
                usuario_serializado['photo'] = imagen_base64
            return usuario_serializado
        else:
            return None
    
    def get_by_username(self, nombre_usuario):
        usuario=User.query.filter_by(name=nombre_usuario).first()
        return usuario.serialize() if usuario else None
    
    def get_by_email(self, email):
        usuario=User.query.filter_by(email=email).first()
        return usuario.serialize() if usuario else None

    def create(self, nombre, correo, contraseña, foto_name=None):
        nuevo_usuario = User(
            name=nombre,
            email=correo,
            password=contraseña,
            photo=foto_name            
        )
        db.session.add(nuevo_usuario)
        db.session.commit()
        return nuevo_usuario.serialize()

    def update(self, usuario_id, nombre_usuario, contraseña, nombre, correo, foto_base64=None):
        usuario = User.query.get(usuario_id)
        
        if usuario:
            usuario.name = nombre
            usuario.email = correo
            if contraseña:
                usuario.password = contraseña

            if foto_base64:
                foto=self.guardar_imagen_local(foto_base64,usuario_id)
                usuario.photo = foto

            db.session.commit()

        return usuario.serialize() if usuario else None


    def guardar_imagen_local(self, img_base64, usuario_id):
        # Decodificar la imagen base64
        starter = img_base64.find(',')
        img_data = img_base64[starter + 1:]
        img_data_bytes = bytes(img_data, encoding="ascii")

        # Convertir los datos decodificados en un objeto Image
        im = Image.open(BytesIO(base64.b64decode(img_data_bytes))).convert('RGB')
        
        # Generar un nombre único para la imagen
        hash_object = hashlib.sha256(img_base64.encode())
        hash_value = hash_object.hexdigest()[:8]  # Tomar los primeros 8 caracteres del hash
        nombre_archivo = f"usuario_{usuario_id}_{hash_value}.png"
        
        # Guardar la imagen en el servidor
        carpeta = current_app.config['IMAGENES_USUARIOS_CARPETA']
        os.makedirs(carpeta, exist_ok=True)
        ruta_archivo = os.path.join(carpeta, nombre_archivo)
        im.save(ruta_archivo)
        
        return nombre_archivo
    

    def eliminar_imagen_usuario(self, usuario_id):
        usuario = User.query.filter_by(id=usuario_id).first()
        imagen_usuario=usuario.photo
        #print("IMAGEN USUARIO ", imagen_usuario)
        if not imagen_usuario:
            return 
        
        # Verificar si la imagen existe en el almacenamiento
        ruta_imagen = os.path.join(current_app.config['IMAGENES_USUARIOS_CARPETA'], imagen_usuario)
        if os.path.exists(ruta_imagen):
            #Eliminar la imagen del almacenamiento
            os.remove(ruta_imagen)
            usuario.photo=None
            db.session.commit()
        else:
            return "La imagen no existe en el almacenamiento"

    def delete(self, usuario_id):
        usuario = User.query.get(usuario_id)
        if usuario:
            usuario.status=False
            db.session.commit()

        return usuario.serialize() if usuario else None
    
    def deletePer(self, usuario_id):
        usuario = User.query.get(usuario_id)
        if usuario:
            db.session.delete(usuario)
            #usuario.estado=False
            db.session.commit()

        return usuario.serialize() if usuario else None
