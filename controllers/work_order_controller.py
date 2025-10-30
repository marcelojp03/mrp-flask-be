from flask import Blueprint, request, g
from app.responses import Responses
from auth.decorators import auth_required
from models.work_order import WorkOrder
from models.bom import BOM, BOMComponent
from models.product import Product
from models.warehouse import Warehouse
from models.product_warehouse import ProductWarehouse
from models.movement import Movement
from app.db import db
from datetime import datetime
from decimal import Decimal

work_order_bp = Blueprint('work_orders', __name__)

def SaasGuard():
    """Decorador temporal hasta implementar guards reales"""
    def decorator(f):
        return f
    return decorator


@work_order_bp.route('', methods=['GET'])
@auth_required
def get_work_orders():
    """Obtener todas las Work Orders de la organización"""
    try:
        status = request.args.get('status')
        product_id = request.args.get('product_id', type=int)
        assigned_to = request.args.get('assigned_to', type=int)
        
        query = WorkOrder.query.filter_by(org_id=g.org_id)
        
        if status:
            query = query.filter_by(status=status)
        if product_id:
            query = query.filter_by(product_id=product_id)
        if assigned_to:
            query = query.filter_by(assigned_to=assigned_to)
        
        work_orders = query.order_by(WorkOrder.created_at.desc()).all()
        
        return Responses.success(
            data=[wo.to_dict() for wo in work_orders],
            message=f'{len(work_orders)} órdenes encontradas'
        )
    except Exception as e:
        return Responses.error(f'Error al obtener Work Orders: {str(e)}', 500)


@work_order_bp.route('/<int:wo_id>', methods=['GET'])
@auth_required
def get_work_order(wo_id):
    """Obtener una Work Order específica"""
    try:
        wo = WorkOrder.query.filter_by(id=wo_id, org_id=g.org_id).first()
        if not wo:
            return Responses.error('Work Order no encontrada', 404)
        
        return Responses.success(data=wo.to_dict())
    except Exception as e:
        return Responses.error(f'Error al obtener Work Order: {str(e)}', 500)


@work_order_bp.route('', methods=['POST'])
@auth_required
def create_work_order():
    """Crear una nueva Work Order (estado Planificada)"""
    try:
        data = request.get_json()
        
        # Validaciones
        required_fields = ['product_id', 'quantity']
        for field in required_fields:
            if field not in data:
                return Responses.error(f'Campo requerido: {field}', 400)
        
        # Validar producto
        product = Product.query.filter_by(id=data['product_id'], org_id=g.org_id).first()
        if not product:
            return Responses.error('Producto no encontrado', 404)
        
        # Buscar BOM activa para el producto
        bom = BOM.query.filter_by(
            org_id=g.org_id,
            product_id=data['product_id'],
            is_active=True
        ).first()
        
        if not bom:
            return Responses.error('No existe una BOM activa para este producto', 400)
        
        # Validar warehouse si se proporciona
        if data.get('warehouse_id'):
            warehouse = Warehouse.query.filter_by(
                id=data['warehouse_id'],
                org_id=g.org_id
            ).first()
            if not warehouse:
                return Responses.error('Almacén no encontrado', 404)
        
        # Crear Work Order
        wo = WorkOrder(
            org_id=g.org_id,
            product_id=data['product_id'],
            bom_id=bom.id,
            quantity=data['quantity'],
            status=WorkOrder.STATUS_PLANNED,
            warehouse_id=data.get('warehouse_id'),
            assigned_to=data.get('assigned_to'),
            reference=data.get('reference'),
            notes=data.get('notes'),
            planned_start=data.get('planned_start'),
            planned_end=data.get('planned_end'),
            created_by=g.user_id if hasattr(g, 'user_id') else None
        )
        
        db.session.add(wo)
        db.session.commit()
        
        return Responses.success(
            data=wo.to_dict(),
            message='Work Order creada exitosamente',
            http_code=201
        )
        
    except Exception as e:
        db.session.rollback()
        return Responses.error(f'Error al crear Work Order: {str(e)}', 500)


@work_order_bp.route('/<int:wo_id>/start', methods=['PUT'])
@auth_required
@SaasGuard()
def start_work_order(wo_id):
    """Iniciar una Work Order - genera movimientos OUT de componentes"""
    try:
        wo = WorkOrder.query.filter_by(id=wo_id, org_id=g.org_id).first()
        if not wo:
            return Responses.error('Work Order no encontrada', 404)
        
        if wo.status != WorkOrder.STATUS_PLANNED:
            return Responses.error(f'Solo se pueden iniciar Work Orders en estado Planificada. Estado actual: {wo.status}', 400)
        
        if not wo.warehouse_id:
            return Responses.error('La Work Order debe tener un almacén asignado', 400)
        
        # Obtener componentes de la BOM
        components = BOMComponent.query.filter_by(bom_id=wo.bom_id).all()
        
        if not components:
            return Responses.error('La BOM no tiene componentes definidos', 400)
        
        # Validar stock suficiente para cada componente
        insufficient_stock = []
        for comp in components:
            # Calcular cantidad necesaria incluyendo scrap
            scrap_factor = 1 + (float(comp.scrap_percentage) / 100)
            required_qty = float(comp.quantity) * float(wo.quantity) * scrap_factor
            
            # Verificar stock disponible
            pw = ProductWarehouse.query.filter_by(
                productid=comp.component_id,
                warehouseid=wo.warehouse_id
            ).first()
            
            current_stock = float(pw.stock) if pw else 0
            
            if current_stock < required_qty:
                product = Product.query.get(comp.component_id)
                insufficient_stock.append({
                    'product': product.name if product else f'ID {comp.component_id}',
                    'required': required_qty,
                    'available': current_stock,
                    'missing': required_qty - current_stock
                })
        
        if insufficient_stock:
            return Responses.error(
                'Stock insuficiente para iniciar producción',
                400,
                details={'insufficient_stock': insufficient_stock}
            )
        
        # Generar movimientos OUT para cada componente
        movements_created = []
        for comp in components:
            scrap_factor = 1 + (float(comp.scrap_percentage) / 100)
            required_qty = float(comp.quantity) * float(wo.quantity) * scrap_factor
            
            # Crear movimiento OUT (CONSUMPTION)
            movement = Movement(
                org_id=g.org_id,
                product_id=comp.component_id,
                from_warehouse_id=wo.warehouse_id,
                to_warehouse_id=None,
                movement_type='OUT',
                reason='CONSUMPTION',
                quantity=Decimal(str(required_qty)),
                reference_type='WO',
                reference_id=str(wo.id),
                note=f'Consumo para WO #{wo.id} - {wo.product.name}',
                created_by=g.user_id if hasattr(g, 'user_id') else None
            )
            db.session.add(movement)
            
            # Actualizar stock en product_warehouse
            pw = ProductWarehouse.query.filter_by(
                productid=comp.component_id,
                warehouseid=wo.warehouse_id
            ).first()
            
            if pw:
                pw.stock = Decimal(str(float(pw.stock) - required_qty))
            
            movements_created.append({
                'product_id': comp.component_id,
                'quantity': required_qty,
                'movement_id': movement.id if hasattr(movement, 'id') else None
            })
        
        # Actualizar Work Order
        wo.status = WorkOrder.STATUS_IN_PROGRESS
        wo.actual_start = datetime.utcnow()
        
        db.session.commit()
        
        return Responses.success(
            data={
                'work_order': wo.to_dict(),
                'movements': movements_created
            },
            message=f'Work Order iniciada. {len(movements_created)} movimientos de consumo generados'
        )
        
    except Exception as e:
        db.session.rollback()
        return Responses.error(f'Error al iniciar Work Order: {str(e)}', 500)


@work_order_bp.route('/<int:wo_id>/finish', methods=['PUT'])
@auth_required
@SaasGuard()
def finish_work_order(wo_id):
    """Finalizar una Work Order - genera movimiento IN del producto terminado"""
    try:
        wo = WorkOrder.query.filter_by(id=wo_id, org_id=g.org_id).first()
        if not wo:
            return Responses.error('Work Order no encontrada', 404)
        
        if wo.status != WorkOrder.STATUS_IN_PROGRESS:
            return Responses.error(f'Solo se pueden finalizar Work Orders en estado En Progreso. Estado actual: {wo.status}', 400)
        
        if not wo.warehouse_id:
            return Responses.error('La Work Order debe tener un almacén asignado', 400)
        
        # Obtener cantidad producida (puede ser diferente a la planificada)
        data = request.get_json() or {}
        produced_qty = data.get('produced_quantity', float(wo.quantity))
        
        if produced_qty <= 0:
            return Responses.error('La cantidad producida debe ser mayor a 0', 400)
        
        # Crear movimiento IN (PRODUCTION)
        movement = Movement(
            org_id=g.org_id,
            product_id=wo.product_id,
            from_warehouse_id=None,
            to_warehouse_id=wo.warehouse_id,
            movement_type='IN',
            reason='PRODUCTION',
            quantity=Decimal(str(produced_qty)),
            reference_type='WO',
            reference_id=str(wo.id),
            note=f'Producción completada - WO #{wo.id}',
            created_by=g.user_id if hasattr(g, 'user_id') else None
        )
        db.session.add(movement)
        
        # Actualizar stock en product_warehouse
        pw = ProductWarehouse.query.filter_by(
            productid=wo.product_id,
            warehouseid=wo.warehouse_id
        ).first()
        
        if pw:
            pw.stock = Decimal(str(float(pw.stock) + produced_qty))
        else:
            # Crear registro si no existe
            pw = ProductWarehouse(
                productid=wo.product_id,
                warehouseid=wo.warehouse_id,
                stock=Decimal(str(produced_qty))
            )
            db.session.add(pw)
        
        # Actualizar Work Order
        wo.status = WorkOrder.STATUS_FINISHED
        wo.actual_end = datetime.utcnow()
        
        # Si se especifica una cantidad diferente, actualizar
        if 'produced_quantity' in data:
            wo.notes = (wo.notes or '') + f'\nCantidad producida: {produced_qty} (planificada: {wo.quantity})'
        
        db.session.commit()
        
        return Responses.success(
            data={
                'work_order': wo.to_dict(),
                'movement': {
                    'product_id': wo.product_id,
                    'quantity': produced_qty,
                    'warehouse_id': wo.warehouse_id
                }
            },
            message=f'Work Order finalizada. {produced_qty} unidades de {wo.product.name} agregadas al inventario'
        )
        
    except Exception as e:
        db.session.rollback()
        return Responses.error(f'Error al finalizar Work Order: {str(e)}', 500)


@work_order_bp.route('/<int:wo_id>/cancel', methods=['PUT'])
@auth_required
def cancel_work_order(wo_id):
    """Cancelar una Work Order"""
    try:
        wo = WorkOrder.query.filter_by(id=wo_id, org_id=g.org_id).first()
        if not wo:
            return Responses.error('Work Order no encontrada', 404)
        
        if wo.status == WorkOrder.STATUS_FINISHED:
            return Responses.error('No se puede cancelar una Work Order finalizada', 400)
        
        # TODO: Si está en progreso, considerar revertir movimientos (feature avanzada)
        if wo.status == WorkOrder.STATUS_IN_PROGRESS:
            return Responses.error('No se puede cancelar una Work Order en progreso. Implemente reversión de movimientos primero', 400)
        
        wo.status = WorkOrder.STATUS_CANCELLED
        db.session.commit()
        
        return Responses.success(
            data=wo.to_dict(),
            message='Work Order cancelada'
        )
        
    except Exception as e:
        db.session.rollback()
        return Responses.error(f'Error al cancelar Work Order: {str(e)}', 500)
