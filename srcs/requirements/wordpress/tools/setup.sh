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


# ################################
# Esperar a que MariaDB esté lista
# Descargar y configurar WordPress (solo la primera vez)
# Arrancar PHP-FPM
# 
# Resumen mental
# Este script:
# Espera a que MariaDB funcione
# Descarga WordPress (solo la primera vez)
# Crea la configuración automáticamente
# Instala el sitio
# Arranca PHP-FPM
# ################################
# mysql → intenta conectarse a la base de datos
# -h"${WORDPRESS_DB_HOST%:*}"
# WORDPRESS_DB_HOST suele ser mariadb:3306
# %:* elimina el puerto → queda solo mariadb
# -u usuario de la base de datos
# -p contraseña
# -e "SELECT 1" → ejecuta una consulta simple
# >/dev/null 2>&1 → oculta errores y salida
# 📌 Mientras falle la conexión, el script se queda esperando.
# 
# Va a la carpeta donde vive WordPress
# Es el mismo directorio que comparte Nginx
# 
# Comprueba si WordPress ya está configurado
# wp-config.php es el archivo más importante de WordPress
# 📌 Esto evita reinstalar WordPress cada vez que el contenedor reinicia.
# 
# Descarga WordPress usando WP-CLI
# --allow-root → Docker suele ejecutar como root
# || true → evita que el script se rompa si ya estaba descargado
# 
# Aquí se crea automáticamente el archivo wp-config.php:
# Nombre de la base de datos
# Usuario
# Contraseña
# Host (mariadb)
# 📌 Todo viene de variables de entorno definidas en docker-compose.yml.
# 
# Instalar WordPress
# Esta parte crea el sitio web en sí:
# Dominio del sitio (debe coincidir con Nginx)
# Título del sitio
# Usuario administrador del panel de WordPress
# Necesario en Docker
# 
# Arranca PHP-FPM
# -F → primer plano (obligatorio en Docker)
# 📌 Este proceso mantiene el contenedor vivo.
# ################################
