FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    php7.4-curl \
    php7.4-gd \
    php7.4-xml \
    php7.4-mbstring \
    php7.4-zip \
    wget \
    curl \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php

RUN sed -i 's|listen = .*|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf

WORKDIR /var/www/html

RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    mv wordpress/* . && \
    rm -rf wordpress latest.tar.gz

RUN chown -R www-data:www-data /var/www/html

EXPOSE 9000

CMD ["php-fpm7.4", "-F"]