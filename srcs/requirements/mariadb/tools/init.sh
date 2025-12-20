#!/bin/bash

service mariadb start

sleep 5

mysql < /docker-entrypoint-initdb.d/init.sql

mysqladmin -u root password "${MYSQL_ROOT_PASSWORD}"

service mariadb stop

exec mysqld_safe