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