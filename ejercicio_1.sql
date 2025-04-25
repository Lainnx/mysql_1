CREATE DATABASE IF NOT EXISTS renting_cars;

USE renting_cars;

CREATE TABLE IF NOT EXISTS clientes(
id_cliente INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nombre VARCHAR(20) NOT NULL,
apellido VARCHAR(50) NOT NULL,
email VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS ventas(
id_venta INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
id_cliente INT NOT NULL,
CONSTRAINT  fk_clientes
FOREIGN KEY (id_cliente)
REFERENCES clientes(id_cliente)
ON DELETE NO ACTION
ON UPDATE NO ACTION
);

CREATE TABLE IF NOT EXISTS proveedores(
id_proveedor INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nombre VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS productos(
id_producto INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nombre VARCHAR(20) NOT NULL,
marca VARCHAR(20) NOT NULL,
precio DECIMAL(7.2) NOT NULL,
stock INT NOT NULL,
id_proveedor INT NOT NULL,
CONSTRAINT fk_proveedor
FOREIGN KEY (id_proveedor)
REFERENCES proveedores(id_proveedor)
);



CREATE TABLE IF NOT EXISTS ventas_productos(
id_ventas_productos INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
id_venta INT NOT NULL,
id_producto INT NOT NULL,
cantidad INT NOT NULL,
CONSTRAINT fk_vp_ventas
FOREIGN KEY (id_venta)
REFERENCES ventas(id_venta),
CONSTRAINT fk_vp_productos
FOREIGN KEY (id_producto)
REFERENCES productos(id_producto)
);

