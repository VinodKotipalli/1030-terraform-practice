import json

def get_response():
    return {
        "message": "Hello i am from KNkk",
        "status": "success"
    }

print(json.dumps(get_response(), indent=4))