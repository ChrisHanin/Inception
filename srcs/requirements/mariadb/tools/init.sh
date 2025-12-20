#!/bin/bash

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Inicializando base de datos..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

echo "Iniciando MariaDB temporalmente..."
mysqld_safe --datadir=/var/lib/mysql &

sleep 5

echo "Esperando a que MariaDB esté activo..."
until mysqladmin ping --silent; do
    echo "Esperando..."
    sleep 2
done

echo "Configurando base de datos..."
mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mysql -e "FLUSH PRIVILEGES;"

echo "Deteniendo MariaDB temporal..."
mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

echo "Iniciando MariaDB en modo normal..."
exec mysqld --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0