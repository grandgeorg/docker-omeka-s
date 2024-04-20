FROM php:8.2-apache

ARG DB_USER
ARG DB_PASSWORD
ARG DB_NAME
ARG DB_HOST
ARG DB_PORT

# Set DB environment variables
ENV DB_USER=$DB_USER
ENV DB_PASSWORD=$DB_PASSWORD
ENV DB_NAME=$DB_NAME
ENV DB_HOST=$DB_HOST
ENV DB_PORT=$DB_PORT

# set download link with version
ARG OMEKA_S_VERSION=4.0.4
ENV OMEKA_S_VERSION=$OMEKA_S_VERSION
ENV OMEKA_DOWNLOAD_URL=https://github.com/omeka/omeka-s/releases/download/v$OMEKA_S_VERSION/omeka-s-$OMEKA_S_VERSION.zip

# Install dependencies
RUN set -ex; \
    \
    savedAptMark="$(apt-mark showmanual)"; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libbz2-dev \
        libfreetype6-dev \
        libjpeg-dev \
        libpng-dev \
        libwebp-dev \
        libxpm-dev \
        libzip-dev \
        imagemagick \
        unzip \
        libmagickwand-dev \
    ; \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp --with-xpm; \
    docker-php-ext-install -j "$(nproc)" \
        bz2 \
        gd \
        mysqli \
        opcache \
        zip \
        bcmath \
        pdo \
        pdo_mysql \
    ; \
    \
    # Install imagick
    mkdir -p /usr/src/php/ext/imagick; \
    curl -fsSL https://pecl.php.net/get/imagick-3.7.0.tgz | tar xvz -C "/usr/src/php/ext/imagick" --strip 1; \
    docker-php-ext-install imagick; \
    \
    # Enable the required Apache modules
    a2enmod rewrite; \
    a2enmod remoteip; \
    \
    # Download and extract Omeka-S
    curl -L $OMEKA_DOWNLOAD_URL -o /var/www/html/omeka-s.zip; \
    unzip /var/www/html/omeka-s.zip -d /var/www/html; \
    mv /var/www/html/omeka-s/* /var/www/html/; \
    mv /var/www/html/omeka-s/.htaccess /var/www/html/; \
    rm /var/www/html/omeka-s.zip; \
    rm -rf /var/www/html/omeka-s; \
    \
    # Clean up
    # reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
    apt-mark auto '.*' > /dev/null; \
    # keep imagemagick
    apt-mark manual imagemagick; \
    # keep libmagickwand-dev
    apt-mark manual libmagickwand-dev; \
    apt-mark manual $savedAptMark; \
    extdir="$(php -r 'echo ini_get("extension_dir");')"; \
    ldd "$extdir"/*.so \
        | awk '/=>/ { so = $(NF-1); if (index(so, "/usr/local/") == 1) { next }; gsub("^/(usr/)?", "", so); print so }' \
        | sort -u \
        | xargs -r dpkg-query -S \
        | cut -d: -f1 \
        | sort -u \
        | xargs -rt apt-mark manual; \
    \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*;


# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
ENV MAX_EXECUTION_TIME 600
ENV MEMORY_LIMIT 512M
ENV UPLOAD_LIMIT 512M
ENV TZ "Europe/Berlin"
RUN set -ex; \
    { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=2'; \
        echo 'opcache.fast_shutdown=1'; \
    } > $PHP_INI_DIR/conf.d/opcache-recommended.ini; \
    { \
        echo 'session.cookie_httponly=1'; \
        echo 'session.use_strict_mode=1'; \
    } > $PHP_INI_DIR/conf.d/session-strict.ini; \
    { \
        echo 'allow_url_fopen=Off'; \
        echo 'max_execution_time=${MAX_EXECUTION_TIME}'; \
        echo 'max_input_vars=10000'; \
        echo 'memory_limit=${MEMORY_LIMIT}'; \
        echo 'post_max_size=${UPLOAD_LIMIT}'; \
        echo 'upload_max_filesize=${UPLOAD_LIMIT}'; \
        echo 'date.timezone=${TZ}'; \
    } > $PHP_INI_DIR/conf.d/omeka-s.ini;

WORKDIR /var/www/html

# Write config/database.ini file
RUN set -ex; \
    { \
        echo 'user = "${DB_USER}"'; \
        echo 'password = "${DB_PASSWORD}"'; \
        echo 'dbname = "${DB_NAME}"'; \
        echo 'host = "${DB_HOST}"'; \
        echo 'port = ${DB_PORT}'; \
    } > /var/www/html/config/database.ini;

# Make sure the files/ directory is writable by Apache.
RUN chown -R www-data:www-data /var/www/html/files/

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]

# Start the Apache service
CMD ["apache2-foreground"]

# Build the image
# docker build -f Dockerfile -t solarbaypilot/omeka-s .