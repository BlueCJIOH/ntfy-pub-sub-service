# ntfy-pub-sub-service

This repository shows a minimal local setup of the [ntfy](https://github.com/binwiederhier/ntfy/tree/main) server and a small Python backend script that publishes a message to a topic. You can subscribe to the same topic from the official ntfy mobile app or from the included Flutter client to verify the notifications.

## Services

The included `docker-compose.yml` defines two services that share the same Docker network:

* **ntfy** – runs the notification server and exposes port `8080` on the host.
* **backend** – a Python container with a script that sends one message to ntfy.

## Prerequisites

* Docker and Docker Compose installed locally.
* A phone or emulator that can reach your computer on the local network (e.g. same Wi‑Fi). Install the ntfy mobile app (Android/iOS) or run the sample Flutter client provided here.

## Usage

1. **Start the services**

   ```bash
   docker compose up -d
   ```

   This launches the ntfy server. The backend container only runs when invoked explicitly.

2. **Subscribe from a client**

   You can use the official ntfy app or run the sample Flutter client:

   * **Official app** – open the ntfy app on your phone and add a new subscription:

     * Base URL: `http://<your-computer-ip>:8080`
     * Topic: `test-topic`

     You can find the computer's IP address with `ip addr` (Linux) or `ipconfig` (Windows). Use the address reachable from your phone's network.

   * **Flutter client** – follow [the instructions below](#flutter-sample-client) to run the app, passing the same server URL and topic.

3. **Send a test notification**

   Run the backend script inside its container:

   ```bash
   docker compose run --rm backend
   ```

   The script posts the message `"Hello from backend!"` to the `test-topic` topic. You should see the notification in your client.

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

## Flutter sample client

A minimal Flutter app is included in the `client/` directory. It subscribes to the same ntfy topic and shows incoming messages in a list.

### Requirements

* Flutter SDK installed
* A device or emulator that can reach the ntfy server

### Run the client

1. Fetch dependencies:

   ```bash
   cd client
   flutter pub get
   ```

2. Launch the app, pointing it to your ntfy server and topic:

   ```bash
   flutter run --dart-define=SERVER=http://<your-computer-ip>:8080 --dart-define=TOPIC=test-topic
   ```

   Replace `<your-computer-ip>` with the address reachable from your device. Messages published to the topic will appear in the app.

## Notes

* Notifications are sent via plain HTTP (`http://`). This setup is intended for local testing only.
* The ntfy service stores messages in a Docker volume named `ntfy-cache`.
* Custom clients receive messages only while running; background push support requires integrating a platform push service or using the official ntfy app.
