FROM python:3.11-slim
RUN pip install --no-cache-dir requests
WORKDIR /app
COPY push_notification.py .
ENTRYPOINT ["python", "push_notification.py"]
