#!/bin/bash

# Iniciar PHP-FPM en background
php-fpm7.4

# Iniciar Nginx en foreground
nginx -g "daemon off;"
