# Developer Documentation - Inception Project

## Overview

This documentation is intended for **developers** who need to understand the technical architecture, build process, and maintenance procedures of the Inception infrastructure.

---

## 1. Environment Setup

### Prerequisites

Before starting, ensure your development environment has the following installed:

| Tool | Minimum Version | Check Command |
|------|-----------------|---------------|
| Docker Engine | v20.10+ | `docker --version` |
| Docker Compose | v2.0+ | `docker compose version` |
| Make | any | `make --version` |
| Git | any | `git --version` |

### Project Structure

```
Inception/
├── Makefile
├── USER_DOC.md
├── DEV_DOC.md
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        ├── nginx/
        │   ├── Dockerfile
        │   └── conf/
        └── wordpress/
            ├── Dockerfile
            ├── conf/
            └── tools/
```

### Configuration Files

The project relies on environment variables defined in `srcs/.env`.

**Required Variables:**

Create a `.env` file in `srcs/` with the following structure:

```bash
# Domain
DOMAIN_NAME=chanin.42.fr

# MySQL Setup
MYSQL_ROOT_PASSWORD=rootpass123
MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
MYSQL_PASSWORD=wp_pass

# WordPress Admin
WP_ADMIN_USER=chanin
WP_ADMIN_PASSWORD=chanin123
WP_ADMIN_EMAIL=chanin@student.42.fr

# WordPress Author
WP_USER=wpuser
WP_USER_PASSWORD=wpuser123
WP_USER_EMAIL=wpuser@student.42.fr
```

### Host Configuration

To access the site via the domain name locally, update your `/etc/hosts` file:

```bash
sudo sh -c 'echo "127.0.0.1 chanin.42.fr" >> /etc/hosts'
```

---

## 2. Build and Launch

The project uses a `Makefile` to abstract Docker Compose commands.

### Available Make Targets

| Command | Description |
|---------|-------------|
| `make` | Build and start all containers |
| `make down` | Stop and remove containers |
| `make stop` | Stop containers without removing |
| `make re` | Rebuild and restart everything |
| `make fclean` | Full cleanup (containers, images, volumes, data) |

### Standard Launch

```bash
cd ~/Inception
make
```

This executes:
1. Creates data directories at `/home/chris/data/`
2. Runs `docker compose -f ./srcs/docker-compose.yml up -d --build`

### Rebuild from Scratch

```bash
make fclean
make
```

---

## 3. Container Management

### Service Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Host Machine                          │
│  ┌─────────────────────────────────────────────────┐    │
│  │              Docker Network: inception           │    │
│  │                                                  │    │
│  │  ┌──────────┐   ┌──────────┐   ┌──────────┐    │    │
│  │  │  NGINX   │──▶│WordPress │──▶│ MariaDB  │    │    │
│  │  │  :443    │   │  :9000   │   │  :3306   │    │    │
│  │  └──────────┘   └──────────┘   └──────────┘    │    │
│  │       │              │              │          │    │
│  └───────┼──────────────┼──────────────┼──────────┘    │
│          │              │              │                │
│          ▼              ▼              ▼                │
│     Port 443      wp-volume       db-volume            │
│                        │              │                 │
└────────────────────────┼──────────────┼─────────────────┘
                         ▼              ▼
              /home/chris/data/  /home/chris/data/
                 wordpress/         mariadb/
```

### Container Details

| Container | Base Image | Internal Port | Volume |
|-----------|------------|---------------|--------|
| nginx | Alpine | 443 | wp-volume |
| wordpress | Alpine | 9000 | wp-volume |
| mariadb | Alpine | 3306 | db-volume |

### Useful Commands

**View running containers:**
```bash
docker ps
```

**View logs:**
```bash
# All services
docker compose -f ~/Inception/srcs/docker-compose.yml logs

# Specific service with follow
docker logs -f nginx
docker logs -f wordpress
docker logs -f mariadb
```

**Access container shell:**
```bash
docker exec -it wordpress /bin/sh
docker exec -it mariadb /bin/sh
docker exec -it nginx /bin/sh
```

**Inspect network:**
```bash
docker network inspect srcs_inception
```

---

## 4. Data Persistence & Volumes

### Storage Locations

| Data Type | Host Path | Container Path |
|-----------|-----------|----------------|
| WordPress files | `/home/chris/data/wordpress` | `/var/www/html` |
| Database files | `/home/chris/data/mariadb` | `/var/lib/mysql` |

### Volume Management

**List volumes:**
```bash
docker volume ls
```

**Inspect a volume:**
```bash
docker volume inspect srcs_wp-volume
docker volume inspect srcs_db-volume
```

**Remove volumes (destructive):**
```bash
docker volume rm srcs_wp-volume srcs_db-volume
```

### Cleaning Data

| Action | Command | Effect |
|--------|---------|--------|
| Stop containers | `make down` | Keeps all data |
| Full cleanup | `make fclean` | Deletes everything |
| Prune system | `docker system prune -a` | Removes unused objects |

---

## 5. Dockerfile Guidelines

Each service has its own `Dockerfile` in `srcs/requirements/<service>/`.

### Common Requirements

- Base image: **Alpine** or **Debian** (penultimate stable)
- No use of pre-built images (except base OS)
- No infinite loops (`tail -f`, `sleep infinity`, etc.)
- PID 1 must be the main service process

### MariaDB Dockerfile Key Points

```dockerfile
# Located at: srcs/requirements/mariadb/Dockerfile
FROM alpine:3.18

RUN apk update && apk add --no-cache mariadb mariadb-client

COPY conf/my.cnf /etc/my.cnf
COPY tools/init_db.sh /init_db.sh

ENTRYPOINT ["/init_db.sh"]
```

### WordPress Dockerfile Key Points

```dockerfile
# Located at: srcs/requirements/wordpress/Dockerfile
FROM alpine:3.18

RUN apk update && apk add --no-cache \
    php81 php81-fpm php81-mysqli php81-phar \
    php81-mbstring php81-xml php81-gd wget

COPY conf/www.conf /etc/php81/php-fpm.d/www.conf
COPY tools/init_wp.sh /init_wp.sh

ENTRYPOINT ["/init_wp.sh"]
```

### NGINX Dockerfile Key Points

```dockerfile
# Located at: srcs/requirements/nginx/Dockerfile
FROM alpine:3.18

RUN apk update && apk add --no-cache nginx openssl

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/generate_ssl.sh /generate_ssl.sh

ENTRYPOINT ["/generate_ssl.sh"]
CMD ["nginx", "-g", "daemon off;"]
```

---

## 6. Docker Compose Configuration

### Network Configuration

```yaml
networks:
  inception:
    driver: bridge
```

### Volume Configuration

```yaml
volumes:
  wp-volume:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/chris/data/wordpress
  db-volume:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/chris/data/mariadb
```

### Service Dependencies

```yaml
services:
  nginx:
    depends_on:
      - wordpress
  wordpress:
    depends_on:
      - mariadb
```

---

## 7. Debugging

### Common Issues

| Problem | Diagnostic Command | Solution |
|---------|-------------------|----------|
| Container won't start | `docker logs <container>` | Check entrypoint script |
| Database connection error | `docker exec -it mariadb mysql -u root -p` | Verify credentials in `.env` |
| 502 Bad Gateway | `docker exec -it wordpress ps aux` | Check PHP-FPM is running |
| SSL errors | `openssl s_client -connect chanin.42.fr:443` | Regenerate certificates |

### Health Checks

```bash
# Test NGINX
curl -k https://chanin.42.fr

# Test WordPress PHP
docker exec -it wordpress php -v

# Test MariaDB connection
docker exec -it mariadb mysql -u wp_user -pwp_pass -e "SELECT 1;"

# Test WordPress CLI
docker exec -it wordpress wp user list --allow-root
```

### Reset Everything

```bash
# Full reset
make fclean
sudo rm -rf /home/chris/data/*
make
```

---

## 8. Security Considerations

- SSL/TLS certificates are self-signed (development only)
- Credentials stored in `.env` file (not committed to git)
- Add `.env` to `.gitignore`:
  ```bash
  echo "srcs/.env" >> .gitignore
  ```
- MariaDB only accessible within Docker network
- Only port 443 exposed to host

---

## 9. References

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Reference](https://docs.docker.com/compose/)
- [WordPress CLI](https://developer.wordpress.org/cli/commands/)
- [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)
- [NGINX Documentation](https://nginx.org/en/docs/)