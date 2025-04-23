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
ORDER BY apellido_autor
LIMIT 1	-- que solo muestre el primero, en otros sistemas funciona de otra manera(poniendo top 1 arriba)
;

DESCRIBE libros;	-- describe la tabla libros
describe autores_libros;

ALTER TABLE libros 
DROP COLUMN id_autor;
