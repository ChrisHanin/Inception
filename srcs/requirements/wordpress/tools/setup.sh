#!/bin/bash

echo "Esperando a que MariaDB esté listo..."
until mysql -h"${WORDPRESS_DB_HOST%:*}" -u"${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" -e "SELECT 1" >/dev/null 2>&1; do
    echo "MariaDB no está listo aún... esperando 3 segundos"
    sleep 3
done

echo "MariaDB está listo!"

cd /var/www/html

if [ ! -f wp-config.php ]; then
    echo "Descargando WordPress..."
    wp core download --allow-root || true
    
    echo "Creando wp-config.php..."
    wp config create \
        --dbname="${WORDPRESS_DB_NAME}" \
        --dbuser="${WORDPRESS_DB_USER}" \
        --dbpass="${WORDPRESS_DB_PASSWORD}" \
        --dbhost="${WORDPRESS_DB_HOST}" \
        --allow-root
    
    echo "Instalando WordPress..."
    wp core install \
        --url="https://chanin.42.fr" \
        --title="Inception" \
        --admin_user="chanin" \
        --admin_password="chanin123" \
        --admin_email="chanin@student.42.fr" \
        --allow-root
    
    echo "WordPress instalado correctamente!"
else
    echo "WordPress ya está configurado"
fi

echo "Iniciando PHP-FPM..."
php-fpm7.4 -F