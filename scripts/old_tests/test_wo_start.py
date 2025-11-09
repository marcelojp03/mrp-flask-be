"""
Test del endpoint de start work order
"""
import requests
import json

BASE_URL = "http://localhost:4646"

# Login
login_response = requests.post(f"{BASE_URL}/api/auth/login", json={
    "email": "marcelojp03@gmail.com",
    "password": "mrp123"
})

if login_response.status_code == 200:
    token = login_response.json()['data']['access_token']
    headers = {'Authorization': f'Bearer {token}'}
    
    # Test start work order
    print("=" * 60)
    print("TEST: PUT /api/work-orders/2/start")
    print("=" * 60)
    
    response = requests.put(f"{BASE_URL}/api/work-orders/2/start", headers=headers)
    print(f"Status: {response.status_code}")
    
    try:
        print(f"Response: {json.dumps(response.json(), indent=2)}")
    except:
        print(f"Response text: {response.text}")
else:
    print(f"Login failed: {login_response.status_code}")
