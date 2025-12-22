FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Descargar Portainer (versión compatible)
RUN wget -O /tmp/portainer.tar.gz https://github.com/portainer/portainer/releases/download/2.11.1/portainer-2.11.1-linux-amd64.tar.gz && \
    tar -xzf /tmp/portainer.tar.gz -C /opt && \
    rm /tmp/portainer.tar.gz

EXPOSE 9000

WORKDIR /opt/portainer

CMD ["./portainer"]
