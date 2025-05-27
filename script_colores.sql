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

ALTER TABLE usuarios 
ADD COLUMN reset_token VARCHAR(255),
ADD COLUMN reset_expire DATETIME;

-- 66666666666666666666666666666666666666666666666666666666666666666

drop trigger tr_ins_passreset;

DELIMITER $$

CREATE TRIGGER tr_ins_passreset
AFTER UPDATE ON passreset
for each row
BEGIN
UPDATE usuarios set password_usuario = new.pass where id_usuario = new.id_usuario;
DELETE FROM passreset where id_usuario = new.id_usuario;
END $$
DELIMITER ;

drop trigger tr_ins_usuario
DELIMITER $$

CREATE TRIGGER tr_ins_usuario
AFTER UPDATE ON usuarios
for each row
BEGIN
DELETE FROM passreset where id_usuario = new.id_usuario;
END $$
DELIMITER ;

DELIMITER $$

CREATE PROCEDURE reset_pass(IN p_id_usuario INT, IN p_pass VARCHAR(255))
BEGIN
DECLARE v_pass varchar(255);
SELECT pass INTO v_pass -- el valor de la contraseña se guarda en esta variable
FROM passreset WHERE id_usuario = p_id_usuario;

-- UPDATE pasreset set pass=p_pass where id_usuario = p_id_usuario;
UPDATE usuarios set password_usuario = p_pass where id_usuario = p_id_usuario;
DELETE FROM passreset where id_usuario = p_id_usuario;
SELECT "OK" AS resultado;
END $$

DELIMITER ;

CALL reset_pass (3);