/*
	Crea una base de datos llamada wordpress.

	El contenedor puede reiniciarse
	El volumen persiste
	Sin esto, el script fallaría al segundo arranque
*/
CREATE DATABASE IF NOT EXISTS wordpress;

/*
	Crea un usuario de base de datos:

	Usuario: wp_user
	Contraseña: wp_pass
	Host: %

	% significa “desde cualquier host”
	En Docker:
	WordPress está en otro contenedor
	No entra desde localhost
	Por eso NO vale 'wp_user'@'localhost'
*/
/*
	Da permisos completos a wp_user solo sobre: wordpress.*
*/
CREATE USER IF NOT EXISTS 'wp_user'@'%' IDENTIFIED BY 'wp_pass';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'%';

/*
	Fuerza a MariaDB a recargar los permisos en memoria

	¿Es obligatorio?
	Técnicamente:
	GRANT ya recarga permisos
	Prácticamente:
	Se pone siempre
	Evita comportamientos raros
	En scripts de inicialización es buena práctica
*/
FLUSH PRIVILEGES;


/*
	¿Qué es un archivo .sql?

	Un archivo SQL es simplemente un archivo de texto que contiene instrucciones SQL, 
	es decir, órdenes para una base de datos (MySQL / MariaDB en tu caso).

	👉 No es un programa ejecutable
	👉 No es código C
	👉 No “hace nada” por sí solo

	Solo dice qué debe hacer la base de datos cuando alguien lo ejecuta.

	Sirve para:
	Crear bases de datos
	Crear usuarios
	Dar permisos
	Crear tablas
	Insertar datos iniciales

	Eso no crea nada hasta que:
	MariaDB lo lea
	y lo ejecute
*/