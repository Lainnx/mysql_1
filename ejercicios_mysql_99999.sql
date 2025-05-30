-- 11111111111111111111111111111111111111111111111111111111111111111111111111111
-- Ejercicio1 - Empleados

CREATE DATABASE IF NOT EXISTS empleados;
USE empleados;

CREATE TABLE IF NOT EXISTS empleados(
DNI VARCHAR(9) PRIMARY KEY NOT NULL,
nombre VARCHAR(100) NOT NULL,
apellidos VARCHAR(255) NOT NULL,
id_departamento INT NOT NULL
);

CREATE TABLE IF NOT EXISTS departamentos(
id_departamento INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nombre VARCHAR(100) NOT NULL,
presupuesto DECIMAL(9,2) not null
);


-- 1 Obtener los apellidos de los empleados
SELECT apellidos FROM empleados;
-- 2 Obtener los apellidos de los empleados sin repeticiones
SELECT distinct apellidos FROM empleados;
-- 3 Obtener todos los datos de los empleados que se apellidan "LOPEZ"
SELECT * FROM empleados WHERE apellidos = "Lopez";
SELECT * FROM empleados WHERE apellidos LIKE "Lopez";
SELECT * FROM empleados WHERE apellidos IN ("Lopez");	-- en lista
-- 4. Obtener todos los datos de los empleados que se apellidan ’LOPEZ’ y los que se apellidan ’PEREZ’
SELECT * FROM empleados WHERE apellidos = "Lopez" OR apellidos = "Perez";
SELECT * FROM empleados WHERE apellidos LIKE "Lopez" OR apellidos LIKE "Perez";
SELECT * FROM empleados WHERE apellidos IN ("Lopez","Perez");
-- 5. Obtener todos los datos de los empleados que trabajan para el departamento 14.
SELECT * FROM empleados WHERE id_departamento = 14;
-- 6. Obtener todos los datos de los empleados que trabajan para el departamento 37 y para el departamento 77.
SELECT * FROM empleados WHERE id_departamento = 37 OR id_departamento = 77;
-- 7. Obtener todos los datos de los empleados cuyo apellido comience por 'P'
SELECT * FROM empleados WHERE apellidos LIKE "P%";	-- % cualquier sequencia de caracteres a continuación, _ 1 unico caracter
-- 8. Obtener el presupuesto total de todos los departamentos.
SELECT SUM(presupuesto) FROM departamentos; -- SUM(), COUNT(), AVG(), MIN(), MAX()
-- 9. Obtener el número de empleados en cada departamento.
SELECT id_departamento, COUNT(DNI) 
FROM empleados 
GROUP BY id_departamento;
-- 10. Obtener un listado completo de empleados, incluyendo por cada empleado los dato del empleado y de su departamento.
SELECT e.DNI, e.nombre, e.apellidos, d.nombre, d.presupuesto
FROM empleados e
INNER JOIN departamentos d -- lo mismo que JOIN
ON e.id_departamento = d.id_departamento;
-- 
SELECT e.DNI, e.nombre, e.apellidos, d.nombre, d.presupuesto
FROM empleados e
NATURAL JOIN departamentos d;
-- 11. Obtener los nombres de los departamentos que tienen más de dos empleados
SELECT nombre
FROM departamentos
WHERE id_departamento IN (
	SELECT id_departamento FROM empleados
    GROUP BY id_departamento HAVING COUNT(DNI) > 2);
-- 12. Añadir un nuevo departamento: ‘Calidad’, con presupuesto de 40.000 Bs. y código 11. Añadir un
-- empleado vinculado al departamento recién creado: ESTHER VAZQUEZ, DNI: 89267109A.
INSERT INTO departamentos(id_departamento, nombre, presupuesto) VALUES (11, "Calidad", 40000);
INSERT INTO empleados(DNI, nombre, apellidos, id_departamento) VALUES ("89267109A", "Esther", "Vazquez", 11);
-- 13. Aplicar un recorte presupuestario del 10 % a todos los departamentos.
UPDATE departamentos SET presupuesto = presupuesto * 0.9;

INSERT INTO departamentos(id_departamento, nombre, presupuesto) VALUES (10, "Ventas", 30000);
INSERT INTO empleados(DNI, nombre, apellidos, id_departamento) VALUES ("89254109A", "Nombre1", "Apellido1", 10);
INSERT INTO empleados(DNI, nombre, apellidos, id_departamento) VALUES ("12367439N", "Marco", "Polo", 10);

-- 14. Reasignar a los empleados del departamento de inves8gación (código 11) al departamento de informá8ca (código 10).
UPDATE empleados SET id_departamento = 10
WHERE id_departamento = 11;

UPDATE empleados SET id_departamento = 11
WHERE Nombre ="Esther";

-- 15. Despedir a todos los empleados que trabajan para el departamento de informá8ca (código 11).
DELETE FROM empleados WHERE id_departamento = 11;
-- 16. Despedir a todos los empleados que trabajen para departamentos cuyo presupuesto sea superior a los 60.000 Bs.
DELETE FROM empleados WHERE id_departamento IN(
	SELECT id_departamento FROM departamentos WHERE presupuesto > 60000);
-- 17. Despedir a todos los empleados.
DELETE FROM empleados;

-- 222222222222222222222222222222222222222222222222222222222222222222222
-- Ejercicio 2 - Almacenes

CREATE DATABASE IF NOT EXISTS almacenes;
USE almacenes;

CREATE TABLE IF NOT EXISTS almacenes(
id_almacen INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
lugar VARCHAR(100) NOT NULL,
capacidad INT NOT NULL
);
CREATE TABLE IF NOT EXISTS cajas(
num_referencia VARCHAR(5) PRIMARY KEY NOT NULL,
contenido VARCHAR(100) NOT NULL,
valor DECIMAL(6,2) NOT NULL,
id_almacen INT NOT NULL
);

-- 1. Obtener todos los almacenes.
SELECT * FROM almacenes;
-- 2. Obtener todas las cajas cuyo contenido tenga un valor superior a 150 Bs.
SELECT * FROM cajas WHERE valor > 150;
-- 3. Obtener los tipos de contenidos de las cajas.
SELECT DISTINCT contenido FROM cajas;
-- 4. Obtener el valor medio de todas las cajas.
SELECT AVG(valor) FROM cajas;
-- 5. Obtener el valor medio de las cajas de cada almacén.
SELECT id_almacen, AVG(valor)
FROM cajas 
GROUP BY id_almacen;
-- 6. Obtener los códigos de los almacenes en los cuales el valor medio de las cajas sea superior a 150 Bs.
SELECT id_almacen, AVG(valor)	-- al tener una sentencia de agregacion pista para HAVING
FROM cajas 
GROUP BY id_almacen
HAVING AVG(valor) >= 150;

INSERT INTO almacenes(lugar, capacidad) VALUES("Barcelona",100),("Cornellà",5),("Hospitalet",20),("Badalona",3);
INSERT INTO cajas(num_referencia, contenido, valor, id_almacen) VALUES("TECL1", "teclados", 100, 1),
("RAT1", "ratones", 200, 2),("TECL2", "teclados", 100, 4),("RAT2", "ratones", 200, 4);

-- 7. Obtener el número de referencia de cada caja junto con el nombre de la ciudad en el que se encuentra.
SELECT c.num_referencia, a.lugar
FROM almacenes a
NATURAL JOIN cajas c;
-- 8. Obtener el número de cajas que hay en cada almacén.
SELECT id_almacen, COUNT(id_almacen)
FROM cajas
GROUP BY id_almacen;	-- no salen los almacenes con 0 cajas

SELECT a.id_almacen, COUNT(c.id_almacen)
FROM almacenes a 
LEFT JOIN cajas c
ON a.id_almacen = c.id_almacen
GROUP BY a.id_almacen;
-- 9. Obtener los códigos de los almacenes que están saturados (los almacenes donde el número de cajas es superior a la capacidad).
SELECT a.id_almacen
FROM almacenes a
WHERE a.capacidad < (SELECT COUNT(c.id_almacen) FROM cajas c WHERE a.id_almacen = c.id_almacen);
-- 10. Obtener los números de referencia de las cajas que están en Badalona
SELECT num_referencia 
FROM cajas 
NATURAL JOIN almacenes
WHERE lugar = "Badalona";
-- 11. Insertar un nuevo almacén en Bilbao con capacidad para 3 cajas.
INSERT INTO almacenes (lugar, capacidad) VALUES("Bilbao",3);
-- 12. Insertar una nueva caja, con número de referencia ‘H5RT’, con contenido ‘Papel’, valor 200, y situada en el almacén 2.
INSERT INTO cajas (num_referencia, contenido, valor, id_almacen) VALUES("H5RT1","papel",200,2);
-- 13. Rebajar el valor de todas las cajas un 15 %.
UPDATE cajas SET valor = valor * 0.85;
-- 14. Rebajar un 20 % el valor de todas las cajas cuyo valor sea superior al valor medio de todas las cajas.
SET @promedio = (SELECT AVG(valor) FROM cajas);
UPDATE cajas SET valor = valor * 0.80 
WHERE valor > @promedio;
-- 15. Eliminar todas las cajas cuyo valor sea inferior a 100 Bs.
DELETE FROM cajas WHERE valor < 100;
-- 16. Vaciar el contenido de los almacenes que están saturados
/*
DELETE FROM cajas WHERE id_almacen IN (
	SELECT a.id_almacen 
	FROM almacenes a 
	WHERE a.capacidad < (
		SELECT COUNT(c.id_almacen) 
		FROM cajas c 
		WHERE a.id_almacen = c.id_almacen)) ;
*/
DELETE c
FROM cajas c
JOIN (
    SELECT a.id_almacen
    FROM almacenes a
    JOIN cajas cc ON a.id_almacen = cc.id_almacen
    GROUP BY a.id_almacen, a.capacidad
    HAVING a.capacidad < COUNT(cc.id_almacen)
) AS sub ON c.id_almacen = sub.id_almacen;

-- 33333333333333333333333333333333333333333333333333333333333333333333333333333333
-- Ejercicio 3 - Peliculas y salas
CREATE DATABASE IF NOT EXISTS peliculas;
use peliculas;
CREATE TABLE IF NOT EXISTS salas (
id_sala INT PRIMARY KEY AUTO_INCREMENT,
nombre_sala VARCHAR(100) NOT NULL,
id_pelicula INT
);

CREATE TABLE IF NOT EXISTS peliculas (
id_pelicula INT PRIMARY KEY AUTO_INCREMENT,
titulo_pelicula VARCHAR(100) NOT NULL,
calificacion_edad INT
);

INSERT INTO peliculas (titulo_pelicula, calificacion_edad) VALUES 
("Batman", 12),("Bambi", 18),("Tiburón", 6),("El conclave", 12);
INSERT INTO salas (nombre_sala, id_pelicula) VALUES("Sala 1", 1),("Sala 2",3),("Sala 3",4);
INSERT INTO peliculas (titulo_pelicula, calificacion_edad) VALUES 
("Shrek",null),("Scream",null);
INSERT INTO salas (nombre_sala, id_pelicula) VALUES("Sala 4", null);
INSERT INTO salas (nombre_sala, id_pelicula) VALUES("Sala 5", null);
-- 1. Mostrar el nombre de todas las películas.
SELECT titulo_pelicula FROM peliculas;
-- 2. Mostrar las distintas calificaciones de edad que existen.
SELECT DISTINCT calificacion_edad FROM peliculas;
-- 3. Mostrar todas las películas que no han sido calificadas.
SELECT titulo_pelicula FROM peliculas WHERE calificacion_edad IS null;
-- 4. Mostrar todas las salas que no proyectan ninguna película.
SELECT nombre_sala FROM salas WHERE id_pelicula IS NULL;
-- 5. Mostrar la información de todas las salas y, si se proyecta alguna película en la sala, mostrar también la información de la película.
SELECT * 
FROM salas s
LEFT JOIN peliculas p
ON s.id_pelicula = p.id_pelicula;
-- 5.b Mostrar la información de todas las salas y, si se proyecta alguna película en la sala, mostrar también el titulo de la película.
SELECT s.nombre_sala, IFNULL(p.titulo_pelicula, "No hay pelicula todavía") -- si resulta que es nulo le decimos que haga algo a continuacion
FROM salas s
LEFT JOIN peliculas p
ON s.id_pelicula = p.id_pelicula;
-- 6. Mostrar la información de todas las películas y, si se proyecta en alguna sala, mostrar también la información de la sala.
SELECT * 
FROM peliculas p
LEFT JOIN salas s
ON p.id_pelicula = s.id_pelicula;
-- 7. Mostrar los nombres de las películas que no se proyectan en ninguna sala.
SELECT titulo_pelicula 
FROM peliculas p
left JOIN salas s
ON p.id_pelicula = s.id_pelicula WHERE id_sala IS NULL;

-- 8. Añadir una nueva pelıcula ‘Uno, Dos, Tres’, para mayores de 7 años.
INSERT INTO peliculas (titulo_pelicula, calificacion_edad) VALUES ("Uno, Dos, Tres", 7);
-- Y después hacer que se proyecte al menos en 4 salas.
SET @id_123 = (SELECT id_pelicula FROM peliculas WHERE titulo_pelicula = "Uno, Dos, Tres");
INSERT INTO salas (nombre_sala, id_pelicula) VALUES("Sala 1",@id_123), ("Sala 2", @id_123), ("Sala 3", @id_123), ("Sala 4", @id_123);

SELECT titulo_pelicula, COUNT(s.id_pelicula) as cantidad,	/*cantidad nombre que s ele dara al count()*/
    CASE
        WHEN COUNT(s.id_pelicula) > 3 THEN "Pelicula muy popular"	/*lo mostrara arriba en vez de count()*/
        WHEN COUNT(s.id_pelicula) > 0 THEN "Bastante conocida"
        ELSE "no la ha visto nadie"
    END as popularidad	/*nombre que se le dara a la columna*/
FROM salas s
RIGHT JOIN peliculas p
ON p.id_pelicula = s.id_pelicula
GROUP BY titulo_pelicula
ORDER BY cantidad DESC;
-- 9. Hacer constar que todas las películas no calificadas han sido calificadas ‘no recomendables para menores de 13 años’.
UPDATE peliculas SET calificacion_edad = 13 WHERE calificacion_edad IS NULL;

-- 10. Eliminar todas las salas que proyectan películas recomendadas para todos los públicos.
DELETE s FROM salas s
JOIN peliculas p
ON s.id_pelicula = p.id_pelicula
WHERE p.calificacion_edad < 13;

-- 44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
-- Ejercicio 4 - Los Directores

CREATE DATABASE IF NOT EXISTS directores;
USE directores;

CREATE TABLE IF NOT EXISTS directores (
DNI VARCHAR(9) PRIMARY KEY,
nom_apels VARCHAR(255) NOT NULL,
DNIjefe VARCHAR(9) NOT NULL,
despacho INT NOT NULL
);

CREATE TABLE IF NOT EXISTS despachos(
numero INT PRIMARY KEY,
capacidad INT NOT NULL
);

-- 77777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777777
-- 7 - Control de Stock y Facturación

CREATE DATABASE IF NOT EXISTS ejercicio_07;
USE ejercicio_07;

CREATE TABLE IF NOT EXISTS provincias(
cod_pro CHAR(2) PRIMARY KEY NOT NULL,
nombre_provincia VARCHAR(50)
);
CREATE TABLE IF NOT EXISTS pueblos(
cod_pue CHAR(3) PRIMARY KEY NOT NULL,
nombre_pueblo VARCHAR(50),
cod_pro CHAR(2) NOT NULL
);
CREATE TABLE IF NOT EXISTS clientes(
cod_cli INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
nombre_cliente VARCHAR(100) NOT NULL,
direccion_cli varchar(100) not null,
codpostal_cli char(5),
cod_pue char(3)
);
CREATE TABLE IF NOT EXISTS vendedores(
cod_ven INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
nombre_vendedor VARCHAR(100) NOT NULL,
direccion_ven varchar(100) not null,
codpostal_ven char(5),
cod_pue char(3)
);
CREATE TABLE IF NOT EXISTS articulos(
cod_art INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
descripcion_art VARCHAR(100) NOT NULL,
precio_art decimal(8,2),
stock_art int,
stock_min int
);
CREATE TABLE IF NOT EXISTS facturas(
cod_fac INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
fecha_fac datetime,
cod_cli INT, 
cod_ven INT,
iva int,
descuento_fac decimal(5,2)
);
CREATE TABLE IF NOT EXISTS lineas_fac(
cod_lin_fac INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
cod_fac int,
cant_lin decimal(8,2),
cod_art int,
precio decimal(8,2),
desciento_lin decimal(5,2)
);
-- 1. Mostrar las provincias 
-- 2. Nombre y código de las provincias. 
-- 3. Mostrar el código de los arYculos y el doble del precio de cada arYculo. 
-- 4. Mostrar el código de la factura, número de línea e importe de cada línea (sin considerar impuestos 
-- ni descuentos. 
-- 5. Mostrar los dis8ntos 8pos de IVA aplicados en las facturas. 
-- 6. Mostrar el código y nombre de aquellas provincias cuyo código es menor a 20. 
-- 7. Mostrar los dis8ntos 8pos de descuento de aplicados por los vendedores que cuyos códigos no  superan el valor 50. 
-- 8. Mostrar el código y descripción de aquellos arYculos cuyo stock es igual o supera los 50 unidades. 
-- 9. Mostrar el código y fechas de las facturas con IVA 16 y que pertenecen al cliente de código 100. 
-- 10. Mostrar el código y fechas de las facturas con IVA 16 o con descuento 20 y que pertenecen al cliente de código 100. 
-- 11. Mostrar el código de la factura y el número de línea de las facturas cuyas líneas superan 100 Bs sin 
-- considerar descuentos ni impuestos. 
-- 12. Importe medio por factura, sin considerar descuentos ni impuestos. El importe de una factura se 
-- calcula sumando el producto de la can8dad por el precio de sus líneas. 
-- 13. Stock medio, máximo, y mínimo de los arYculos que con8enen la letra A en la segunda posición 
-- de su descripción y cuyo stock mínimo es superior a la mitad de su stock actual. 
-- 14. Número de facturas para cada año. Junto con el año debe aparecer el número de facturas de ese 
-- año. 
-- 15. Número de facturas de cada cliente, pero sólo se deben mostrar aquellos clientes que 8enen más 
-- de 15 facturas. 
-- 16. Can8dades totales vendidas para cada arYculo cuyo código empieza por “F”. La can8dad total 
-- vendida de un arYculo se calcula sumando las can8dades de todas sus líneas de factura. 
-- 17. Código de aquellos arYculos de los que se ha facturado más de 6000 euros. 
 
-- 18. Número de facturas de cada uno de los clientes cuyo código está entre 241 y 250, con cada IVA 
-- dis8nto que se les ha aplicado. En cada línea del resultado se debe mostrar un código de cliente, 
-- un IVA y el número de facturas de ese cliente con ese IVA. 
-- 19. Vendedores y clientes cuyo nombre coincide (vendedores que a su vez han comprado algo a la 
-- empresa) 
 
-- 20. Creación de una vista que muestre únicamente los códigos postales de los clientes que inicien con 
-- el número 12. 
-- 21. Mostrar el código y el nombre de los clientes de Castellón (posee código 12) que han realizado 
-- facturas con vendedores de más de dos provincias dis8ntas. El resultado debe quedar ordenado 
-- ascendentemente respecto del nombre del cliente