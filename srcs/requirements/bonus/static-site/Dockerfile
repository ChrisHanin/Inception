FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx \
    && rm -rf /var/lib/apt/lists/*

# Copiar archivos del sitio
COPY www/ /var/www/html/

# Copiar configuración de nginx
COPY conf/nginx.conf /etc/nginx/sites-available/default

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]
