CREATE DATABASE IF NOT EXISTS wordpress;

CREATE USER IF NOT EXISTS 'wp_user'@'%' IDENTIFIED BY 'wp_pass';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'%';

CREATE USER IF NOT EXISTS 'chanin_admin'@'%' IDENTIFIED BY 'securepass';
GRANT ALL PRIVILEGES ON wordpress.* TO 'chanin_admin'@'%';

FLUSH PRIVILEGES;
