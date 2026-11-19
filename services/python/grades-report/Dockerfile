FROM python:3.13-slim
WORKDIR /app
COPY report.py ./
COPY data/ data/
ARG APP_VERSION=dev
ENV APP_VERSION=$APP_VERSION
USER 1000
CMD ["python", "report.py", "data/grades.csv"]
