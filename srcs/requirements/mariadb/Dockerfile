FROM debian:bullseye

RUN apt-get update && apt-get install -y mariadb-server && rm -rf /var/lib/apt/lists/*

# Copiar script de inicialización
COPY conf/ /docker-entrypoint-initdb.d/

# Exponer puerto
EXPOSE 3306

# Ejecutar MariaDB en foreground
CMD ["mysqld_safe"]
