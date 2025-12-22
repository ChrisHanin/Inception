FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx \
    php7.4-fpm \
    php7.4-mysql \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html /run/php

# Descargar Adminer
RUN wget -O /var/www/html/index.php https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php

# Configuración de nginx
COPY conf/nginx.conf /etc/nginx/sites-available/default

EXPOSE 8081

COPY tools/start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]
