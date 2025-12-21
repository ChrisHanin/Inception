# User Documentation - Inception Project

## Overview

This documentation is intended for **end users** and **system administrators** who need to operate the Inception infrastructure without necessarily understanding the technical details.

---

## What Services Are Provided?

The Inception stack provides the following services:

### 1. **Web Server (NGINX)**
- Handles all incoming HTTPS connections
- Serves static files (images, CSS, JavaScript)
- Forwards PHP requests to WordPress
- Provides SSL/TLS encryption (secure HTTPS)

### 2. **Content Management System (WordPress)**
- A fully functional WordPress website
- Allows you to create and manage blog posts, pages, and media
- Accessible via web interface
- Two types of users: Administrator and Author

### 3. **Database (MariaDB)**
- Stores all WordPress data (posts, users, settings, etc.)
- Runs in the background (not directly accessible from web)
- Data persists even if containers are restarted

---

## Starting and Stopping the Project

### Starting the Infrastructure
```bash
cd ~/Inception
make
```

**What happens:**
1. Creates necessary folders for data storage
2. Builds Docker images (first time only)
3. Starts all three containers (nginx, wordpress, mariadb)
4. WordPress automatically connects to the database

**Wait time:** 20-30 seconds for first startup

**Success indicators:**
- You see: `✔ Container nginx Created`
- You see: `✔ Container wordpress Created`
- You see: `✔ Container mariadb Created`

### Checking Service Status
```bash
docker ps
```

You should see 3 running containers:
```
CONTAINER ID   IMAGE            STATUS         PORTS                   NAMES
xxxxx          srcs-nginx       Up X minutes   0.0.0.0:443->443/tcp   nginx
xxxxx          srcs-wordpress   Up X minutes   9000/tcp               wordpress
xxxxx          srcs-mariadb     Up X minutes   3306/tcp               mariadb
```

### Stopping the Infrastructure
```bash
cd ~/Inception
make down
```

**This will:**
- Stop all containers
- Keep your data safe (WordPress files and database remain intact)

**To restart later:** Just run `make` again

---

## Accessing the Website

### Main Website

Open your web browser and go to:
```
https://chanin.42.fr
```

**⚠️ Security Warning:**
You will see a browser warning about the SSL certificate being "not secure" or "self-signed". This is **normal** for development environments.

**How to proceed:**
- **Chrome/Edge:** Click "Advanced" → "Proceed to chanin.42.fr (unsafe)"
- **Firefox:** Click "Advanced" → "Accept the Risk and Continue"
- **Safari:** Click "Show Details" → "visit this website"

Once you accept the warning, you'll see the WordPress homepage.

---

## Accessing the Administration Panel

### WordPress Admin Panel
```
URL: https://chanin.42.fr/wp-admin
```

### Available Credentials

#### Administrator Account
- **Username:** `chanin`
- **Password:** `chanin123`
- **Permissions:** Full control (create/edit/delete posts, manage users, install themes/plugins, modify settings)

#### Author Account
- **Username:** `wpuser`
- **Password:** `wpuser123`
- **Permissions:** Limited (can only create and edit own posts)

**⚠️ Security Note:** These are default credentials for development. In production, you should change these immediately.

---

## Managing Credentials

### Where Credentials Are Stored

All sensitive credentials are stored in:
```
~/Inception/srcs/.env
```

### Viewing Current Credentials
```bash
cat ~/Inception/srcs/.env
```

You'll see:
```bash
MYSQL_ROOT_PASSWORD=rootpass123
MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
MYSQL_PASSWORD=wp_pass
```

### Changing Credentials

**⚠️ Important:** Changing credentials requires rebuilding the entire infrastructure.

1. Stop the infrastructure:
```bash
make fclean
```

2. Edit the `.env` file:
```bash
nano ~/Inception/srcs/.env
```

3. Modify the values (keep the same format)

4. Rebuild everything:
```bash
make
```

**Note:** This will create a fresh database with new credentials.

---

## Verifying Services Are Running Correctly

### Quick Health Check
```bash
cd ~/Inception
docker ps
```

**Expected output:** 3 containers with status "Up"

### Detailed Service Checks

#### 1. Check NGINX (Web Server)
```bash
curl -k https://chanin.42.fr
```

**Expected:** HTML output of the WordPress homepage

#### 2. Check WordPress Users
```bash
docker exec -it wordpress wp user list --allow-root
```

**Expected output:**
```
+----+------------+---------------+
| ID | user_login | roles         |
+----+------------+---------------+
| 1  | chanin     | administrator |
| 2  | wpuser     | author        |
+----+------------+---------------+
```

#### 3. Check MariaDB (Database)
```bash
docker exec -it mariadb mysql -u wp_user -pwp_pass -e "SHOW DATABASES;"
```

**Expected output:**
```
+--------------------+
| Database           |
+--------------------+
| wordpress          |
+--------------------+
```

#### 4. Check Data Persistence
```bash
ls -lh /home/chris/data/wordpress
ls -lh /home/chris/data/mariadb
```

**Expected:** Multiple files and folders in both directories

---

## Common Issues and Solutions

### Issue: "This site can't be reached"

**Cause:** Domain not configured in `/etc/hosts`

**Solution:**
```bash
sudo nano /etc/hosts
```
Add this line:
```
127.0.0.1    chanin.42.fr
```

---

### Issue: "Connection refused"

**Cause:** Containers are not running

**Solution:**
```bash
cd ~/Inception
make
```

Wait 30 seconds and try again.

---

### Issue: WordPress shows "Error establishing database connection"

**Cause:** MariaDB container is not ready yet

**Solution:** Wait 30 seconds and refresh the page. If it persists:
```bash
make down
make
```

---

### Issue: Can't log in to WordPress admin

**Cause:** Wrong credentials or WordPress not fully initialized

**Solution:**
1. Verify credentials in `srcs/.env`
2. Reset WordPress:
```bash
make fclean
make
```

---

## Backup and Restore

### Creating a Backup

All your data is stored in:
```
/home/chris/data/wordpress    (Website files)
/home/chris/data/mariadb      (Database)
```

**To backup:**
```bash
cd /home/chris
tar -czf inception-backup-$(date +%Y%m%d).tar.gz data/
```

### Restoring from Backup

1. Stop the infrastructure:
```bash
make down
```

2. Remove current data:
```bash
sudo rm -rf /home/chris/data/*
```

3. Extract backup:
```bash
cd /home/chris
tar -xzf inception-backup-YYYYMMDD.tar.gz
```

4. Start the infrastructure:
```bash
make
```

---

## Maintenance

### Viewing Logs

**All services:**
```bash
docker compose -f ~/Inception/srcs/docker-compose.yml logs
```

**Specific service:**
```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```

**Follow logs in real-time:**
```bash
docker compose -f ~/Inception/srcs/docker-compose.yml logs -f
```

---

## Shutdown Procedures

### Graceful Shutdown
```bash
cd ~/Inception
make down
```
**Keeps:** All data (WordPress content, database)

### Complete Cleanup
```bash
cd ~/Inception
make fclean
```
**⚠️ WARNING:** This **deletes all data**. Use only if you want to start fresh.

---

## Support

If you encounter issues not covered here:

1. Check the logs: `docker compose logs -f`
2. Verify all containers are running: `docker ps`
3. Consult the `DEV_DOC.md` for technical details
4. Contact your system administrator