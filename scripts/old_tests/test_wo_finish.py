"""
Test: Finalizar Work Order #2
"""
import requests
import json

BASE_URL = "http://localhost:5000/api"

# Login
login_response = requests.post(f"{BASE_URL}/login", json={
    "email": "marcelojp03@gmail.com",
    "password": "123456"
})

token = login_response.json()['data']['access_token']
headers = {"Authorization": f"Bearer {token}"}

# Test: PUT /api/work-orders/2/finish
print("=" * 60)
print("TEST: PUT /api/work-orders/2/finish")
print("=" * 60)

response = requests.put(
    f"{BASE_URL}/work-orders/2/finish",
    headers=headers,
    json={"produced_quantity": 10}  # Opcional: cantidad producida
)

print(f"Status: {response.status_code}")
print(f"Response: {json.dumps(response.json(), indent=2, ensure_ascii=False)}")
