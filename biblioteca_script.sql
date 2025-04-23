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
VALUES(1, 1),(1,2),(2,3),(3,4);

-- necesitamos tabla para editoriales (el dato editorial se repite)

CREATE TABLE IF NOT EXISTS editoriales(
id_editorial INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
nombre_editorial VARCHAR(50) NOT NULL,
id_poblacion INT NOT NULL);	-- esta sera llave foranea cuando creemos tabla poblaciones

CREATE TABLE IF NOT EXISTS poblaciones(
id_poblacion INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
poblacion VARCHAR(25));