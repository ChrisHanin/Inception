FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php-fpm php-mysql wget unzip && rm -rf /var/lib/apt/lists/*

# Crear carpeta para WordPress
WORKDIR /var/www/html

# Copiar código de WordPress
COPY www /var/www/html

# Ajustar permisos
RUN chown -R www-data:www-data /var/www/html

# Exponer PHP-FPM
EXPOSE 9000

# Crear enlace simbólico para php-fpm
RUN ln -s /usr/sbin/php-fpm7.4 /usr/sbin/php-fpm

CMD ["php-fpm7.4", "-F"]


