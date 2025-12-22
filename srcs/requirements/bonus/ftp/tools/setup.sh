#!/bin/bash

# Crear usuario FTP si no existe
if ! id "${FTP_USER}" &>/dev/null; then
    echo "Creando usuario FTP: ${FTP_USER}"
    useradd -m -d /var/www/html -s /bin/bash "${FTP_USER}"
    echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd
    chown -R "${FTP_USER}:${FTP_USER}" /var/www/html
fi

echo "Iniciando servidor FTP..."
/usr/sbin/vsftpd /etc/vsftpd.conf
