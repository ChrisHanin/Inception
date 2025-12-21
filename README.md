*This project has been created as part of the 42 curriculum by chanin.*

# Inception

## Description

Inception is a system administration project that involves setting up a small infrastructure using Docker. The goal is to virtualize several Docker images by creating them within a virtual machine, following specific rules and best practices.

The project consists of:
- A Docker container with **NGINX** using TLSv1.2/1.3 only
- A Docker container with **WordPress** + **php-fpm** (without nginx)
- A Docker container with **MariaDB** (without nginx)
- A docker-network connecting all containers
- Two volumes: one for the WordPress database, another for WordPress files

The entire infrastructure is managed through Docker Compose and can be controlled via a Makefile.

## Instructions

### Prerequisites
- A Virtual Machine running Linux (Debian/Ubuntu recommended)
- Docker and Docker Compose installed
- At least 4GB RAM and 20GB disk space

### Installation

1. Clone the repository:
```bash
git clone <your-repo-url>
cd Inception
```

2. Configure your domain in `/etc/hosts`:
```bash
sudo nano /etc/hosts
```
Add this line:
```
127.0.0.1    chanin.42.fr
```

3. Create the `.env` file in `srcs/`:
```bash
nano srcs/.env
```
Add your environment variables (see `.env.example` if provided, or check `srcs/.env`).

4. Build and start the infrastructure:
```bash
make
```

5. Access the website:
- Website: `https://chanin.42.fr`
- WordPress Admin: `https://chanin.42.fr/wp-admin`
  - User: `chanin`
  - Password: `chanin123`

### Available Commands
```bash
make        # Build and start all containers
make down   # Stop all containers
make clean  # Stop containers and remove volumes
make fclean # Complete cleanup including data folders
make re     # Full rebuild (fclean + all)
```

## Resources

### Documentation
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [WordPress Documentation](https://wordpress.org/documentation/)
- [MariaDB Documentation](https://mariadb.com/kb/en/documentation/)
- [PHP-FPM Documentation](https://www.php.net/manual/en/install.fpm.php)

### Tutorials & Articles
- [Docker Networking](https://docs.docker.com/network/)
- [Docker Volumes](https://docs.docker.com/storage/volumes/)
- [SSL/TLS with NGINX](https://nginx.org/en/docs/http/configuring_https_servers.html)
- [WordPress with PHP-FPM](https://www.php.net/manual/en/install.fpm.configuration.php)

### AI Usage
AI assistance (Claude/ChatGPT) was used for:
- **Configuration troubleshooting**: Debugging Docker Compose networking issues and PHP-FPM connection problems
- **Script optimization**: Improving bash scripts for MariaDB initialization and WordPress setup
- **Documentation**: Structuring and writing clear documentation
- **Best practices**: Advice on Docker security, volume management, and TLS configuration

**Note**: All core code, Dockerfiles, and configurations were written and understood by the student. AI was used as a learning tool and debugging assistant, not as a code generator.

---

## Project Design Choices

### Docker Architecture

This project uses Docker containers instead of traditional deployment methods for several key reasons:

#### **Virtual Machines vs Docker**

| Aspect | Virtual Machines | Docker Containers |
|--------|------------------|-------------------|
| **Startup Time** | Minutes | Seconds |
| **Resource Usage** | Heavy (full OS) | Light (shared kernel) |
| **Isolation** | Complete | Process-level |
| **Portability** | Low | High |
| **Use Case** | Different OS needed | Same kernel, isolated apps |

**Why Docker for this project?**
- ✅ Faster deployment and testing
- ✅ Efficient resource usage (can run 3+ containers on 2GB RAM)
- ✅ Easy to replicate environment across different machines
- ✅ Industry-standard for microservices architecture

#### **Secrets vs Environment Variables**

| Method | Security Level | Use Case |
|--------|---------------|----------|
| **Environment Variables** | Low-Medium | Development, non-sensitive config |
| **Docker Secrets** | High | Production, passwords, API keys |

**Our choice:** Environment variables via `.env` file
- ✅ Simpler for educational project
- ✅ Easy to modify during development
- ✅ Adequate security with proper `.gitignore`
- ⚠️ **Production note:** Would use Docker Secrets for real deployment

#### **Docker Network vs Host Network**

| Type | Description | Isolation |
|------|-------------|-----------|
| **Bridge Network** | Private network for containers | ✅ Isolated |
| **Host Network** | Uses host's network directly | ❌ No isolation |

**Our choice:** Bridge network (`inception_net`)
- ✅ Containers communicate by service name (e.g., `mariadb:3306`)
- ✅ Isolated from host network (security)
- ✅ Only NGINX port 443 exposed to outside
- ✅ WordPress and MariaDB not directly accessible from internet

#### **Docker Volumes vs Bind Mounts**

| Method | Path | Management |
|--------|------|------------|
| **Docker Volumes** | Managed by Docker | Automatic |
| **Bind Mounts** | Specific host path | Manual |

**Our choice:** Bind mounts to `/home/chris/data/`
- ✅ Data persists in known location
- ✅ Easy to backup/restore
- ✅ Can directly access/modify files
- ✅ Meets project requirement (data in `/home/login/data`)

### Infrastructure Design
```
┌─────────────────────────────────────────┐
│  Host Machine (Virtual Machine)         │
│  ┌───────────────────────────────────┐  │
│  │  Docker Network (inception_net)   │  │
│  │  ┌─────────┐  ┌──────────┐        │  │
│  │  │  NGINX  │→ │WordPress │        │  │
│  │  │  :443   │  │  :9000   │        │  │
│  │  └─────────┘  └────┬─────┘        │  │
│  │                    ↓              │  │
│  │               ┌─────────┐         │  │
│  │               │ MariaDB │         │  │
│  │               │  :3306  │         │  │
│  │               └─────────┘         │  │
│  └───────────────────────────────────┘  │
│                                         │
│  Volumes (Bind Mounts):                 │
│  /home/chris/data/wordpress             │
│  /home/chris/data/mariadb               │
└─────────────────────────────────────────┘
```

**Communication flow:**
1. User → `https://chanin.42.fr:443` → NGINX container
2. NGINX → `wordpress:9000` (PHP-FPM) for `.php` files
3. WordPress → `mariadb:3306` for database queries

### Technical Decisions

- **Base Image:** Debian Bullseye (penultimate stable version as per subject)
- **Web Server:** NGINX (lightweight, efficient, industry standard)
- **PHP Execution:** PHP-FPM 7.4 (separated from web server for better performance)
- **Database:** MariaDB 10.5 (MySQL-compatible, open source)
- **SSL/TLS:** Self-signed certificate, TLSv1.2/1.3 only
- **Automation:** WP-CLI for WordPress installation and user creation