CREATE DATABASE empleados;
USE empleados;

CREATE TABLE empleados(
DNI VARCHAR(9) PRIMARY KEY NOT NULL,
nombre VARCHAR(100) NOT NULL,
apellidos VARCHAR(255) NOT NULL,
id_departamento INT NOT NULL
);

CREATE TABLE departamentos(
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
INSERT INTO departamentos(id_departamento, nombre, presupuesto) VALUES (11, Calidad, 40000);
INSERT INTO empleados(DNI, nombre, apellidos, id_departamento) VALUES ("89267109A", "Esther", "Vazquez", 11);
-- 13. Aplicar un recorte presupuestario del 10 % a todos los departamentos.
UPDATE departamentos SET presupuesto = presupuesto * 0.9;