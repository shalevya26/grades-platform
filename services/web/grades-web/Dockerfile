FROM nginx:1.30.6-alpine
COPY index.html /usr/share/nginx/html/index.html
# The CI passes the version it computed; the page shows it
ARG APP_VERSION=dev
RUN echo "$APP_VERSION" > /usr/share/nginx/html/version.txt
