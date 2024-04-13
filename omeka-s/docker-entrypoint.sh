#!/bin/bash
# set ENV VARS in /var/www/html/config/database.ini
mkdir -p /var/www/html/config;
set -ex; \
  { \
      echo 'user = "${DB_USER}"'; \
      echo 'password = "${DB_PASSWORD}"'; \
      echo 'dbname = "${DB_NAME}"'; \
      echo 'host = "${DB_HOST}"'; \
      echo 'port = ${DB_PORT}'; \
  } > /var/www/html/config/database.ini;

exec "$@"