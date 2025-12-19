FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Copiar configuración y certificados
COPY conf /etc/nginx/conf

# Exponer puerto 443
EXPOSE 443

# Reiniciar nginx en foreground
CMD ["nginx", "-g", "daemon off;"]
