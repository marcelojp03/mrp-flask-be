#!/usr/bin/env python3
"""
Verificar que las variables de entorno se están cargando correctamente
"""
from dotenv import load_dotenv
import os

print("=" * 60)
print("🔍 VERIFICACIÓN DE VARIABLES DE ENTORNO")
print("=" * 60)

# Cargar .env
print("\n1️⃣ Cargando .env...")
load_dotenv()
print("✅ Archivo .env cargado")

# Verificar variables críticas
print("\n2️⃣ Variables críticas:")
print("-" * 60)

variables = {
    "FLASK_ENV": os.getenv("FLASK_ENV"),
    "DB_USER": os.getenv("DB_USER"),
    "DB_HOST": os.getenv("DB_HOST"),
    "DB_NAME": os.getenv("DB_NAME"),
    "JWT_SECRET_KEY": "***" if os.getenv("JWT_SECRET_KEY") else None,
    "OPENAI_API_KEY": "***" if os.getenv("OPENAI_API_KEY") else None,
    "LLM_MODEL": os.getenv("LLM_MODEL"),
}

all_ok = True
for key, value in variables.items():
    if value:
        status = "✅"
        display_value = value if value != "***" else "(oculta)"
    else:
        status = "❌"
        display_value = "NO CONFIGURADA"
        all_ok = False
    
    print(f"{status} {key:20} = {display_value}")

print("\n" + "=" * 60)

if all_ok:
    print("✅ TODAS LAS VARIABLES CONFIGURADAS")
    print("\n💡 El endpoint /api/reports/nl debería funcionar ahora")
else:
    print("❌ FALTAN VARIABLES")
    print("\n⚠️  Revisa el archivo .env")

print("=" * 60)

# Mostrar la OPENAI_API_KEY completa (solo primeros y últimos caracteres)
api_key = os.getenv("OPENAI_API_KEY")
if api_key:
    print(f"\n🔑 OPENAI_API_KEY: {api_key[:10]}...{api_key[-10:]}")
    print(f"   Longitud: {len(api_key)} caracteres")
else:
    print("\n❌ OPENAI_API_KEY no encontrada")
