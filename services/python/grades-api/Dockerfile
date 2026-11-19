# Stage 1: install the dependencies into a virtual environment
FROM python:3.13-slim AS build
RUN python -m venv /venv
ENV PATH="/venv/bin:$PATH"
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Stage 2: a small runtime image that runs as a non-root user
FROM python:3.13-slim
WORKDIR /app
COPY --from=build /venv /venv
COPY app.py grades.py ./
# The CI passes the version it computed; /health reports it
ARG APP_VERSION=dev
ENV APP_VERSION=$APP_VERSION PATH="/venv/bin:$PATH"
USER 1000
EXPOSE 8000
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
