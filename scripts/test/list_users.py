"""Listar usuarios activos"""
import sys, os
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
from run import app
from app.db import db
from sqlalchemy import text

with app.app_context():
    result = db.session.execute(text('SELECT id, name, email FROM "user" WHERE status = true LIMIT 5')).fetchall()
    print('\n👥 Usuarios activos:')
    for r in result:
        print(f'  ID {r[0]}: {r[1]} ({r[2]})')
    print()
