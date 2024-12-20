#!/bin/bash
set -ex
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
get_docker_secret "DB_PASSWORD"

# if dir application or themes or file bootstrap.php or index.php under /var/www/html do not exist copy from /usr/src/omeka-s
if [ ! -d /var/www/html/application ] || [ ! -d /var/www/html/themes ] || [ ! -f /var/www/html/bootstrap.php ] || [ ! -f /var/www/html/index.php ]; then
    cp -r /usr/src/omeka-s/* /var/www/html/
    cp /usr/src/omeka-s/.htaccess /var/www/html/
fi

# mkdir -p /var/www/html/config;

# set ENV VARS in /var/www/html/config/database.ini
# set -ex; \
{ \
    echo 'user = "${DB_USER}"'; \
    echo 'password = "${DB_PASSWORD}"'; \
    echo 'dbname = "${DB_NAME}"'; \
    echo 'host = "${DB_HOST}"'; \
    echo 'port = ${DB_PORT}'; \
} > /var/www/html/config/database.ini;

# Make sure the files/ directory is writable by Apache.
chown -R www-data:www-data /var/www/html/files

exec "$@"