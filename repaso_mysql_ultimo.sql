CREATE DATABASE IF NOT EXISTS tienda;
USE tienda;

CREATE TABLE IF NOT EXISTS productos(
id_producto int primary key AUTO_INCREMENT,
nombre_producto varchar(50) not null,
precio decimal(8,2) not null,
stock_actual int not null,
ventas_producto int not null,
id_proveedor int not null
);
ALTER TABLE productos
MODIFY COLUMN ventas_producto int DEFAULT 0;

CREATE TABLE IF NOT EXISTS proveedores(
id_proveedor int primary key AUTO_INCREMENT,
nombre_proveedor varchar(50) not null
);
CREATE TABLE IF NOT EXISTS clientes(
id_cliente int primary key AUTO_INCREMENT,
nombre_cliente varchar(50) not null,
apellido_cliente varchar(100) not null,
id_pais int
);
CREATE TABLE IF NOT EXISTS paises(
id_pais int primary key AUTO_INCREMENT,
nombre_pais varchar(50)
);
CREATE TABLE IF NOT EXISTS facturas(
id_factura int primary key auto_increment,
id_cliente int not null,
id_producto int not null,
cantidad int not null,
fecha_compra DATETIME default CURRENT_TIMESTAMP
);
/**************************************************************************************************************************************************/
/*PROCEDIMIENTOS ALMACENADOS*/
DROP PROCEDURE IF EXISTS insertar_productos;

DELIMITER $$
CREATE PROCEDURE insertar_productos(
p_nombre_producto VARCHAR(50), -- por defecto IN, parametros (p) pueden ser IN o OUT
p_precio decimal(8,2),
p_stock INT,
p_nombre_proveedor varchar(50) )
BEGIN
/*variable para guardar el id del proveedor si existe*/
DECLARE v_id_proveedor int; /*variable local, con @ es global*/
DECLARE v_id_producto int;	/*VARIABLES TIENEN QUE ESTAR ARRIBA*/

-- para ver si ya tenemos el proveedor o no
SELECT id_proveedor INTO v_id_proveedor -- para asignar a variable
FROM proveedores WHERE nombre_proveedor = p_nombre_proveedor;

IF v_id_proveedor is null then 
	insert into proveedores (nombre_proveedor) values (p_nombre_proveedor);
    -- para saber que id le ha dado al nuevo proveedor
    SELECT id_proveedor INTO v_id_proveedor
	FROM proveedores WHERE nombre_proveedor = p_nombre_proveedor;
END IF; -- HAY que cerrar los IFs

-- aqui v_id_proveedor existe seguro, porque o bien ya era no nulo antes, o acabamos de darle valor en el if

-- para ver si ya tenemos el producto
SELECT id_producto INTO v_id_producto 
FROM productos WHERE nombre_producto = p_nombre_producto;

IF v_id_producto is null then	-- si v_id_producto es nulo hay que añadir el producto nuevo
	INSERT into productos(nombre_producto, precio, stock_actual, id_proveedor)
    VALUES(p_nombre_producto, p_precio, p_stock, v_id_proveedor);
	SELECT concat_ws(" ","Producto",p_nombre_producto,"añadido a la tabla.") as estado;	-- as estado para nombre columna output
ELSE 
	update productos set precio = p_precio, stock_actual = stock_actual + p_stock
    WHERE id_producto = v_id_producto;
    SELECT concat_ws(" ","Producto",p_nombre_producto,"actualizado.") as estado;
END IF;

END $$
DELIMITER ;

-- cada call tiene que ser independiente, NO como insert(),(),(),()
CALL insertar_productos("Iphone 27", 5000.75, 2, "Apple");
CALL insertar_productos("Iphone 27", 6000.75, 3, "Apple");
CALL insertar_productos("S35", 1000, 5, "Samsung");

/*****************************************************************************************************************************/
/*TRIGGERS*/
DROP TRIGGER IF EXISTS tr_verificar_stock;
DELIMITER //

CREATE TRIGGER tr_verificar_stock
-- AFTER / BEFORE, si EL TRIGGER SE dispara antes o despues del evento
BEFORE INSERT on facturas
FOR EACH ROW
BEGIN
	DECLARE v_stock int;
    select stock_actual into v_stock
    from productos where id_producto = new.id_producto; /*cuando se dispara el trigger ya se esta haciendo el insert, ya hay el id producto con el insert*/
    if v_stock < new.cantidad then 
		signal sqlstate "45000" 
        set message_text = "No hay suficiente stock"; -- para provocar una "excepcion"
	else	-- si hay suficiente stock hay que actualizar el stock
		update productos set stock_actual = stock_actual - new.cantidad,
        ventas_producto = ventas_producto + new.cantidad
        where id_producto = new.id_producto;
    end if;
END //

DELIMITER ;

insert into clientes (nombre_cliente, apellido_cliente) values
("Peter", "Parker"),("Beyoncé","Pérez");

-- ventas de productos
insert into facturas(id_cliente,id_producto,cantidad)values(1,1,1);
insert into facturas(id_cliente,id_producto,cantidad)values(2,2,20);

/*********************************************************************************************************************************************************************************************/
/*Procedimiento para vender un producto, si no esta el cliente lo añadimos, el producto se vende por su nombre
 ("Robin", "Hood", "Iphone 27", 2(cantidad))
si el cliente no esta lo añadimos, si el producto no esta lo advertimos
la salida final será: nombre_cliente apellido_cliente nombre_producto cantidad precio importe(cantidad*precio as total)*/
DELIMITER $$
create procedure venta_productos()
DELIMITER ;
-- CREAR SP PARA VENDER PRODUCTOS
-- Si el cliente no está, lo añadimos a la tabla
-- Si el producto no lo tenemos, mostramos un mensaje de error
-- La salida final será nombre_cliente apellido_cliente 
-- nombre_producto cantidad precio importe
-- ("Robin", "Hood", "Iphone 27", 2)

SELECT SUM(f.cantidad * p.precio) as "Total vendido"
FROM facturas f
NATURAL JOIN productos p
WHERE YEAR(f.fecha_compra) = 2023 ;

DROP FUNCTION IF EXISTS facturacion_anual;

DELIMITER $$
CREATE FUNCTION facturacion_anual (p_year_fact year)
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
DECLARE v_valor decimal(10, 2);
SELECT SUM(f.cantidad * p.precio) as "Total vendido" INTO v_valor
FROM facturas f
NATURAL JOIN productos p
WHERE YEAR(f.fecha_compra) = p_year_fact ;

IF v_valor IS NULL THEN
	RETURN concat_ws(" ", "El año", p_year_fact, "no ha habido facturación");
ELSE
	RETURN concat_ws(" ", "El año", p_year_fact, "la facturación ha sido", v_valor, "€");
END IF;
END $$
DELIMITER ;

SELECT facturacion_anual(2023);
/**************************************************************************************************************************************/
drop procedure if exists insertar_productos_2;
DELIMITER $$
CREATE PROCEDURE insertar_productos_2(
p_nombre_producto VARCHAR(50), -- por defecto IN, parametros (p) pueden ser IN o OUT
IN p_precio decimal(8,2),
IN p_stock INT,
IN p_nombre_proveedor varchar(50),
OUT p_stock_actualizado int )	-- 
BEGIN
/*variable para guardar el id del proveedor si existe*/
DECLARE v_id_proveedor int; /*DECLARE variable local, con @ es global*/
DECLARE v_id_producto int;	/*VARIABLES TIENEN QUE ESTAR ARRIBA*/

-- para ver si ya tenemos el proveedor o no
SELECT id_proveedor INTO v_id_proveedor -- para asignar a variable
FROM proveedores WHERE nombre_proveedor = p_nombre_proveedor;

IF v_id_proveedor is null then 
	insert into proveedores (nombre_proveedor) values (p_nombre_proveedor);
    -- para saber que id le ha dado al nuevo proveedor
    SELECT id_proveedor INTO v_id_proveedor
	FROM proveedores WHERE nombre_proveedor = p_nombre_proveedor;
END IF; -- HAY que cerrar los IFs

-- aqui v_id_proveedor existe seguro, porque o bien ya era no nulo antes, o acabamos de darle valor en el if

-- para ver si ya tenemos el producto
SELECT id_producto INTO v_id_producto 
FROM productos WHERE nombre_producto = p_nombre_producto;

IF v_id_producto is null then	-- si v_id_producto es nulo hay que añadir el producto nuevo
	INSERT into productos(nombre_producto, precio, stock_actual, id_proveedor)
    VALUES(p_nombre_producto, p_precio, p_stock, v_id_proveedor);
	SELECT concat_ws(" ","Producto",p_nombre_producto,"añadido a la tabla.") as estado;	-- as estado para nombre columna output
    
    SET p_stock_actualizado = p_stock;
ELSE 
	update productos set precio = p_precio, stock_actual = stock_actual + p_stock
    WHERE id_producto = v_id_producto;
    SELECT concat_ws(" ","Producto",p_nombre_producto,"actualizado.") as estado;
    
    SET p_stock_actualizado = (SELECT stock_actual FROM productos WHERE id_producto = v_id_producto);
END IF;

END $$
DELIMITER ;

SET @stock_producto_actualizado = 0;
CALL insertar_productos_2("Teclado Logitech3",120,2,"Logitech",@stock_producto_actualizado);	-- al ser out se le pondra el valor a stock actualizado
SELECT @stock_producto_actualizado;
/***********************************************************************************************************************************************************************************************************************************/
/*Necesitamos la informacion completa de la base de datos tienda:ALTER
los clientes, que han comprado, la fecha de la factura y quien era el proveedor
pero no hay que poner lod "ids"*/

-- solo clientes con factura
SELECT c.nombre_cliente, c.apellido_cliente, f.fecha_compra, pr.nombre_producto, pv.nombre_proveedor 
FROM clientes c natural join facturas f natural join productos pr natural join proveedores pv;
/*VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV*/
-- VISTAS / VIEWS
-- todos los clientes con o sin factura
DROP VIEW IF EXISTS datos_totales;
CREATE VIEW datos_totales as
SELECT c.nombre_cliente, c.apellido_cliente, f.fecha_compra, pr.nombre_producto, pr.precio, pr.stock_actual, pr.ventas_producto, pv.nombre_proveedor 
FROM clientes c 
left join facturas f 
on c.id_cliente = f.id_cliente
left join productos pr 
on f.id_producto = pr.id_producto
left join proveedores pv
on pr.id_proveedor = pv.id_proveedor
order by f.fecha_compra;

select * from datos_totales;
select nombre_cliente from datos_totales;


ALTER TABLE clientes
modify column id_pais int default 1;

insert into clientes (nombre_cliente, apellido_cliente, id_pais) values
("Michael","Corleone",2),("Jean Luc", "Piccard",3),("Luke","Skywalker",2),
("Jules","Verne",3),("Clark", "Kent",2),("Leia","Skywalker",2);


/*SELF JOIN*/

-- Queremos saber que clientes son del mismo país y que codigo de país es
SELECT concat_ws(" ",A.nombre_cliente, A.apellido_cliente) as cliente1, 
concat(B.nombre_cliente, " ", B.apellido_cliente) as cliente2, A.id_pais
from clientes A, clientes B
where A.id_pais = B.id_pais and A.id_cliente <> B.id_cliente	-- <> = !=
order by id_pais;

/*USUARIOS*/
-- ver los usuarios actuales
SELECT * from mysql.user; -- tabla interna sel sistema
/*							|host al que se va a conectar(localhost, %(todo), ip...), identified = pass*/
create user "admin_tienda"@"127.0.0.1" identified by "1234";
create user "admin_tienda"@"%" identified by "1234";
-- grant permisos on database.tabla to user@host	(puedes tener usuarios con el mismo nombre conectados a diferentes hosts, especificar a quien le das los permisos, si mismo user y pass mismo user-acumula permisos)
grant select on tienda.* to "admin_tienda"@"127.0.0.1";
grant insert, update, delete on tienda.* to "admin_tienda"@"127.0.0.1";	-- tienda.tabla
grant all privileges on tienda.* to "admin_tienda"@"%";

-- ver que permisos tiene el usuario
show grants for "admin_tienda"@"127.0.0.1";
show grants for "root"@"localhost";

-- Crear una funcion a la cual le indicamos el id del pais
-- y nos devolvera la cantidad de clientes de ese país

SELECT COUNT(id_pais) 