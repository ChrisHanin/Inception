FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=ES/ST=Malaga/L=Malaga/O=42/CN=chanin.42.fr"

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]


# ##########################
# Resumen mental
# Este Dockerfile:
# Crea un Debian
# Instala Nginx y OpenSSL
# Genera certificados SSL
# Copia tu configuración
# Arranca Nginx en HTTPS
# ##########################
# Quiero un ordenador vacío con Debian instalado
# → Actualiza la lista de programas disponibles.
# → Instala:
# nginx → el servidor web
# openssl → herramienta para crear certificados SSL
# → Limpia archivos temporales para que la imagen pese menos.
# 📌 Resultado: el contenedor ya tiene Nginx + OpenSSL instalados.
# 
# Crea la carpeta donde guardaremos los certificados SSL.
# -p asegura que no falle si alguna carpeta ya existe.
# 📌 Resultado: existe /etc/nginx/ssl.
# 
# Aquí se crea un certificado SSL autofirmado:
# openssl req → crear un certificado
# -x509 → certificado autofirmado (no de una autoridad oficial)
# -nodes → sin contraseña (necesario para Docker)
# -days 365 → válido durante 1 año
# -newkey rsa:2048 → clave RSA de 2048 bits
# Archivos que se generan:
# /etc/nginx/ssl/nginx.key → clave privada
# /etc/nginx/ssl/nginx.crt → certificado público
# CN=chanin.42.fr
# → El dominio del certificado (muy importante para Inception).
# 📌 Resultado: Nginx puede usar HTTPS.
# 
# Copia tu archivo de configuración de Nginx desde el proyecto
# Lo pone donde Nginx lo espera dentro del contenedor
# 📌 Resultado: Nginx usará tu configuración personalizada,
# no la por defecto.
# 
# Indica que el contenedor usará el puerto 443 (HTTPS).
# No abre el puerto por sí solo, solo lo documenta para Docker.
# 📌 El puerto real se abre en docker-compose.yml.
# 
# Arranca Nginx cuando el contenedor se ejecuta.
# daemon off; obliga a Nginx a quedarse en primer plano.
# 📌 Esto es obligatorio en Docker:
# si el proceso principal termina → el contenedor se apaga.
# ##########################
