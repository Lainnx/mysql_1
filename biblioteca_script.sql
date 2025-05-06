CREATE DATABASE IF NOT EXISTS biblioteca;

-- DROP DATABASE IF EXISTS biblioteca;

USE biblioteca;

CREATE TABLE IF NOT EXISTS libros(
id_libro int AUTO_INCREMENT NOT NULL PRIMARY KEY,
titulo_libro VARCHAR(100) NOT NULL,
id_autor INT NOT NULL,
editorial varchar(50) not null,
ejemplares_stock smallint -- ,
-- PRIMARY KEY (id_libro) en vez de ponerlo arriba
);

INSERT INTO autores VALUES (1,"Jules","Verne");	-- cuando no especificas los campos seran todos en el orden en que los pusiste
INSERT INTO autores(nombre_autor, apellido_autor) -- mas común usar este metodo
VALUES ("Isaac","Asimov"),("Stanislaw","Lem");
INSERT INTO autores(nombre_autor, apellido_autor)
VALUES ("Stephen","King");

SELECT * FROM autores;

-- Obtener los nombres de los autores que empiezan por S
SELECT nombre_autor, apellido_autor 
FROM autores
WHERE nombre_autor LIKE "S%"; -- % significa cualquier cosa que venga después

-- Obtener los autores cuyo nombre contiene 5 letras
SELECT nombre_autor, apellido_autor
FROM autores
WHERE nombre_autor LIKE "_____";	-- "_" cualquier caracter

SELECT COUNT(*) as "cantidad de autores"	-- cuenta filas, el as es el titulo de la columna resultado, entre comillas porque texto con espacios
FROM autores;

INSERT INTO autores(nombre_autor, apellido_autor)
VALUES ("Pepe","Vargas Llosa");

UPDATE autores SET nombre_autor = "Mario" WHERE apellido_autor="Vargas Llosa";

DELETE FROM autores WHERE apellido_autor="Vargas Llosa";
DELETE FROM autores WHERE id_autor=4 or id_autor=5;

-- ordenar por el apellido, ascendente por defecto(a-z), no modifica solo muestra
SELECT apellido_autor, nombre_autor
FROM autores
ORDER BY apellido_autor
LIMIT 1	-- que solo muestre el primero, en otros sistemas funciona de otra manera(poniendo top 1 arriba)
;

-- concatenando la salida
SELECT CONCAT(apellido_autor,", ", nombre_autor) AS autor
FROM autores
ORDER BY apellido_autor
LIMIT 1	-- que solo muestre el primero, en otros sistemas funciona de otra manera(poniendo top 1 arriba)
;

SELECT CONCAT_WS(", ",UPPER(apellido_autor), nombre_autor) AS autor	-- white space, indicamos lo que queremos que use entre medio y despues concatenamos todo lo que necesitemos, LAS FUNCIONES SE PUEDEN ANIDAR
FROM autores
ORDER BY apellido_autor DESC, nombre_autor ASC	-- se pueden concatenar diferentes tipos de orden, si encuentra dos caracteristicas iguales usará el segundo orden
-- LIMIT 1	-- que solo muestre el primero, en otros sistemas funciona de otra manera(poniendo top 1 arriba)
;

DESCRIBE libros;	-- describe la tabla libros
describe autores_libros;

ALTER TABLE libros 
DROP COLUMN id_autor;


-- INSERTS LIBROS

INSERT INTO libros (titulo_libro, editorial, ejemplares_stock) 
VALUES("La vuelta al mundo en 80 días", "Taurus", 5),
("De la tierra a la Luna", "Taurus", 3),
("Yo, robot", "Gredos", 3),
("Solaris", "Alfahuara", 5);

-- VINCULACIÓN RELACIONES AUTORES_LIBROS

INSERT INTO autores_libros (id_autor, id_libro)
VALUES(1,1),(1,2),(2,3),(3,4);

-- necesitamos tabla para editoriales (el dato editorial se repite)

CREATE TABLE IF NOT EXISTS editoriales(
id_editorial INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
nombre_editorial VARCHAR(50) NOT NULL,
id_poblacion INT NOT NULL);	-- esta sera llave foranea cuando creemos tabla poblaciones

CREATE TABLE IF NOT EXISTS poblaciones(
id_poblacion INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
poblacion VARCHAR(25));

ALTER TABLE editoriales DROP COLUMN id_poblacion; -- borra columna

-- obtener solo las editoriales de la tabla libros (SELECT)

INSERT INTO editoriales(nombre_editorial)
SELECT DISTINCT editorial FROM libros;	-- en lugar de VALUES pone el resultado del SELECT

-- Añadir la columna id_editorial a la tabla libros

ALTER TABLE libros ADD COLUMN id_editorial int NOT NULL;

-- pasa dato id_editorial a libros desde editoriales cuando nombre_editorial sea el mismo

UPDATE libros as l,	-- l alias de libros
editoriales e
SET l.id_editorial = e.id_editorial
WHERE l.editorial = e.nombre_editorial;

ALTER TABLE libros DROP COLUMN editorial;

INSERT INTO poblaciones (poblacion) VALUES ("Barcelona"),("Madrid"),("Cornellà"),("París");

ALTER TABLE editoriales ADD COLUMN id_poblacion int NOT NULL;

SELECT SUM(ejemplares_stock) as "Stock total" FROM libros; -- si es solo una palabra no hacen falta ""

-- sistema simple pero NO recomendado (solo casos muy especificos)

SELECT l.titulo_libro, e.nombre_editorial	-- (l.|e.)así se evita ambiguedad, el motor ya sabe en que tabla esta cada columna
FROM libros l, editoriales e	-- el FROM se ejecuta primero, por eso se puede asignar alias luego
WHERE l.id_editorial = e.id_editorial; -- desventajas: si tienes que vincular muchas tablas no funciona, o si tiene que haber más condiciones
-- solo funciona con consultas simples

-- SISTEMA DE VINCULACIÓN RECOMENDADO / (INNER) JOIN [la parte común de ambos]

SELECT l.titulo_libro, e.nombre_editorial	-- la informacion que quieres
FROM libros l JOIN editoriales e	-- donde estan estos datos, uno en libros y otro en editoriales
ON l.id_editorial = e.id_editorial;

-- si se llama igual el dato(nombre columna) que vincula las tablas NATURAL JOIN

SELECT l.titulo_libro, e.nombre_editorial	
FROM libros l NATURAL JOIN editoriales e;

SELECT p.poblacion, e.nombre_editorial
FROM poblaciones p NATURAL JOIN editoriales e;

-- Nombre autor, titulo libro, editorial, poblacion

SELECT a.nombre_autor, a.apellido_autor, l.titulo_libro, e.nombre_editorial, p.poblacion
FROM autores a NATURAL JOIN autores_libros al NATURAL JOIN libros l NATURAL JOIN editoriales e NATURAL JOIN poblaciones p; -- NATURAL JOIN porque los datos comunes se llaman igual

-- cada JOIN va con un ON, sería JOIN **** ON **** JOIN **** ON ****;

SELECT a.nombre_autor, a.apellido_autor, l.titulo_libro, e.nombre_editorial, p.poblacion
FROM autores a JOIN autores_libros al 
ON a.id_autor = al.id_autor
JOIN libros l 
ON al.id_libro = l.id_libro
JOIN editoriales e 
ON l.id_editorial = e.id_editorial
JOIN poblaciones p
ON e.id_poblacion = p.id_poblacion;

-- de que autor no tenemos libro?

SELECT a.nombre_autor, a.apellido_autor-- , l.titulo_libro
FROM autores a LEFT JOIN autores_libros al
ON a.id_autor = al.id_autor
LEFT JOIN libros l 
ON l.id_libro = al.id_libro
WHERE l.titulo_libro IS NULL; -- si es un JOIN normal no importa el orden

-- LAS POBLACIONES que no tienen editorial

SELECT p.poblacion
FROM poblaciones p left JOIN editoriales e
ON p.id_poblacion = e.id_poblacion
WHERE e.nombre_editorial IS NULL;

-- crear tabla usuarios

CREATE TABLE IF NOT EXISTS usuarios(
id_usuario INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
nombre_usuario VARCHAR(20) NOT NULL,
apellido_usuario VARCHAR(50) NOT NULL,
fecha_nacimiento DATE,
carnet_biblio INT UNIQUE NOT NULL,
fecha_inscripcion TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

SELECT FLOOR(RAND()*(99999999 - 10000000)+1) + 10000000 as carnet;	-- ((max - min)+1)+min random da entre 1 y 0

INSERT INTO usuarios (nombre_usuario, apellido_usuario, fecha_nacimiento, carnet_biblio) VALUES
("Steve","Jobs","1955-02-24", FLOOR(RAND()*(99999999 - 10000000)+1) + 10000000),
("Letizia","Jobs","1968-06-30", FLOOR(RAND()*(99999999 - 10000000)+1) + 10000000),
("Peter","Parker","2000-03-11", FLOOR(RAND()*(99999999 - 10000000)+1) + 10000000),
("Clark","Kent","1989-09-11", FLOOR(RAND()*(99999999 - 10000000)+1) + 10000000),
("Lois","Lane","1989-11-06", FLOOR(RAND()*(99999999 - 10000000)+1) + 10000000);

CREATE TABLE IF NOT EXISTS prestamos (
id_prestamo INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
id_usuario INT NOT NULL,
id_libro INT NOT NULL,
fecha_prestamo TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
fecha_devolucion timestamp 
);

INSERT INTO prestamos (id_usuario, id_libro) VALUES
(1,1),(1,2),(1,3),(2,1),(2,2),(3,1);


-- OBTENER los prestamos de los libros prestados
SELECT l.titulo_libro, COUNT(pr.id_libro)  as prestamos
FROM libros l NATURAL JOIN prestamos pr
GROUP BY pr.id_libro;

INSERT INTO prestamos (id_usuario, id_libro) VALUES(4,4);

SELECT l.titulo_libro, COUNT(pr.id_libro)  as prestamos
FROM libros l NATURAL JOIN prestamos pr
GROUP BY pr.id_libro
HAVING prestamos = 1 -- solo los que se han prestado 1 vez
;

SELECT l.titulo_libro, COUNT(pr.id_libro)  as prestamos
FROM libros l NATURAL JOIN prestamos pr
GROUP BY pr.id_libro
HAVING prestamos > 1; -- se pueden usar los operadores matematicos necesarios

SELECT l.titulo_libro 
FROM libros l NATURAL JOIN prestamos pr
GROUP BY pr.id_libro
HAVING COUNT(pr.id_libro) > 1; 

-- Obtener los libros con menor cantidad de prestamos

SELECT COUNT(p.id_libro) AS minima_cantidad	
FROM prestamos p
GROUP BY p.id_libro
ORDER BY minima_cantidad	-- por defecto ordena en forma ascendente
LIMIT 1; -- el minimo numero de prestamos que hay

SELECT COUNT(p.id_libro) AS minima_cantidad
FROM prestamos p
GROUP BY p.id_libro
ORDER BY minima_cantidad DESC
LIMIT 1;

SELECT l.titulo_libro
FROM libros l
NATURAL JOIN prestamos p
GROUP BY p.id_libro
HAVING COUNT(p.id_libro) = (SELECT COUNT(p.id_libro) AS minima_cantidad
	FROM prestamos p
	GROUP BY p.id_libro
	ORDER BY minima_cantidad -- DESC para max
	LIMIT 1);	-- having = if, y select anidado, hay que envolver ()
    
    
-- VINCULACION entre tabla editoriales (fk id_poblacion) y tabla poblaciones (pk id_poblacion)
-- las constrains se tienen que aplicar sobre la tabla con la clave foranea (editoriales en este caso)
-- esto se puede hacer con el esquema (EER) o así

ALTER TABLE editoriales -- la tabla a modificar(donde creamos la constraint)
ADD CONSTRAINT fk_poblaciones -- nombre constraint
FOREIGN KEY (id_poblacion) -- que ya tiene la tabla
REFERENCES poblaciones(id_poblacion) -- a que tabla y con que dato se vincula
ON DELETE NO ACTION -- que pasa si se borra
ON UPDATE NO ACTION; -- que pasa si hay un update

-- Prestamos con libros, prestamos con usuarios

ALTER TABLE prestamos
ADD CONSTRAINT fk_libros_prestamos
FOREIGN KEY(id_libro)
REFERENCES libros(id_libro)
ON DELETE NO ACTION
ON UPDATE NO ACTION, -- "," para encadenar (siempre que se esté alterando la misma tabla)
ADD CONSTRAINT fk_usuarios
FOREIGN KEY(id_usuario)
REFERENCES usuarios(id_usuario)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE autores
ADD COLUMN id_epoca INT;

CREATE TABLE IF NOT EXISTS epocas (
id_epoca INT PRIMARY KEY AUTO_INCREMENT,
epoca VARCHAR(20) NOT NULL
);

ALTER TABLE autores
ADD CONSTRAINT fk_epoca
FOREIGN KEY (id_epoca)
REFERENCES epocas(id_epoca)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

UPDATE autores 
SET id_epoca = 1; -- al haber creado la tabla epoca vacía habia un daba error al no encontrar los id_epoca de autores(todos a 0) en epocas

-- PROCEDIMIENTO ALMACENADO (CALL) (CON LOS COMENTARIOS NO FUNCIONA)

DELIMITER $$ -- para cambiar el delimitador (;) por ($$) para que el código que pongamos dentro no se ejecute hasta que el procedimiento esté creado

CREATE PROCEDURE insertUsuario ( p_nombre varchar(20), p_apellido varchar(50), p_fecha_nacimiento date )	-- in, out, inout, campos que el procedimiento puede modificar, por defecto in
																				-- p_ prefijo para diferenciar parametros de variables/ argumentos (es como en una funcion)
                                                                                -- hay que respetar los tipos de los campos, si vamos a operar sobre varchar(20) hay que poner lo mismo
BEGIN -- para indicarle al procedimiento que tiene que empezar

INSERTINTO usuarios (nombre_usuario, apellido_usuario, fecha_nacimiento, carnet_biblio) VALUES
(p_nombre, p_apellido, p_fecha_nacimiento, FLOOR(RAND()*(99999999 - 10000000)+1) + 10000000);	-- este ; no será válido hasta que se cambie el delimitador de vuelta (ahora es $$)

END $$ -- para que acabe el procedimiento, el delimitador esta cambiado a $$, SOLO AQUI		
									
DELIMITER ; -- para cambiar el delimitador de vuelta, IMPORTANTE ESPACIO ENTRE DELIMITER Y CARACTERES
-- --------------------------------------------------------------------------------------------------------^^

DELIMITER $$ 

CREATE PROCEDURE insertUsuario ( p_nombre varchar(20), p_apellido varchar(50), p_fecha_nacimiento date )
BEGIN

INSERT INTO usuarios (nombre_usuario, apellido_usuario, fecha_nacimiento, carnet_biblio) VALUES
(p_nombre, p_apellido, p_fecha_nacimiento, FLOOR(RAND()*(99999999 - 10000000)+1) + 10000000);

END $$	
									
DELIMITER ;

CALL insertUsuario ("Bruce", "Wayne", "1998-06-09");	-- CALL para llamar al PROCEDURE