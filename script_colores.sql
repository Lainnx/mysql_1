CREATE DATABASE IF NOT EXISTS colores;

USE colores;

CREATE TABLE IF NOT EXISTS colores(
id_color INT AUTO_INCREMENT PRIMARY KEY,
usuario VARCHAR(50) NOT NULL,
color_es varchar(25),
color_en varchar(25)
);

INSERT INTO colores(usuario, color_es, color_en) VALUES ("Tarzan", "verde", "green"),("Dani","darksalmon", "darksalmon");

-- crear usuario
CREATE USER "colores" @'%' IDENTIFIED by "colores"; -- @ '%' para que se pueda conectar de forma remota, identified by PASS

-- permisos
GRANT select, insert, update, delete ON colores.* to "colores" @'%';--  with GRANT OPTION	-- colores.* todas las tablas, GRANT OPTION para que pueda crear otros usuarios, ALL PRIVILEGES para todos

CREATE TABLE IF NOT EXISTS usuarios(
id_usuario INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
nombre_usuario VARCHAR(50) NOT NULL UNIQUE,
password_usuario VARCHAR(255) NOT NULL UNIQUE,
idioma VARCHAR(3) DEFAULT "ESP"
);

ALTER TABLE colores
ADD COLUMN id_usuario INT NOT NULL DEFAULT "1";

ALTER TABLE usuarios ADD COLUMN email VARCHAR(150);