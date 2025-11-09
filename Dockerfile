# Usa una imagen base de Python 3.12
FROM python:3.12-slim

# Establecer el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar requirements.txt al directorio de trabajo
COPY requirements.txt .

# Actualizar pip
RUN pip install --upgrade pip

# Instalar las dependencias del sistema necesarias para psycopg2, ODBC y otros paquetes que requieren compilación
RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    unixodbc \
    unixodbc-dev \
    libodbc2 \
    odbcinst \
    libsqliteodbc \
    && pip install --no-cache-dir -r requirements.txt \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copiar el resto de la aplicación al contenedor
COPY . .

# Exponer el puerto en el que Flask se ejecutará
EXPOSE 4646

# Variable de entorno para producción
ENV FLASK_ENV=production

# Comando para ejecutar la aplicación con gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:4646", "--workers", "4", "--timeout", "120", "run:app"]
