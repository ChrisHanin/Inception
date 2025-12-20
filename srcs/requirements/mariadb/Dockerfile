FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld /var/lib/mysql

COPY tools/init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 3306

CMD ["/usr/local/bin/init.sh"]

#################################################
# Este Dockerfile:
# Parte de Debian limpio
# Instala MariaDB
# Prepara directorios críticos
# Copia un script propio (no automático)
# Arranca MariaDB de forma controlada

# Este Dockerfile parte de Debian, 
# instala MariaDB y limpia archivos temporales. 
# Luego crea las carpetas que MariaDB necesita 
# y asegura que el usuario mysql tenga permisos. 
# Copia un script (init.sh) que inicializa la base de datos y usuarios, 
# lo hace ejecutable, expone el puerto 3306, 
# y al arrancar el contenedor, 
# ejecuta ese script para que MariaDB quede listo y accesible 
# desde otros servicios.
#################################################
