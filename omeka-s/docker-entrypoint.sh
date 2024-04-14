#!/bin/bash

get_docker_secret() {
    local env_var="${1}"
    local env_var_file="${env_var}_FILE"

    # Check if the variable with name $env_var_file (which is $DB_USER_FILE for example)
    # is not empty and export $DB_USER as the password in the Docker secrets file

    if [[ -n "${!env_var_file}" ]]; then
        export "${env_var}"="$(cat "${!env_var_file}")"
    fi
}

# Get the Docker secrets
get_docker_secret "DB_USER"
get_docker_secret "DB_PASSWORD"
get_docker_secret "DB_NAME"
get_docker_secret "DB_HOST"
get_docker_secret "DB_PORT"

mkdir -p /var/www/html/config;

# set ENV VARS in /var/www/html/config/database.ini
set -ex; \
  { \
      echo 'user = "${DB_USER}"'; \
      echo 'password = "${DB_PASSWORD}"'; \
      echo 'dbname = "${DB_NAME}"'; \
      echo 'host = "${DB_HOST}"'; \
      echo 'port = ${DB_PORT}'; \
  } > /var/www/html/config/database.ini;

exec "$@"