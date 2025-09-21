from models.drawer import Drawer


class DrawerEntity:
    def get_by_code(self, code):
        if not code:
            return None
        d = Drawer.query.filter_by(code=code).first()
        return d.serialize() if d else None
