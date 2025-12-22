FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    vsftpd \
    && rm -rf /var/lib/apt/lists/*

# Crear directorio para configuración
RUN mkdir -p /var/run/vsftpd/empty

# Copiar configuración y script
COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 21 21100-21110

CMD ["/usr/local/bin/setup.sh"]
