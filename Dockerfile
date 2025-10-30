# Usa una imagen base de Python 3.10
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
    libodbc1 \
    odbcinst \
    libsqliteodbc \
    && pip install --no-cache-dir -r requirements.txt

# Copiar el resto de la aplicación al contenedor
COPY . .

# Exponer el puerto en el que Flask se ejecutará
EXPOSE 8585

# Comando para ejecutar la aplicación
CMD ["python", "myapp.py"]
