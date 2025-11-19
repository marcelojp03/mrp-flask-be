"""Script para corregir uso de Responses en controladores Sprint 4"""
import re

def fix_responses(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Reemplazos
    replacements = [
        # success_response con data y message
        (r'return success_response\(\s*data=(.+?),\s*message=(.+?),\s*status_code=(\d+)\s*\)',
         r'return Responses.success(data=\1, message=\2, http_code=\3)'),
        
        # success_response con data y message sin status_code
        (r'return success_response\(\s*data=(.+?),\s*message=(.+?)\s*\)',
         r'return Responses.success(data=\1, message=\2)'),
        
        # success_response solo con data
        (r'return success_response\(data=(.+?)\)',
         r'return Responses.success(data=\1)'),
        
        # success_response solo con message
        (r'return success_response\(\s*message=(.+?)\s*\)',
         r'return Responses.success(message=\1)'),
        
        # error_response con mensaje y código
        (r'return error_response\((.+?),\s*(\d+)\)',
         r'return Responses.error(\1, \2)'),
        
        # error_response solo con mensaje
        (r'return error_response\((.+?)\)',
         r'return Responses.error(\1)'),
    ]
    
    for pattern, replacement in replacements:
        content = re.sub(pattern, replacement, content, flags=re.MULTILINE | re.DOTALL)
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f'✅ {filepath} corregido')

# Archivos a corregir
files = [
    'app/controllers/demand_controller.py',
    'app/controllers/mps_controller.py',
    'app/controllers/mrp_controller.py'
]

for file in files:
    fix_responses(file)

print('\n✅ Todos los controladores corregidos')
