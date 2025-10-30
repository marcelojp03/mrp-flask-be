from flask import Blueprint, request, g
from app.responses import Responses
from auth.decorators import auth_required
from models.bom import BOM, BOMComponent
from models.product import Product
from app.db import db
from sqlalchemy.exc import IntegrityError

bom_bp = Blueprint('boms', __name__)


@bom_bp.route('', methods=['GET'])
@auth_required
def get_boms():
    """Obtener todas las BOMs de la organización"""
    try:
        product_id = request.args.get('product_id', type=int)
        is_active = request.args.get('is_active', type=lambda v: v.lower() == 'true')
        
        query = BOM.query.filter_by(org_id=g.org_id)
        
        if product_id:
            query = query.filter_by(product_id=product_id)
        if is_active is not None:
            query = query.filter_by(is_active=is_active)
        
        boms = query.order_by(BOM.product_id, BOM.version.desc()).all()
        
        return Responses.success(
            data=[bom.to_dict() for bom in boms],
            message=f'{len(boms)} BOMs encontradas'
        )
    except Exception as e:
        return Responses.error(f'Error al obtener BOMs: {str(e)}', 500)


@bom_bp.route('/<int:bom_id>', methods=['GET'])
@auth_required
def get_bom(bom_id):
    """Obtener una BOM específica"""
    try:
        bom = BOM.query.filter_by(id=bom_id, org_id=g.org_id).first()
        if not bom:
            return Responses.error('BOM no encontrada', 404)
        
        return Responses.success(data=bom.to_dict())
    except Exception as e:
        return Responses.error(f'Error al obtener BOM: {str(e)}', 500)


@bom_bp.route('', methods=['POST'])
@auth_required
def create_bom():
    """Crear una nueva BOM"""
    try:
        data = request.get_json()
        
        # Validaciones
        required_fields = ['product_id', 'version', 'components']
        for field in required_fields:
            if field not in data:
                return Responses.error(f'Campo requerido: {field}', 400)
        
        if not data.get('components'):
            return Responses.error('La BOM debe tener al menos un componente', 400)
        
        # Validar que el producto existe y pertenece a la org
        product = Product.query.filter_by(id=data['product_id'], org_id=g.org_id).first()
        if not product:
            return Responses.error('Producto no encontrado', 404)
        
        # Validar componentes
        component_ids = [c['component_id'] for c in data['components']]
        
        # Evitar recursividad directa
        if data['product_id'] in component_ids:
            return Responses.error('Un producto no puede ser componente de sí mismo', 400)
        
        # Validar que todos los componentes existen
        components = Product.query.filter(
            Product.id.in_(component_ids),
            Product.org_id == g.org_id
        ).all()
        
        if len(components) != len(component_ids):
            return Responses.error('Algunos componentes no existen', 400)
        
        # Crear BOM
        bom = BOM(
            org_id=g.org_id,
            product_id=data['product_id'],
            version=data['version'],
            is_active=data.get('is_active', False),
            description=data.get('description')
        )
        
        db.session.add(bom)
        db.session.flush()  # Para obtener el bom.id
        
        # Crear componentes
        for idx, comp_data in enumerate(data['components']):
            component = BOMComponent(
                bom_id=bom.id,
                component_id=comp_data['component_id'],
                quantity=comp_data['quantity'],
                scrap_percentage=comp_data.get('scrap_percentage', 0),
                unit_id=comp_data.get('unit_id'),
                sequence=comp_data.get('sequence', idx),
                notes=comp_data.get('notes')
            )
            db.session.add(component)
        
        db.session.commit()
        
        return Responses.success(
            data=bom.to_dict(),
            message='BOM creada exitosamente',
            http_code=201
        )
        
    except IntegrityError as e:
        db.session.rollback()
        if 'uq_bom_product_version' in str(e):
            return Responses.error('Ya existe una BOM con esa versión para este producto', 409)
        return Responses.error(f'Error de integridad: {str(e)}', 400)
    except Exception as e:
        db.session.rollback()
        return Responses.error(f'Error al crear BOM: {str(e)}', 500)


@bom_bp.route('/<int:bom_id>', methods=['PUT'])
@auth_required
def update_bom(bom_id):
    """Actualizar una BOM existente"""
    try:
        bom = BOM.query.filter_by(id=bom_id, org_id=g.org_id).first()
        if not bom:
            return Responses.error('BOM no encontrada', 404)
        
        data = request.get_json()
        
        # Si está activa, no permitir ciertos cambios
        if bom.is_active and 'components' in data:
            return Responses.error('No se pueden modificar componentes de una BOM activa. Cree una nueva versión', 400)
        
        # Actualizar campos permitidos
        if 'description' in data:
            bom.description = data['description']
        
        # Actualizar componentes si no está activa
        if 'components' in data and not bom.is_active:
            # Eliminar componentes existentes
            BOMComponent.query.filter_by(bom_id=bom.id).delete()
            
            # Crear nuevos componentes
            for idx, comp_data in enumerate(data['components']):
                component = BOMComponent(
                    bom_id=bom.id,
                    component_id=comp_data['component_id'],
                    quantity=comp_data['quantity'],
                    scrap_percentage=comp_data.get('scrap_percentage', 0),
                    unit_id=comp_data.get('unit_id'),
                    sequence=comp_data.get('sequence', idx),
                    notes=comp_data.get('notes')
                )
                db.session.add(component)
        
        db.session.commit()
        
        return Responses.success(
            data=bom.to_dict(),
            message='BOM actualizada exitosamente'
        )
        
    except Exception as e:
        db.session.rollback()
        return Responses.error(f'Error al actualizar BOM: {str(e)}', 500)


@bom_bp.route('/<int:bom_id>/activate', methods=['PUT'])
@auth_required
def activate_bom(bom_id):
    """Activar una versión de BOM (desactiva las demás del mismo producto)"""
    try:
        bom = BOM.query.filter_by(id=bom_id, org_id=g.org_id).first()
        if not bom:
            return Responses.error('BOM no encontrada', 404)
        
        # Desactivar todas las BOMs del mismo producto
        BOM.query.filter_by(
            org_id=g.org_id,
            product_id=bom.product_id
        ).update({'is_active': False})
        
        # Activar esta BOM
        bom.is_active = True
        
        db.session.commit()
        
        return Responses.success(
            data=bom.to_dict(),
            message=f'BOM v{bom.version} activada para producto {bom.product.name}'
        )
        
    except Exception as e:
        db.session.rollback()
        return Responses.error(f'Error al activar BOM: {str(e)}', 500)


@bom_bp.route('/<int:bom_id>', methods=['DELETE'])
@auth_required
def delete_bom(bom_id):
    """Eliminar una BOM (solo si no está en uso)"""
    try:
        bom = BOM.query.filter_by(id=bom_id, org_id=g.org_id).first()
        if not bom:
            return Responses.error('BOM no encontrada', 404)
        
        # Verificar si está activa
        if bom.is_active:
            return Responses.error('No se puede eliminar una BOM activa', 400)
        
        # TODO: Verificar si tiene Work Orders asociadas
        # if bom.work_orders.count() > 0:
        #     return Responses.error('No se puede eliminar una BOM con órdenes de producción asociadas', 400)
        
        db.session.delete(bom)
        db.session.commit()
        
        return Responses.success(message='BOM eliminada exitosamente')
        
    except Exception as e:
        db.session.rollback()
        return Responses.error(f'Error al eliminar BOM: {str(e)}', 500)
