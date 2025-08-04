# ntfy-pub-sub-service

This repository shows a minimal local setup of the [ntfy](https://github.com/binwiederhier/ntfy/tree/main) server and a small Python backend script that publishes a message to a topic. You can subscribe to the same topic from the official ntfy mobile app to verify push notifications.

## Services

The included `docker-compose.yml` defines two services that share the same Docker network:

* **ntfy** – runs the notification server and exposes port `8080` on the host.
* **backend** – a Python container with a script that sends one message to ntfy.

## Prerequisites

* Docker and Docker Compose installed locally.
* A phone with the ntfy mobile app installed (available on Android and iOS).
* The phone must be able to reach your computer on the local network (e.g. same Wi‑Fi).

## Usage

1. **Start the services**

   ```bash
   docker compose up -d
   ```

   This launches the ntfy server. The backend container only runs when invoked explicitly.

2. **Subscribe from the mobile app**

   Open the ntfy app on your phone and add a new subscription:

   * Base URL: `http://<your-computer-ip>:8080`
   * Topic: `test-topic`

   You can find the computer's IP address with `ip addr` (Linux) or `ipconfig` (Windows). Use the address reachable from your phone's network.

3. **Send a test notification**

   Run the backend script inside its container:

   ```bash
   docker compose run --rm backend
   ```

   The script posts the message `"Hello from backend!"` to the `test-topic` topic. You should see the notification in the mobile app.

   To send a different message or topic:

   ```bash
   docker compose run --rm \
     -e NTFY_TOPIC=mytopic \
     -e NTFY_MESSAGE="Custom text" \
     -e NTFY_TITLE="Optional title" \
     backend
   ```

4. **Stop the stack**

   ```bash
   docker compose down
   ```

## Notes

* Notifications are sent via plain HTTP (`http://`). This setup is intended for local testing only.
* The ntfy service stores messages in a Docker volume named `ntfy-cache`.
