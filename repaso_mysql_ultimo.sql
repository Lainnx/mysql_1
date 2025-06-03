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
SELECT id_producto INTO v_id_producto -- para asignar a variable
FROM productos WHERE nombre_producto = p_nombre_producto;



END $$
DELIMITER ;

-- cada call tiene que ser independiente, NO como insert(),(),(),()
CALL insertar_productos("Iphone 27", 5000.75, 2, "Apple");
CALL insertar_productos("Iphone 27", 5000.75, 2, "Samsung");