CREATE DATABASE IF NOT EXISTS colores;

USE colores;

CREATE TABLE IF NOT EXISTS colores(
id_color INT AUTO_INCREMENT PRIMARY KEY,
usuario VARCHAR(50) NOT NULL,
color_es varchar(25),
color_en varchar(25)
);

INSERT INTO colores(usuario, color_es, color_en) VALUES ("Tarzan", "verde", "green"),("Dani","darksalmon", "darksalmon");