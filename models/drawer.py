#models/drawer.py
from myapp import db

class Drawer(db.Model):
    __tablename__ = 'drawer'
    id = db.Column('drawerid', db.Integer, primary_key=True, autoincrement=True, nullable=False)
    code = db.Column('drawercode', db.String(50))
    divisions_count = db.Column('cantdivisiones', db.Integer)
    free_divisions_count = db.Column('cantdivlibres', db.Integer)

    def serialize(self):
        return {
            'id': self.id,
            'code': self.code,
            'divisions_count': self.divisions_count,
            'free_divisions_count': self.free_divisions_count,
        }
