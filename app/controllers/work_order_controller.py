from flask import Blueprint, request, g
from app.responses import Responses
from auth.decorators import auth_required
from app.models.work_order import WorkOrder
from app.models.bom import BOM, BOMComponent
from app.models.product import Product
from app.models.warehouse import Warehouse
from app.models.product_warehouse import ProductWarehouse
from app.models.movement import Movement
from app.db import db
from datetime import datetime, timedelta
from decimal import Decimal
from sqlalchemy import func

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
        
        # 🔍 LOG TEMPORAL: Ver qué está llegando
        print("=" * 70)
        print("📥 DATOS RECIBIDOS PARA CREAR WORK ORDER:")
        print(f"   Datos: {data}")
        print(f"   Tipo: {type(data)}")
        if data:
            for key, value in data.items():
                print(f"   - {key}: {value} (tipo: {type(value).__name__})")
        print("=" * 70)
        
        # Validaciones
        required_fields = ['product_id', 'quantity']
        for field in required_fields:
            if field not in data:
                print(f"❌ FALTA CAMPO REQUERIDO: {field}")
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
                product_id=comp.component_id,
                warehouse_id=wo.warehouse_id
            ).first()
            
            current_stock = float(pw.current_stock) if pw else 0
            
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
                product_id=comp.component_id,
                warehouse_id=wo.warehouse_id
            ).first()
            
            if pw:
                pw.current_stock = Decimal(str(float(pw.current_stock) - required_qty))
            
            # Obtener información del producto
            product = Product.query.get(comp.component_id)
            
            movements_created.append({
                'movement_id': movement.id if hasattr(movement, 'id') else None,
                'product_id': comp.component_id,
                'product_code': product.code if product else None,
                'product_name': product.name if product else None,
                'quantity': required_qty
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
            product_id=wo.product_id,
            warehouse_id=wo.warehouse_id
        ).first()
        
        if pw:
            pw.current_stock = Decimal(str(float(pw.current_stock) + produced_qty))
        else:
            # Crear registro si no existe
            pw = ProductWarehouse(
                product_id=wo.product_id,
                warehouse_id=wo.warehouse_id,
                current_stock=Decimal(str(produced_qty))
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
                    'movement_id': movement.id if hasattr(movement, 'id') else None,
                    'product_id': wo.product_id,
                    'product_code': wo.product.code,
                    'product_name': wo.product.name,
                    'quantity': produced_qty,
                    'warehouse_id': wo.warehouse_id,
                    'warehouse_name': wo.warehouse.name
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


# ============================================================================
# REPORTES DE PRODUCCIÓN
# ============================================================================

@work_order_bp.route('/reports/stats', methods=['GET'])
@auth_required
def get_production_stats():
    """
    Estadísticas y KPIs de producción
    Query params: 
      - from (YYYY-MM-DD): Fecha inicio (por defecto: 30 días atrás)
      - to (YYYY-MM-DD): Fecha fin (por defecto: hoy)
    """
    try:
        # Filtros de fecha
        date_to = request.args.get('to')
        date_from = request.args.get('from')
        
        # Valores por defecto: últimos 30 días
        if not date_to:
            dt_to = datetime.utcnow()
        else:
            # Incluir todo el día final (hasta las 23:59:59)
            dt_to = datetime.strptime(date_to, '%Y-%m-%d') + timedelta(days=1) - timedelta(seconds=1)
        
        if not date_from:
            dt_from = dt_to - timedelta(days=30)
        else:
            # Iniciar desde las 00:00:00 del día
            dt_from = datetime.strptime(date_from, '%Y-%m-%d')
        
        # Obtener Work Orders del período
        work_orders = WorkOrder.query.filter(
            WorkOrder.org_id == g.org_id,
            WorkOrder.created_at >= dt_from,
            WorkOrder.created_at <= dt_to
        ).all()
        
        total = len(work_orders)
        
        # ========== KPIs Principales ==========
        by_status = {
            'PLANNED': 0,
            'IN_PROGRESS': 0,
            'FINISHED': 0,
            'CANCELLED': 0
        }
        
        total_quantity_planned = 0
        total_quantity_finished = 0
        
        for wo in work_orders:
            # Contar por estado
            if wo.status == WorkOrder.STATUS_PLANNED:
                by_status['PLANNED'] += 1
            elif wo.status == WorkOrder.STATUS_IN_PROGRESS:
                by_status['IN_PROGRESS'] += 1
            elif wo.status == WorkOrder.STATUS_FINISHED:
                by_status['FINISHED'] += 1
            elif wo.status == WorkOrder.STATUS_CANCELLED:
                by_status['CANCELLED'] += 1
            
            total_quantity_planned += wo.quantity or 0
            if wo.status == WorkOrder.STATUS_FINISHED:
                total_quantity_finished += wo.quantity or 0
        
        # Tasa de completitud
        completion_rate = 0
        if total > 0:
            completion_rate = round(by_status['FINISHED'] / total * 100, 2)
        
        # Eficiencia de producción (unidades terminadas vs planificadas)
        efficiency_rate = 0
        if total_quantity_planned > 0:
            efficiency_rate = round(total_quantity_finished / total_quantity_planned * 100, 2)
        
        # ========== Top BOMs Más Utilizadas ==========
        bom_usage = {}
        for wo in work_orders:
            if wo.bom_id:
                if wo.bom_id not in bom_usage:
                    bom_usage[wo.bom_id] = {
                        'count': 0,
                        'total_quantity': 0,
                        'bom': wo.bom
                    }
                bom_usage[wo.bom_id]['count'] += 1
                bom_usage[wo.bom_id]['total_quantity'] += wo.quantity or 0
        
        # Top 5 BOMs
        top_boms = sorted(bom_usage.values(), key=lambda x: x['count'], reverse=True)[:5]
        top_boms_data = []
        for item in top_boms:
            bom = item['bom']
            top_boms_data.append({
                'bom_id': bom.id,
                'product_id': bom.product_id,
                'product_name': bom.product.name if bom.product else 'N/A',
                'product_code': bom.product.code if bom.product else 'N/A',
                'work_orders_count': item['count'],
                'total_quantity': item['total_quantity']
            })
        
        # ========== Productos Más Producidos ==========
        product_production = {}
        for wo in work_orders:
            if wo.product_id:
                if wo.product_id not in product_production:
                    product_production[wo.product_id] = {
                        'quantity': 0,
                        'orders_count': 0,
                        'product': wo.product
                    }
                product_production[wo.product_id]['quantity'] += wo.quantity or 0
                product_production[wo.product_id]['orders_count'] += 1
        
        # Top 5 productos
        top_products = sorted(product_production.values(), key=lambda x: x['quantity'], reverse=True)[:5]
        top_products_data = []
        for item in top_products:
            product = item['product']
            top_products_data.append({
                'product_id': product.id,
                'product_name': product.name,
                'product_code': product.code,
                'total_quantity': item['quantity'],
                'orders_count': item['orders_count']
            })
        
        # ========== Tendencia Mensual (últimos 6 meses) ==========
        # Agrupar por mes
        monthly_data = {}
        for wo in work_orders:
            if wo.created_at:
                month_key = wo.created_at.strftime('%Y-%m')
                if month_key not in monthly_data:
                    monthly_data[month_key] = {
                        'PLANNED': 0,
                        'IN_PROGRESS': 0,
                        'FINISHED': 0,
                        'CANCELLED': 0,
                        'total': 0
                    }
                
                # Incrementar contador del estado correspondiente
                if wo.status == WorkOrder.STATUS_PLANNED:
                    monthly_data[month_key]['PLANNED'] += 1
                elif wo.status == WorkOrder.STATUS_IN_PROGRESS:
                    monthly_data[month_key]['IN_PROGRESS'] += 1
                elif wo.status == WorkOrder.STATUS_FINISHED:
                    monthly_data[month_key]['FINISHED'] += 1
                elif wo.status == WorkOrder.STATUS_CANCELLED:
                    monthly_data[month_key]['CANCELLED'] += 1
                
                monthly_data[month_key]['total'] += 1
        
        # Convertir a lista ordenada
        monthly_production = [
            {
                'month': month,
                'planned': data['PLANNED'],
                'in_progress': data['IN_PROGRESS'],
                'finished': data['FINISHED'],
                'cancelled': data['CANCELLED'],
                'total': data['total']
            }
            for month, data in sorted(monthly_data.items())
        ]
        
        # ========== Tiempo Promedio de Producción ==========
        completion_times = []
        for wo in work_orders:
            if wo.status == WorkOrder.STATUS_FINISHED and wo.actual_start and wo.actual_end:
                delta = wo.actual_end - wo.actual_start
                completion_times.append(delta.total_seconds() / 3600)  # Convertir a horas
        
        avg_completion_time = 0
        if completion_times:
            avg_completion_time = round(sum(completion_times) / len(completion_times), 2)
        
        # ========== Respuesta ==========
        return Responses.success(
            data={
                'period': {
                    'from': dt_from.strftime('%Y-%m-%d'),
                    'to': dt_to.strftime('%Y-%m-%d')
                },
                'summary': {
                    'total_work_orders': total,
                    'total_quantity_planned': total_quantity_planned,
                    'total_quantity_finished': total_quantity_finished,
                    'by_status': by_status,
                    'completion_rate': completion_rate,
                    'efficiency_rate': efficiency_rate,
                    'avg_completion_time_hours': avg_completion_time
                },
                'top_boms': top_boms_data,
                'top_products': top_products_data,
                'monthly_production': monthly_production
            },
            message='Estadísticas de producción generadas'
        )
        
    except Exception as e:
        return Responses.error(f'Error al generar estadísticas: {str(e)}', 500)

