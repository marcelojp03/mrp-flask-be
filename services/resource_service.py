#services/resource_service.py
from typing import Optional, List
from myapp import db
from models.resource import Resource
from models.user_role import UserRole
from models.role_resource import RoleResource
from models.subresource import Subresource

class ResourceService:
    # === CRUD Resource (nombres esperados por controller) ===
    def list(self) -> List[dict]:
        return [r.serialize() for r in Resource.query.all()]

    def get(self, resource_id: int) -> Optional[dict]:
        r = Resource.query.get(resource_id)
        return r.serialize() if r else None

    def create(self, data: dict) -> dict:
        name = data.get('name')
        if not name:
            raise ValueError("name es obligatorio")
        r = Resource(name=name, description=data.get('description'))
        db.session.add(r)
        db.session.commit()
        return r.serialize()

    def update(self, resource_id: int, data: dict) -> Optional[dict]:
        r = Resource.query.get(resource_id)
        if not r: return None
        if 'name' in data: r.name = data['name']
        if 'description' in data: r.description = data['description']
        db.session.commit()
        return r.serialize()

    def delete(self, resource_id: int) -> bool:
        r = Resource.query.get(resource_id)
        if not r: return False
        db.session.delete(r)
        db.session.commit()
        return True

    # === Menú por usuario (usado por /roles/menu/<user_id>) ===
    # def menu_for_user(self, user_id: int) -> List[dict]:
    #     role_ids = [ur.role_id for ur in UserRole.query.filter_by(user_id=user_id).all()]
    #     if not role_ids:
    #         return []
    #     rrs = RoleResource.query.filter(RoleResource.role_id.in_(role_ids)).all()
    #     resources = {r.id: r for r in Resource.query.all()}
    #     subresources = {s.id: s for s in Subresource.query.all()}

    #     menu = {}
    #     for rr in rrs:
    #         res = resources.get(rr.resource_id)
    #         sub = subresources.get(rr.subresource_id)
    #         if not res: 
    #             continue
    #         if res.id not in menu:
    #             menu[res.id] = {'id': res.id, 'name': res.name, 'description': res.description, 'subresources': []}
    #         if sub:
    #             menu[res.id]['subresources'].append({
    #                 'id': sub.id, 'name': sub.name, 'description': sub.description, 'url': sub.url, 'icon': sub.icon
    #             })
    #     return list(menu.values())
    def menu_for_user(self, user_id: int) -> List[dict]:
        role_ids_subq = db.session.query(UserRole.role_id)\
            .filter(UserRole.user_id == user_id).subquery()

        rows = (
            db.session.query(
                Resource.id, Resource.name, Resource.description,
                Subresource.id, Subresource.name, Subresource.description,
                Subresource.url, Subresource.icon
            )
            .join(RoleResource, RoleResource.resource_id == Resource.id)
            .outerjoin(Subresource, Subresource.id == RoleResource.subresource_id)
            .filter(RoleResource.role_id.in_(db.session.query(role_ids_subq.c.role_id)))
            .order_by(Resource.id.asc(), Subresource.id.asc())  # ← añade sort_order si lo creas
            .all()
        )

        menu: dict[int, dict] = {}
        seen_subs: set[int] = set()

        for (res_id, res_name, res_desc,
            sub_id, sub_name, sub_desc, sub_url, sub_icon) in rows:

            if res_id not in menu:
                menu[res_id] = {
                    'id': res_id, 'name': res_name,
                    'description': res_desc, 'subresources': []
                }
            if sub_id and sub_id not in seen_subs:
                seen_subs.add(sub_id)
                menu[res_id]['subresources'].append({
                    'id': sub_id, 'name': sub_name,
                    'description': sub_desc, 'url': sub_url, 'icon': sub_icon
                })

        # opcional: filtra recursos sin subrecursos
        return [r for r in menu.values() if r['subresources']]


