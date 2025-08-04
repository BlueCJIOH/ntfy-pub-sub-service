import os
import requests

topic = os.environ.get("NTFY_TOPIC", "test-topic")
server = os.environ.get("NTFY_SERVER", "http://ntfy:80")
title = os.environ.get("NTFY_TITLE", "Backend test")
message = os.environ.get("NTFY_MESSAGE", "Hello from backend!")

response = requests.post(f"{server}/{topic}", data=message.encode("utf-8"),
                          headers={"Title": title})
response.raise_for_status()
print(f"Sent {message!r} to {topic} with status {response.status_code}")
