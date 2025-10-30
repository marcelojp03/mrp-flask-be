# app/responses.py
from flask import jsonify

class Responses:
    @staticmethod
    def success(data=None, message="OK", meta=None, http_code=200):
        """
        data: payload (obj o lista)
        meta: dict opcional (paginación, filtros, etc.)
        """
        body = {
            "success": True,
            "message": message,
            "data": data
        }
        if meta is not None:
            body["meta"] = meta
        return jsonify(body), http_code

    @staticmethod
    def paginated(items, total, page, page_size, message="OK", http_code=200):
        meta = {
            "total": total,
            "page": page,
            "page_size": page_size,
            "pages": (total + page_size - 1) // page_size
        }
        return Responses.success(data=items, message=message, meta=meta, http_code=http_code)

    @staticmethod
    def error(message="Error", http_code=400, code=None, details=None):
        """
        code: string corta para tipo de error (ej. 'VALIDATION_ERROR', 'NOT_FOUND')
        details: dict/list con campos inválidos o info extra
        """
        body = {
            "success": False,
            "message": message,
            "data": None
        }
        if code is not None:
            body["code"] = code
        if details is not None:
            body["details"] = details
        return jsonify(body), http_code

    @staticmethod
    def from_exception(ex, http_code=500, code="INTERNAL_ERROR"):
        # no filtra el mensaje; si quieres, registra el traceback y manda msg genérico.
        return Responses.error(message=str(ex), http_code=http_code, code=code)
