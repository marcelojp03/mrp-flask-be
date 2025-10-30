# models/report_audit.py
from datetime import datetime
from app.db import db

class ReportAudit(db.Model):
    """Auditoría de reportes generados por IA/NL"""
    __tablename__ = 'report_audit'
    
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    ts = db.Column(db.TIMESTAMP, default=datetime.utcnow, nullable=False, index=True)
    
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    org_id = db.Column(db.Integer, db.ForeignKey('organization.id'), nullable=False, index=True)
    
    # Datos de la consulta
    prompt = db.Column(db.Text, nullable=False)  # Texto en lenguaje natural
    sql = db.Column(db.Text)  # SQL generado
    rowcount = db.Column(db.Integer)  # Filas retornadas
    error = db.Column(db.Text)  # Error si falló
    took_ms = db.Column(db.Integer)  # Tiempo de ejecución en ms
    
    # Relaciones
    user = db.relationship('User', backref=db.backref('report_audits', lazy=True))
    organization = db.relationship('Organization', backref=db.backref('report_audits', lazy=True))
    
    def serialize(self):
        return {
            'id': self.id,
            'ts': self.ts.isoformat() if self.ts else None,
            'user_id': self.user_id,
            'org_id': self.org_id,
            'prompt': self.prompt,
            'sql': self.sql,
            'rowcount': self.rowcount,
            'error': self.error,
            'took_ms': self.took_ms
        }
