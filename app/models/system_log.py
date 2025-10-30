from datetime import datetime
from app.db import db

class SystemLog(db.Model):
    __tablename__ = 'system_log'
    
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    ts = db.Column(db.TIMESTAMP, nullable=False, default=datetime.utcnow, index=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=True, index=True)
    org_id = db.Column(db.Integer, db.ForeignKey('organization.id'), nullable=True, index=True)
    action = db.Column(db.String(120), nullable=True)
    path = db.Column(db.Text, nullable=False)
    method = db.Column(db.String(10), nullable=False)
    ip = db.Column(db.String(64), nullable=True)
    status_code = db.Column(db.Integer, nullable=True)
    
    def serialize(self):
        return {
            'id': self.id,
            'ts': self.ts.isoformat() if self.ts else None,
            'user_id': self.user_id,
            'org_id': self.org_id,
            'action': self.action,
            'path': self.path,
            'method': self.method,
            'ip': self.ip,
            'status_code': self.status_code
        }
