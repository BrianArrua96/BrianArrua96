DROP DATABASE IF EXISTS moviles;
CREATE DATABASE IF NOT EXISTS moviles;
USE moviles;

#--Creació de taules
CREATE TABLE cliente (
   id_cliente MEDIUMINT AUTO_INCREMENT,
   dni VARCHAR(9) NOT NULL,
   nombre VARCHAR (20) NOT NULL,
   apellido VARCHAR(20) NOT NULL,
   email VARCHAR(30) NOT NULL,
   telefono VARCHAR(15),
   direccion VARCHAR(50),
   PRIMARY KEY (id_cliente),
   CONSTRAINT uk_cliente_dni UNIQUE (dni),
   CONSTRAINT uk_cliente_email UNIQUE (email),
   CONSTRAINT ck_cliente_dni CHECK (dni REGEXP '^[0-9]{8}[A-Z]')
)ENGINE=INNODB;

CREATE TABLE transportista (
   id_transportista SMALLINT AUTO_INCREMENT,
   dni VARCHAR(9) NOT NULL,
   empresa VARCHAR(20),
   email VARCHAR(30) NOT NULL,
   telefono VARCHAR(15) NOT NULL,
   direccion VARCHAR(50),
   PRIMARY KEY (id_transportista),
   CONSTRAINT uk_transportista_dni UNIQUE (dni),
   CONSTRAINT ck_cliente_dni CHECK (dni REGEXP '^[0-9]{8}[A-Z]')
)ENGINE=INNODB;

CREATE TABLE pedido (
   id_pedido INT AUTO_INCREMENT,
   cliente_id MEDIUMINT NOT NULL,
   transportista_id SMALLINT NOT NULL,
   importe_total DECIMAL(7,2) NOT NULL,
   direccion_envio VARCHAR(50) NOT NULL,
   estado ENUM('R', 'E', 'P') NOT NULL DEFAULT 'P',
   fecha_envio DATE,
   fecha_entrega DATETIME,
   PRIMARY KEY (id_pedido),
   CONSTRAINT fk_cliente_pedido FOREIGN KEY (cliente_id) REFERENCES cliente(id_cliente),
   CONSTRAINT fk_cliente_transportista FOREIGN KEY (transportista_id) REFERENCES transportista(id_transportista)
)ENGINE=INNODB;

CREATE TABLE trabajador (
   id_trabajador SMALLINT(3) AUTO_INCREMENT,
   supervisor_id SMALLINT(3),
   dni VARCHAR(9) NOT NULL,
   nombre VARCHAR(20) NOT NULL,
   apellido_1 VARCHAR(20) NOT NULL,
   apellido_2 VARCHAR(20),
   email VARCHAR(30),
   telefono VARCHAR(15),
   direccion VARCHAR(50),
   salario DECIMAL(7,2) NOT NULL,
   fecha_nacimiento DATE NOT NULL,
   fecha_contrato DATE NOT NULL,
   PRIMARY KEY (id_trabajador),
   CONSTRAINT fk_trabajador_trabajador FOREIGN KEY (supervisor_id) REFERENCES trabajador(id_trabajador),
   CONSTRAINT uk_trabajador_dni UNIQUE (dni),
   CONSTRAINT uk_trabajador_email UNIQUE (email),
   CONSTRAINT ck_trabajador_dni CHECK (dni REGEXP '^[0-9]{8}[A-Z]'),
   CONSTRAINT ck_trabajador_salario CHECK (salario>0)
)ENGINE=INNODB;

CREATE TABLE tecnico (
   id_tecnico SMALLINT(3) NOT NULL,
   especialidad VARCHAR(20),
   PRIMARY KEY (id_tecnico),
   CONSTRAINT fk_trabajador_tecnico FOREIGN KEY (id_tecnico) REFERENCES trabajador(id_trabajador)
)ENGINE=INNODB;

CREATE TABLE incidencia (
   id_incidencia INT AUTO_INCREMENT,
   cliente_id MEDIUMINT NOT NULL,
   tecnico_supervisor SMALLINT(3) NOT NULL,
   descripcion VARCHAR(255) NOT NULL,
   fecha_notificacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,   
   fecha_inicio DATETIME NOT NULL,
   fecha_resolucion DATETIME NULL,
   PRIMARY KEY (id_incidencia),
   CONSTRAINT fk_cliente_incidencia FOREIGN KEY (cliente_id) REFERENCES cliente(id_cliente),
   CONSTRAINT fk_tecnico_incidencia FOREIGN KEY (tecnico_supervisor) REFERENCES tecnico(id_tecnico),
   CONSTRAINT ck_incidencia_fecha_inicio CHECK (fecha_inicio>=fecha_notificacion),
   CONSTRAINT ck_incidencia_fecha_resolucion CHECK (fecha_resolucion>fecha_inicio)
)ENGINE=INNODB;

CREATE TABLE incidencia_tecnico (
   id_incidencia INT NOT NULL,
   id_tecnico SMALLINT(3) NOT NULL,
   PRIMARY KEY (id_incidencia, id_tecnico),
   CONSTRAINT fk_incidencia_tecnico_incidencias FOREIGN KEY (id_incidencia) REFERENCES incidencia (id_incidencia),
   CONSTRAINT fk_incidencia_tecnico_tecnico FOREIGN KEY (id_tecnico) REFERENCES tecnico (id_tecnico)
) ENGINE=INNODB;

CREATE TABLE comercial(
	id_comercial SMALLINT(3) NOT NULL,
   PRIMARY KEY (id_comercial),
	CONSTRAINT fk_comercial_trabajador FOREIGN KEY (id_comercial) REFERENCES trabajador(id_trabajador)
)ENGINE=INNODB;

CREATE TABLE pais(
	id_pais SMALLINT(3) AUTO_INCREMENT,
   codigo VARCHAR(3) NOT NULL,
   nombre VARCHAR(30) NOT NULL,
   PRIMARY KEY (id_pais),
   CONSTRAINT uk_pais_codigo UNIQUE (codigo),
   CONSTRAINT uk_pais_nombre UNIQUE (nombre)
)ENGINE=INNODB;

CREATE TABLE suministrador(
	id_suministrador SMALLINT(3) AUTO_INCREMENT,
   pais_id SMALLINT(3),
   comercial_id SMALLINT(3),
   PRIMARY KEY (id_suministrador),
   CONSTRAINT fk_comercial_suministrador FOREIGN KEY (comercial_id) REFERENCES comercial(id_comercial),
   CONSTRAINT fk_suministrador_pais FOREIGN KEY (pais_id) REFERENCES pais(id_pais)
)ENGINE=INNODB;

CREATE TABLE marca(
	id_marca SMALLINT(3) AUTO_INCREMENT,
   codigo VARCHAR(3) NOT NULL,
   nombre VARCHAR(20) NOT NULL,
   PRIMARY KEY(id_marca),
   CONSTRAINT uk_marca_codigo UNIQUE (codigo),
   CONSTRAINT uk_marca_nombre UNIQUE (nombre)
)ENGINE=INNODB;

CREATE TABLE telefono(
	id_telefono SMALLINT AUTO_INCREMENT,
   marca_id SMALLINT (3) NOT NULL,
   modelo VARCHAR(20) NOT NULL,
   pvp DECIMAL(7,2) NOT NULL,
   stock SMALLINT(4) NOT NULL,
	PRIMARY KEY(id_telefono),
   CONSTRAINT fk_telefono_marca FOREIGN KEY (marca_id) REFERENCES marca(id_marca),
   CONSTRAINT uk_telefono_marca_id_modelo UNIQUE (marca_id, modelo),
   CONSTRAINT ck_telefono_stock CHECK (stock>=0)
)ENGINE=INNODB;
ALTER TABLE telefono AUTO_INCREMENT=100;

CREATE TABLE telefono_pedido (
id_pedido INT NOT NULL,
id_telefono SMALLINT NOT NULL,
cantidad TINYINT NOT NULL,
PRIMARY KEY (id_pedido, id_telefono),
CONSTRAINT fk_telefono_pedido_pedido FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
CONSTRAINT fk_telefono_pedido_telefono FOREIGN KEY (id_telefono) REFERENCES telefono(id_telefono),
CONSTRAINT ck_telefono_pedido_cantidad CHECK(cantidad>0)
)ENGINE=INNODB;

CREATE TABLE telefono_suministrador (
   id_telefono SMALLINT NOT NULL,
   id_suministrador SMALLINT(3) NOT NULL,
   precio DECIMAL(7,2) NOT NULL,
   PRIMARY KEY(id_telefono,id_suministrador),
   CONSTRAINT fk_telefono_suministrador_telefono FOREIGN KEY (id_telefono) REFERENCES telefono(id_telefono),
   CONSTRAINT fk_telefono_suministrador_suministrador FOREIGN KEY (id_suministrador) REFERENCES suministrador(id_suministrador),
   CONSTRAINT ck_telefono_suministrador CHECK (precio<50000.00 AND precio>= 0.00)
)ENGINE=INNODB;

#--Creació d'index
CREATE INDEX ix_incidencia_fecha_inicio ON incidencia (fecha_inicio);
CREATE INDEX ix_cliente_telefono ON cliente (telefono);
ALTER TABLE telefono_suministrador ADD INDEX ix_suministra_precio (precio);
ALTER TABLE transportista ADD INDEX ix_transportista_telefono (telefono);

#-- Tasca 1. Inserció de dades.
#-- Cliente.
INSERT INTO cliente (dni, nombre, apellido, email, telefono, direccion) 
    VALUES ('44226677W','Juan','Membrillo', 'meju@gmail.com' ,'0034667612987','Calle Milet n2 p3, Mollet, 08215 BCN');
INSERT INTO cliente (dni, nombre, apellido, email, telefono, direccion) 
    VALUES ('33226647Q','Maria','Torre', 'mato@gmail.com','0034687366787','Casa Blanca, Puebla de Lillet, 08315 GIR');
INSERT INTO cliente (dni, nombre, apellido, email, telefono, direccion) 
    VALUES ('39226675D','Norman','Aren', 'noar@yahoo.de', '123766431255987','Elm Str n2 p3, Pueblo Caoba, 18215 TOL');
INSERT INTO cliente (dni, nombre, apellido, email, telefono, direccion) 
    VALUES ('39223621F','Silvia','Aren','siar@yahoo.de', '123777892237287','Elm Str n2 p3, Pueblo Caoba, 18215 TOL');
INSERT INTO cliente (dni, nombre, apellido, email, telefono, direccion) 
    VALUES ('59226612G','Carla','Heuer','cahe@hdmail.com' ,'0034699322495','Casa Antigua, Mur, 20500 LLD');
INSERT INTO cliente (dni, nombre, apellido, email, telefono, direccion) 
    VALUES ('31226227D','Montse','Ayala','moay@tmail.com' ,'0034992559872','Mon Gaztelugatxe, Bilbao, 44444 BIZ');
INSERT INTO cliente (dni, nombre, apellido, email, telefono, direccion) 
    VALUES ('39247277S','Ander','Goikoetxea','ango@gmail.com', '0034592559872','Playa la Concha, San Sebastián, 55555 GIZ');
INSERT INTO cliente (dni, nombre, apellido, email, telefono, direccion) 
    VALUES ('39226671C','Fernando','Schneider','fesch@de.olnd.com', '0034231453675','Calle Essen n5 p1, Mallorca, 33333 BAL');
INSERT INTO cliente (dni, nombre, apellido, email, telefono, direccion) 
    VALUES ('38833612V','Terry','Shelby', 'tesh@malm.com','0034443554776',' 2 C Unica Arrollo de la Miel, Malaga, 22222 MAL');
INSERT INTO cliente (dni, nombre, apellido, email, telefono, direccion) 
    VALUES ('32226699Z','Heidi','Arendt', 'hear@me.com','0045654327877','45 Kirchen Strasse, Köln, 56120 RHI Deutschland');

#-- Transportista
INSERT INTO transportista 
   VALUES (1, '49226671F', 'GLS', 'art.fern@gls.com', 0034666777888, NULL);
INSERT INTO transportista 
   VALUES (5, '39225512W', NULL, 'eli.hdz@gmail.com', 0034669977588, NULL);
INSERT INTO transportista 
   VALUES (7, '54326671G', 'SEUR', 'ernst.hemingwy@seur.com', 0034874678883, NULL);

#-- Pedido
INSERT INTO pedido
   VALUES (1, 3, 5, 500.00, 'Cl Uberdrive, n5 p3, Madrid 99999', 'R', '2022-11-30', '2022-12-05 14:55:00');
INSERT INTO pedido
   VALUES (2, 3, 7, 900.00, 'Elm Str n2 p3, Pueblo Caoba, 18215 TOL', 'P', NULL, NULL);
INSERT INTO pedido
   VALUES (7, 7, 1, 1500.00, 'Playa la Concha, San Sebastián, 55555 GIZ', 'E', '2021-01-01', NULL);

#-- Trabajador.
INSERT INTO trabajador (dni,nombre,apellido_1,apellido_2,email,telefono,direccion,salario,fecha_nacimiento,fecha_contrato) 
    VALUE('18292383B','Juan','Moreno','Cano','juanmoca@gmail.com',626622432,'Fuentalbilla',1500,'1970-10-28','2000-01-01');
INSERT INTO trabajador (dni,nombre,apellido_1,apellido_2,email,telefono,direccion,salario,fecha_nacimiento,fecha_contrato) 
    VALUE('18292283Z','Jose','Josue','Gerard','jojo@gmail.com',626621422,'Olimpo',1700,'1972-02-21','2000-01-01');
INSERT INTO trabajador (supervisor_id,dni,nombre,apellido_1,apellido_2,email,telefono,direccion,salario,fecha_nacimiento,fecha_contrato) 
    VALUE(1,'18292334A','Luigi','Arrua','Bros','lbro@gmail.com',623663432,'Barcelona',1250,'1973-03-25','2001-02-01');
INSERT INTO trabajador (supervisor_id,dni,nombre,apellido_1,apellido_2,email,telefono,salario,fecha_nacimiento,fecha_contrato)
    VALUE(2,'18292181X','Mario','Arrua','Bros','mbro@gmail.com',622665432,1200,'1971-04-26','2001-09-01');
INSERT INTO trabajador (supervisor_id,dni,nombre,apellido_1,apellido_2,email,telefono,direccion,salario,fecha_nacimiento,fecha_contrato)
    VALUE(1,'18292322Z','Joselito','Lopez','Piña','pluvio@gmail.com',626623323,'Huecomundo',1000,'1972-05-27','2002-08-01');
INSERT INTO trabajador (supervisor_id,dni,nombre,apellido_1,email,telefono,direccion,salario,fecha_nacimiento,fecha_contrato)
    VALUE(2,'18292387Z','Nivea','Ortega','nile@gmail.com',623662413,'Pedrada',1450,'1974-06-28','2002-07-01');
INSERT INTO trabajador (supervisor_id,dni,nombre,apellido_1,email,telefono,direccion,salario,fecha_nacimiento,fecha_contrato)
    VALUE(1,'18292386A','Cynthia','Concepcion','ccc@gmail.com',626624424,'Chilena',1000,'1975-07-29','2003-06-01');
INSERT INTO trabajador (supervisor_id,dni,nombre,apellido_1,apellido_2,email,telefono,direccion,salario,fecha_nacimiento,fecha_contrato) 
    VALUE(2,'18292385B','Kevin','Cardozo','Canto','keca@gmail.com',626624942,'Bocasucia',1450,'1976-08-23','2004-05-01');
INSERT INTO trabajador (supervisor_id,dni,nombre,apellido_1,apellido_2,email,telefono,direccion,salario,fecha_nacimiento,fecha_contrato) 
    VALUE(1,'18292384A','Paco','Lopera','Fernandez','palo@gmail.com',626691292,'CuencaAntigua',1250,'1977-09-21','2002-07-01');
INSERT INTO trabajador (supervisor_id,dni,nombre,apellido_1,apellido_2,email,telefono,salario,fecha_nacimiento,fecha_contrato) 
    VALUE(2,'18292382A','Pablo','Calero','Dominguez','paca@gmail.com',626331432,1000,'1978-11-22','2003-11-01');
INSERT INTO trabajador (supervisor_id,dni,nombre,apellido_1,email,telefono,salario,fecha_nacimiento,fecha_contrato) 
    VALUE(1,'18292381X','Brian','Ferrer','bfl@gmail.com',626621432,1000,'1979-12-29','2004-11-11');

#-- Tecnico.
INSERT INTO tecnico VALUES(1, 'Hardware');
INSERT INTO tecnico VALUES(2, 'Software');
INSERT INTO tecnico (id_tecnico) VALUES(3);
INSERT INTO tecnico (id_tecnico) VALUES(5);
INSERT INTO tecnico VALUES (7, 'Hardware');
INSERT INTO tecnico VALUES (9, 'Software');

#-- Incidencia.
INSERT INTO incidencia (cliente_id, tecnico_supervisor, descripcion, fecha_notificacion, fecha_inicio, fecha_resolucion)
   VALUES (1, 1, 'Telefono roto', '2022-11-14 13:12:54', '2022-11-14 15:40:11', NULL);
INSERT INTO incidencia (cliente_id, tecnico_supervisor, descripcion, fecha_notificacion, fecha_inicio, fecha_resolucion)
   VALUES (2, 2, 'No va OS', '2022-11-19 19:52:34', '2022-11-20 14:25:13', '2022-11-23 15:55:11');
INSERT INTO incidencia (cliente_id, tecnico_supervisor, descripcion, fecha_notificacion, fecha_inicio, fecha_resolucion)
   VALUES (4, 7, 'Telefono roto', '2022-11-24 09:11:14', '2022-11-29 14:34:55', NULL);

#-- Incidencia_tecnico.
INSERT INTO incidencia_tecnico VALUES (1, 1);
INSERT INTO incidencia_tecnico VALUES (2, 2);
INSERT INTO incidencia_tecnico VALUES (2, 9);
INSERT INTO incidencia_tecnico VALUES (3, 7);


#-- Comercial.
INSERT INTO comercial VALUE(4);
INSERT INTO comercial VALUE(6);
INSERT INTO comercial VALUE(8);
INSERT INTO comercial VALUE(10);

#-- Pais.
INSERT INTO pais (codigo,nombre) VALUE('USA','Estados Unidos');
INSERT INTO pais (codigo,nombre) VALUE('JEY','Japon');
INSERT INTO pais (codigo,nombre) VALUE('AUS','Australia');
INSERT INTO pais (codigo,nombre) VALUE('ES','España');
INSERT INTO pais (codigo,nombre) VALUE('IE','Irlanda');

#-- Suministrador.
INSERT INTO suministrador (pais_id,comercial_id) VALUE(1,4);
INSERT INTO suministrador (pais_id,comercial_id) VALUE(2,6);
INSERT INTO suministrador (pais_id,comercial_id) VALUE(3,8);

#-- Marca.
INSERT INTO marca (codigo,nombre) VALUE('XUN','Xiaomsung');
INSERT INTO marca (codigo,nombre) VALUE('SAI','SANGOMI');
INSERT INTO marca (codigo,nombre) VALUE('XIA','Xiapple');

#-- Telefono.
INSERT INTO telefono (marca_id,modelo,pvp,stock) VALUE(1,'Xiaomsung32',200.99,0);
INSERT INTO telefono (marca_id,modelo,pvp,stock) VALUE(3,'Xiapple13',700.00,100);
INSERT INTO telefono (marca_id,modelo,pvp,stock) VALUE(1,'XS21',100.00,1);
INSERT INTO telefono VALUES (350, 2, 'SangomiA1', 500.00, 20);
INSERT INTO telefono VALUES (210, 1, 'XS22', 250.00, 13);
INSERT INTO telefono VALUES (340, 1, 'XS25', 1000.00, 20);
INSERT INTO telefono VALUES (222, 3, 'APear', 500.00, 21);
INSERT INTO telefono VALUES (221, 3, 'xaMaar', 200.00, 30);
INSERT INTO telefono VALUES (200, 2, 'SangomiA2', 1500.00, 27);
INSERT INTO telefono VALUES (150, 2, 'SangomiALite', 470.00, 43);

#-- Telefono-pedido.
INSERT INTO telefono_pedido VALUES (1, 210, 2);
INSERT INTO telefono_pedido VALUES (2, 222, 1);
INSERT INTO telefono_pedido VALUES (2, 221, 2);
INSERT INTO telefono_pedido VALUES (7, 200, 1);

#-- Telefono-suministrador
INSERT INTO telefono_suministrador VALUES (100, 1, 165.95);
INSERT INTO telefono_suministrador VALUES (101, 1, 624.45);
INSERT INTO telefono_suministrador VALUES (102, 1, 76.75);
INSERT INTO telefono_suministrador VALUES (350, 2, 425.50);
INSERT INTO telefono_suministrador VALUES (210, 3, 210.00);
INSERT INTO telefono_suministrador VALUES (340, 2, 870.25);
INSERT INTO telefono_suministrador VALUES (222, 3, 410.65);
INSERT INTO telefono_suministrador VALUES (221, 3, 165.50);
INSERT INTO telefono_suministrador VALUES (200, 3, 1350.80);
INSERT INTO telefono_suministrador VALUES (150, 3, 400.00);

#-- 1.
SELECT nombre, apellido_1, apellido_2, direccion
	FROM trabajador
    WHERE (apellido_2 IS NULL OR direccion IS NULL) AND apellido_1 LIKE 'C%';

#-- 2.
SELECT dni, nombre
	FROM trabajador
    WHERE dni LIKE '%81X' ;

#-- 3.
SELECT nombre,apellido_1,salario
	FROM trabajador
	WHERE salario BETWEEN 1250 AND 1499;

#-- 4.
SELECT nombre, email
	FROM trabajador
    WHERE email LIKE '%ca@%';

#-- 5.
SELECT COUNT(fecha_nacimiento) AS num_personas, SUM(salario) AS total_eur
   FROM trabajador
   WHERE fecha_nacimiento>'1978-01-01' OR (fecha_nacimiento BETWEEN '1971-01-01' AND '1972-12-30');

#-- 6.
SELECT COUNT(nombre), SUM(salario)
    FROM trabajador
    WHERE salario=1000 AND supervisor_id=1;

#-- 7.
SELECT * FROM trabajador
    WHERE salario*2=2000;

#-- 8.
SELECT dni, nombre, fecha_contrato, salario
    FROM trabajador
    WHERE YEAR(fecha_contrato)<2004 AND RIGHT(dni, 1)='A' AND salario < 1700;

#-- 9.
SELECT CONCAT(nombre, apellido_1), LENGTH(direccion)
    FROM trabajador
    WHERE apellido_1 LIKE('C%');

#-- 10.
SELECT * FROM trabajador
    WHERE YEAR(fecha_nacimiento)>1975;

#-- Actualización de tablas.
ALTER TABLE suministrador ADD nombre VARCHAR(30);
ALTER TABLE suministrador ADD CONSTRAINT uk_suministrador_nombre UNIQUE (nombre);
ALTER TABLE suministrador ADD email VARCHAR(30);

ALTER TABLE pedido DROP importe_total;
ALTER TABLE pedido MODIFY direccion_envio VARCHAR(50) NULL;
    #--Esta modificación de la dirección corresponde a que sólo indicaremos la dirección 
    #-- en el pedido si la dirección de envío(tabla pedido) es distinta a la del cliente(tabla cliente)

#-- Updates de datos.
UPDATE suministrador SET nombre="NewEXX Composites" WHERE id_suministrador=1;
UPDATE suministrador SET nombre="Honne Teshouji" WHERE id_suministrador=2;
UPDATE suministrador SET nombre="Malbrand HW International" WHERE id_suministrador=3;
UPDATE suministrador SET email="nexxcom.att@int.net" WHERE id_suministrador=1;
UPDATE suministrador SET email="hts.engcontact@yuunji.jp" WHERE id_suministrador=2;
UPDATE suministrador SET email="mbhwint.contact@mbh.com" WHERE id_suministrador=3;


#-- Nuevos inserts. 
   #-- Cliente
   INSERT INTO cliente (dni, nombre, apellido, email, telefono, direccion) 
    VALUES ('45222291M','Hannah','Arendt', 'haar@me.com','004567892231','45 Kirchen Strasse, Köln, 56120 RHI Deutschland');
INSERT INTO cliente (dni, nombre, apellido, email, telefono, direccion) 
    VALUES ('52226119W','Franz','Liszt', 'liszt.f@deankht.com','0034444327877','11 Zee Strasse, Tillburg, 5011 Nederland');
INSERT INTO cliente (dni, nombre, apellido, email, telefono, direccion) 
    VALUES ('37287779X','Sally','Brown', 'sb.peanuts@snoop.com','0034664329967','Calle Nadha n66 2o 3a, Ceuta, 44444 CEU');
INSERT INTO cliente (dni, nombre, apellido, email, telefono, direccion) 
    VALUES ('37225591D','Charlie','Brown', 'cb.peanuts@snoop.com','0034664329968','Calle Nadha n66 2o 3a, Ceuta, 44444 CEU');
INSERT INTO cliente (dni, nombre, apellido, email, telefono, direccion) 
    VALUES ('33612342G','Dean','Lonnely', 'highlander@schol.uk','0025654227871','Calle Blanca n10, 1o 2a, Torremolinos, 22211 MAL');
INSERT INTO cliente (dni, nombre, apellido, email, telefono, direccion) 
    VALUES ('39945288Z','Ametz','Torres', 'amto@you.com','0034664227667','Mendiberriak Kalea n17, bj 1a, Andoain 55444 GIZ');
INSERT INTO cliente (dni, nombre, apellido, email, telefono, direccion) 
    VALUES ('44113156W','Caoímhin','Iraeta', 'cair@eoir.com','0034711327811','Calle Rota n99, Gijón 66443 AST');
INSERT INTO cliente (dni, nombre, apellido, email, telefono, direccion) 
    VALUES ('52521322N','Hodei','Aginalde', 'hoag@aldea.com','0032151127117','Rue de la Défénse n7, Alès 77777 France');
INSERT INTO cliente (dni, nombre, apellido, email, telefono, direccion) 
    VALUES ('39188290T','Iratxe','Salaberria', 'irsa@txeberria.com','0034552668991','Irigoyen Kalea n12, 3o 2a, Hernani 55423 GIZ');
INSERT INTO cliente (dni, nombre, apellido, email, telefono, direccion) 
    VALUES ('42226691Z','Eithne','Hernández', 'eihdz@hermn.com','0034714227111','Pl. Fuente Colorada n2, 1o 1a, Cadiz, 22131 CAD');

   #-- Transportista
INSERT INTO transportista VALUES (2, '44355611C', "SEUR", 'grg.orwell@seur.com', '0034874678883', '16, Xinghai Rd, Suzhou 666667 ANH China');
INSERT INTO transportista VALUES (3, '61126211B', 'GLS', 'srg.rachmaninoff@gls.com', '003546472268', NULL);

  #-- Marca
INSERT INTO marca (codigo,nombre) VALUES('SXN','Sanxing');
INSERT INTO marca (codigo,nombre) VALUES('ZTE','Zhongguo TeleEn');

    #-- País
INSERT INTO pais (codigo,nombre) VALUES('CHA','Chad');
INSERT INTO pais (codigo,nombre) VALUES('MAD','Madagascar');

  #-- trabajador
INSERT INTO trabajador (supervisor_id,dni,nombre,apellido_1,apellido_2,email,telefono,direccion,salario,fecha_nacimiento,fecha_contrato) 
    VALUE(1,'96916391A','Godwyn','Romulo','Cornejo','pafraumeittei@gmail.com',198756432,'Barcelona',1250,'1973-03-25','2001-02-01');
INSERT INTO trabajador (supervisor_id,dni,nombre,apellido_1,apellido_2,email,telefono,direccion,salario,fecha_nacimiento,fecha_contrato) 
    VALUE(1,'73780315H','Matias','Gálvez','Ferréndez','jaupeppewiwu-3680@gmail.com',98756421,'Barcelona',1250,'1973-03-25','2001-02-01');
INSERT INTO trabajador (supervisor_id,dni,nombre,apellido_1,apellido_2,email,telefono,direccion,salario,fecha_nacimiento,fecha_contrato) 
    VALUE(1,'21422296G','Begoña','Espinosa','Villalonga','freheiff4989@gmail.com',645132975,'Barcelona',1250,'1973-03-25','2001-02-01');
INSERT INTO trabajador (supervisor_id,dni,nombre,apellido_1,apellido_2,email,telefono,direccion,salario,fecha_nacimiento,fecha_contrato) 
    VALUE(1,'33786423K','Custodio ','Mata ','Larrea','froumouk-4009@gmail.com',465879135,'Barcelona',1250,'1973-03-25','2001-02-01');
INSERT INTO trabajador (supervisor_id,dni,nombre,apellido_1,apellido_2,email,telefono,direccion,salario,fecha_nacimiento,fecha_contrato) 
    VALUE(1,'21444273Q','Noemí ','Pablo','Villena','depeideis-5438@gmail.com',566789789,'Barcelona',1250,'1973-03-25','2001-02-01');
INSERT INTO trabajador (supervisor_id,dni,nombre,apellido_1,apellido_2,email,telefono,salario,fecha_nacimiento,fecha_contrato)
    VALUE(2,'70017706W','Íñigo ','Navas','Palomar','zagroutrig@gmail.com',789745681,1200,'1971-04-26','2001-09-01');
INSERT INTO trabajador (supervisor_id,dni,nombre,apellido_1,apellido_2,email,telefono,salario,fecha_nacimiento,fecha_contrato)
    VALUE(2,'57313696L','Victor ','Manuel ','Reig ','treteibae@gmail.com',195843264,1200,'1971-04-26','2001-09-01');
INSERT INTO trabajador (supervisor_id,dni,nombre,apellido_1,apellido_2,email,telefono,salario,fecha_nacimiento,fecha_contrato)
    VALUE(2,'73804760Z','Reyes ','Peiró','Perona','weippessubr@gmail.com',7894561235,1200,'1971-04-26','2001-09-01');
INSERT INTO trabajador (supervisor_id,dni,nombre,apellido_1,apellido_2,email,telefono,salario,fecha_nacimiento,fecha_contrato)
    VALUE(2,'28348230V','Maricela ','Garmendia','Juanlandia','sufibtissi@gmail.com',953624875,1200,'1971-04-26','2001-09-01');
INSERT INTO trabajador (supervisor_id,dni,nombre,apellido_1,apellido_2,email,telefono,salario,fecha_nacimiento,fecha_contrato)
    VALUE(2,'06740826D','Moreno ','Atienza ','Carbó','tauzoinui@gmail.com',194875612,1200,'1971-04-26','2001-09-01');

    #-- Técnico
INSERT INTO tecnico VALUES(11, 'Hardware');
INSERT INTO tecnico VALUES(12, 'Software');
INSERT INTO tecnico VALUES (13, 'Hardware');
INSERT INTO tecnico VALUES (14, 'Software');
INSERT INTO tecnico VALUES (15, 'Hardware');
INSERT INTO tecnico VALUES (16, 'Software');

    #-- Comercial
INSERT INTO comercial VALUE(17);
INSERT INTO comercial VALUE(18);
INSERT INTO comercial VALUE(19);
INSERT INTO comercial VALUE(20);
INSERT INTO comercial VALUE(21);

  #-- Suministrador
INSERT INTO suministrador (pais_id,comercial_id,nombre,email) VALUES (4,20,'Juligan An','juan@gmail.com');
INSERT INTO suministrador (pais_id,comercial_id,nombre,email) VALUES (5,21,'Permutar drones','pedro@gmail.com');

    #--telefono
INSERT INTO telefono VALUES (549, 4, 'movilsan', 700.00, 0);
INSERT INTO telefono VALUES (684, 5, 'Ztemovile2', 450.00, 99);
INSERT INTO telefono VALUES (468, 3, 'Apear2', 1500.00, 21);
INSERT INTO telefono VALUES (879, 1, 'XS34', 500.00, 22);
INSERT INTO telefono VALUES (123, 4, 'movilsan24', 250.00, 20);
INSERT INTO telefono VALUES (651, 5, 'Ztemov23', 1700.00, 1);
INSERT INTO telefono VALUES (135, 5, 'Ztemovile', 300.00, 39);
INSERT INTO telefono VALUES (548, 4, 'movilsan4', 800.00, 1);
INSERT INTO telefono VALUES (683, 5, 'Ztemovile3', 900.00, 3);

    #-- Telefono-suministrador
INSERT INTO telefono_suministrador VALUES (549, 4, 125.95);
INSERT INTO telefono_suministrador VALUES (683, 5, 90.45);
INSERT INTO telefono_suministrador VALUES (684, 4, 76.75);
INSERT INTO telefono_suministrador VALUES (468, 3, 825.50);
INSERT INTO telefono_suministrador VALUES (210, 5, 510.00);
INSERT INTO telefono_suministrador VALUES (651, 3, 840.25);
INSERT INTO telefono_suministrador VALUES (123, 2, 1410.65);
INSERT INTO telefono_suministrador VALUES (651, 1, 135.50);
INSERT INTO telefono_suministrador VALUES (879, 4, 140.80);
INSERT INTO telefono_suministrador VALUES (548, 5, 300.00);
    
    #-- Incidencia
INSERT INTO incidencia (cliente_id, tecnico_supervisor, descripcion, fecha_notificacion, fecha_inicio, fecha_resolucion)
   VALUES (10, 2, 'Pedido incorrecto', '2022-09-11 20:12:51', '2022-09-12 13:11:14', '2022-10-01 09:11:14');
INSERT INTO incidencia (cliente_id, tecnico_supervisor, descripcion, fecha_notificacion, fecha_inicio, fecha_resolucion)
   VALUES (11, 2, 'No va OS', '2022-09-19 09:52:34', '2022-09-20 14:25:13', '2022-09-23 15:55:11');
INSERT INTO incidencia (cliente_id, tecnico_supervisor, descripcion, fecha_notificacion, fecha_inicio, fecha_resolucion)
   VALUES (10, 3, 'Reembolso', '2022-10-01 09:11:14', '2022-10-01 09:12:14', '2022-10-01 12:23:11');
INSERT INTO incidencia (cliente_id, tecnico_supervisor, descripcion, fecha_notificacion, fecha_inicio, fecha_resolucion)
   VALUES (15, 1, 'Telefono roto', '2022-10-01 12:11:54', '2022-10-14 15:40:11', '2022-10-14 19:54:11');
INSERT INTO incidencia (cliente_id, tecnico_supervisor, descripcion, fecha_notificacion, fecha_inicio, fecha_resolucion)
   VALUES (12, 2, 'No va OS', '2022-10-02 15:02:34', '2022-10-20 11:25:13', '2022-10-23 09:55:11');
INSERT INTO incidencia (cliente_id, tecnico_supervisor, descripcion, fecha_notificacion, fecha_inicio, fecha_resolucion)
   VALUES (14, 7, 'Pantalla rota', '2022-10-05 15:41:54', '2022-10-07 11:11:55', '2022-10-11 13:45:12');
INSERT INTO incidencia (cliente_id, tecnico_supervisor, descripcion, fecha_notificacion, fecha_inicio, fecha_resolucion)
   VALUES (13, 1, 'Telefono roto', '2022-10-09 10:02:14', '2022-10-14 13:40:11', '2022-10-17 09:55:53');
INSERT INTO incidencia (cliente_id, tecnico_supervisor, descripcion, fecha_notificacion, fecha_inicio, fecha_resolucion)
   VALUES (20, 2, 'No va OS', '2022-10-12 08:52:34', '2022-10-20 18:15:23', '2022-10-23 16:55:11');
INSERT INTO incidencia (cliente_id, tecnico_supervisor, descripcion, fecha_notificacion, fecha_inicio, fecha_resolucion)
   VALUES (6, 7, 'Telefono roto', '2022-10-12 17:14:54', '2022-10-29 14:34:55', '2022-11-03 12:33:11');
INSERT INTO incidencia (cliente_id, tecnico_supervisor, descripcion, fecha_notificacion, fecha_inicio, fecha_resolucion)
   VALUES (19, 1, 'Telefono roto', '2022-10-14 12:11:31', '2022-11-14 15:40:11', '2022-12-14 16:16:29');
INSERT INTO incidencia (cliente_id, tecnico_supervisor, descripcion, fecha_notificacion, fecha_inicio, fecha_resolucion)
   VALUES (8, 2, 'No va OS', '2022-10-19 20:22:34', '2022-10-20 11:25:13', '2022-10-23 19:34:21');
INSERT INTO incidencia (cliente_id, tecnico_supervisor, descripcion, fecha_notificacion, fecha_inicio, fecha_resolucion)
   VALUES (7, 7, 'Telefono roto', '2022-10-21 19:49:21', '2022-11-11 11:24:51', NULL);
INSERT INTO incidencia (cliente_id, tecnico_supervisor, descripcion, fecha_notificacion, fecha_inicio, fecha_resolucion)
   VALUES (18, 1, 'Pantalla rota', '2022-10-21 21:06:11', '2022-11-14 08:20:11', NULL);
INSERT INTO incidencia (cliente_id, tecnico_supervisor, descripcion, fecha_notificacion, fecha_inicio, fecha_resolucion)
   VALUES (9, 3, 'Retraso pedido', '2022-10-22 14:52:34', '2022-11-20 11:15:23', '2022-11-23 19:25:21');
INSERT INTO incidencia (cliente_id, tecnico_supervisor, descripcion, fecha_notificacion, fecha_inicio, fecha_resolucion)
   VALUES (14, 7, 'Telefono roto', '2022-10-23 19:31:12', '2022-11-29 17:24:43', '2022-11-30 11:30:10');
INSERT INTO incidencia (cliente_id, tecnico_supervisor, descripcion, fecha_notificacion, fecha_inicio, fecha_resolucion)
   VALUES (11, 1, 'Telefono roto', '2022-10-28 13:12:54', '2022-11-11 15:40:11', NULL);
INSERT INTO incidencia (cliente_id, tecnico_supervisor, descripcion, fecha_notificacion, fecha_inicio, fecha_resolucion)
   VALUES (12, 2, 'No va OS', '2022-11-07 10:12:34', '2022-11-20 11:25:13', '2022-11-23 12:31:41');
INSERT INTO incidencia (cliente_id, tecnico_supervisor, descripcion, fecha_notificacion, fecha_inicio, fecha_resolucion)
   VALUES (14, 7, 'Telefono roto', '2022-11-07 17:11:14', '2022-11-10 11:22:15', NULL);
INSERT INTO incidencia (cliente_id, tecnico_supervisor, descripcion, fecha_notificacion, fecha_inicio, fecha_resolucion)
   VALUES (11, 1, 'Telefono roto', '2022-11-14 16:11:23', '2022-11-16 10:10:11', NULL);
    
    #-- Incidencia_tecnico
INSERT INTO incidencia_tecnico VALUES (4, 3);
INSERT INTO incidencia_tecnico VALUES (5, 2);
INSERT INTO incidencia_tecnico VALUES (5, 16);
INSERT INTO incidencia_tecnico VALUES (6, 3);
INSERT INTO incidencia_tecnico VALUES (7, 2);
INSERT INTO incidencia_tecnico VALUES (7, 14);
INSERT INTO incidencia_tecnico VALUES (7, 12);
INSERT INTO incidencia_tecnico VALUES (8, 3);
INSERT INTO incidencia_tecnico VALUES (9, 1);
INSERT INTO incidencia_tecnico VALUES (9, 2);
INSERT INTO incidencia_tecnico VALUES (10, 2);
INSERT INTO incidencia_tecnico VALUES (10, 16);
INSERT INTO incidencia_tecnico VALUES (10, 12);
INSERT INTO incidencia_tecnico VALUES (11, 7);
INSERT INTO incidencia_tecnico VALUES (11, 11);
INSERT INTO incidencia_tecnico VALUES (12, 1);
INSERT INTO incidencia_tecnico VALUES (12, 13);
INSERT INTO incidencia_tecnico VALUES (13, 2);
INSERT INTO incidencia_tecnico VALUES (13, 16);
INSERT INTO incidencia_tecnico VALUES (14, 7);
INSERT INTO incidencia_tecnico VALUES (14, 11);
INSERT INTO incidencia_tecnico VALUES (15, 1);
INSERT INTO incidencia_tecnico VALUES (15, 7);
INSERT INTO incidencia_tecnico VALUES (16, 2);
INSERT INTO incidencia_tecnico VALUES (16, 12);
INSERT INTO incidencia_tecnico VALUES (17, 7);
INSERT INTO incidencia_tecnico VALUES (18, 1);
INSERT INTO incidencia_tecnico VALUES (18, 11);
INSERT INTO incidencia_tecnico VALUES (19, 3);
INSERT INTO incidencia_tecnico VALUES (20, 7);
INSERT INTO incidencia_tecnico VALUES (20, 15);
INSERT INTO incidencia_tecnico VALUES (21, 1);
INSERT INTO incidencia_tecnico VALUES (21, 13);
INSERT INTO incidencia_tecnico VALUES (22, 2);
INSERT INTO incidencia_tecnico VALUES (22, 12);
INSERT INTO incidencia_tecnico VALUES (22, 14);

    #-- Pedido
INSERT INTO pedido
   VALUES (3, 1, 2, NULL, 'R', '2022-11-30', '2022-12-05 14:55:00');
INSERT INTO pedido
   VALUES (4, 2, 3, NULL, 'R', '2022-12-11', '2022-12-19 13:22:15');
INSERT INTO pedido
   VALUES (5, 4, 5, NULL, 'R', '2021-12-11', '2022-12-21 17:31:11');
INSERT INTO pedido
   VALUES (6, 5, 5, NULL, 'R', '2022-12-14', '2022-12-17 14:55:00');
INSERT INTO pedido
   VALUES (8, 10, 2, NULL, 'R', '2022-12-19', '2022-12-23 09:11:52');
INSERT INTO pedido
   VALUES (9, 11, 1, NULL, 'R', '2021-12-21', '2023-01-03 16:11:31');
INSERT INTO pedido
   VALUES (10, 12, 2, NULL, 'R', '2022-12-22', '2023-01-04 11:15:00');
INSERT INTO pedido
   VALUES (11, 3, 7, 'Elm Str n2 p3, Pueblo Caoba, 18215 TOL', 'P', NULL, NULL);
INSERT INTO pedido
   VALUES (12, 19, 1, NULL, 'E', '2023-01-02', NULL);
INSERT INTO pedido
   VALUES (13, 13, 5, NULL, 'R', '2023-01-02', '2023-01-07 11:43:10');
INSERT INTO pedido
   VALUES (14, 16, 7, NULL, 'P', NULL, NULL);
INSERT INTO pedido
   VALUES (15, 17, 3, NULL, 'E', '2023-01-04', NULL);
INSERT INTO pedido
   VALUES (16, 11, 2, NULL, 'R', '2023-01-11', '2023-01-14 13:21:21');
INSERT INTO pedido
   VALUES (17, 18, 7, NULL, 'P', NULL, NULL);
INSERT INTO pedido
   VALUES (18, 14, 3, NULL, 'E', '2023-01-11', NULL);
INSERT INTO pedido
   VALUES (19, 15, 1, NULL, 'R', '2023-01-12', '2023-01-15 10:18:56');
INSERT INTO pedido
   VALUES (20, 3, 7, 'Elm Str n2 p3, Pueblo Caoba, 18215 TOL', 'P', NULL, NULL);
INSERT INTO pedido
   VALUES (21, 7, 1, 'Playa la Concha, San Sebastián, 55555 GIZ', 'E', '2001-01-01', NULL);

    #-- Telefono-pedido.
INSERT INTO telefono_pedido VALUES (3, 100, 2);
INSERT INTO telefono_pedido VALUES (3, 210, 1);
INSERT INTO telefono_pedido VALUES (4, 101, 1);
INSERT INTO telefono_pedido VALUES (5, 221, 1);
INSERT INTO telefono_pedido VALUES (5, 102, 1);
INSERT INTO telefono_pedido VALUES (6, 200, 1);
INSERT INTO telefono_pedido VALUES (8, 123, 1);
INSERT INTO telefono_pedido VALUES (8, 135, 1);
INSERT INTO telefono_pedido VALUES (8, 340, 2);
INSERT INTO telefono_pedido VALUES (9, 135, 1);
INSERT INTO telefono_pedido VALUES (10, 221, 1);
INSERT INTO telefono_pedido VALUES (10, 651, 1);
INSERT INTO telefono_pedido VALUES (11, 200, 1);
INSERT INTO telefono_pedido VALUES (12, 879, 2);
INSERT INTO telefono_pedido VALUES (13, 222, 1);
INSERT INTO telefono_pedido VALUES (13, 340, 1);
INSERT INTO telefono_pedido VALUES (14, 221, 2);
INSERT INTO telefono_pedido VALUES (15, 684, 1);
INSERT INTO telefono_pedido VALUES (16, 468, 2);
INSERT INTO telefono_pedido VALUES (17, 548, 1);
INSERT INTO telefono_pedido VALUES (18, 221, 1);
INSERT INTO telefono_pedido VALUES (18, 350, 1);
INSERT INTO telefono_pedido VALUES (19, 684, 1);
INSERT INTO telefono_pedido VALUES (20, 150, 1);
INSERT INTO telefono_pedido VALUES (20, 548, 2);
INSERT INTO telefono_pedido VALUES (21, 879, 5);

#--1. Muestra aquellos trabajadores que son supervisores de alguien
SELECT tr.nombre
	FROM trabajador AS tr
WHERE supervisor_id IS NULL;

#--2. Muestra los clientes a los que se les ha entregado el pedido
SELECT cl.nombre
	FROM cliente AS cl
    INNER JOIN pedido AS pe ON cl.id_cliente=pe.cliente_id
    WHERE pe.estado='E';

#--3. Muestra a los trabajadores que tienen supervisores ordenados
SELECT tr.nombre
	FROM trabajador AS tr
WHERE supervisor_id IS NOT NULL
ORDER BY tr.nombre ASC;

#--4. Muestra cuántas incidencias hay en total
SELECT COUNT(*) AS Numero_incidencias,descripcion
	FROM incidencia AS inc
    GROUP BY inc.descripcion;
    
#--5. Muestra todos los nombres de los clientes y trabajadores
	(SELECT cl.nombre,'Cliente'
	FROM cliente AS cl)
    UNION
	(SELECT tr.nombre,'Trabajador'
	FROM trabajador AS tr
);
#--6. Muestra el nombre de aquellos clientes que tienen móviles de Japón
SELECT cl.nombre
	FROM cliente AS cl
    INNER JOIN pedido AS pe ON cl.id_cliente=pe.cliente_id
    INNER JOIN telefono_pedido AS pete ON pete.id_pedido=pe.id_pedido
    INNER JOIN telefono AS te ON te.id_telefono=pete.id_telefono
    INNER JOIN telefono_suministrador AS tesu ON te.id_telefono=tesu.id_telefono
    INNER JOIN suministrador AS sumi ON tesu.id_suministrador=sumi.id_suministrador
    INNER JOIN pais AS pa ON pa.id_pais=sumi.pais_id
    WHERE pa.nombre='Japon'
    GROUP BY cl.nombre;

#--7. Muestra cuántos móviles ha pedido cada cliente
SELECT cl.nombre,COUNT(*) AS moviles_clientes
	FROM cliente AS cl RIGHT JOIN pedido as pe ON cl.id_cliente=pe.cliente_id
    GROUP BY cl.nombre;


#--8. Devuelve el nombre, el primer apellido y el salario de todos los trabajadores con salario menor a 1400€
#-- y en el caso de ser comercial, la empresa suministradora de la cual se encargan
SELECT CONCAT(tr.nombre, ' ', tr.apellido_1) as nombre, tr.salario as salario, sum.nombre as suministradora
   FROM trabajador tr
   LEFT JOIN comercial com ON tr.id_trabajador=com.id_comercial
   INNER JOIN suministrador sum ON com.id_comercial=sum.comercial_id 
   WHERE tr.salario<1400;


#--9. Devuelve el nombre, el primer apellido, la fecha de contratación y el salario
#-- de aquellos trabajadores cuyo contrato se firmara a partir del año 2002 en adelante
#-- e indica si son técnicos o comerciales
(SELECT CONCAT(tr.nombre, ' ', tr.apellido_1) as nombre, tr.fecha_contrato as fecha_contratación, tr.salario as salario, 'Técnico' as categoria
   FROM trabajador tr
   RIGHT JOIN tecnico tec ON tr.id_trabajador=tec.id_tecnico
   WHERE tr.fecha_contrato>='2002-01-01')
UNION
(SELECT CONCAT(tr.nombre, ' ', tr.apellido_1) as nombre, tr.fecha_contrato as fecha_contratación, tr.salario as salario, 'Comercial'
   FROM trabajador tr
   RIGHT JOIN comercial com ON tr.id_trabajador=com.id_comercial
   WHERE tr.fecha_contrato>='2002-01-01');

#--10. Muestra el nombre y el dinero total que ha gastado en pedidos cada cliente de cuyas incidencias 
#-- se ha ocupado el técnico Cynthia Concepcion y ha hecho al menos un pedido
SELECT nombre, total_gastado
   FROM (
      SELECT nombre, id_cliente,
         (SELECT SUM(tlf.pvp*tp.cantidad) as total_gastado
         FROM pedido ped
         INNER JOIN telefono_pedido tp ON ped.id_pedido=tp.id_pedido
         INNER JOIN telefono tlf ON tp.id_telefono=tlf.id_telefono
         WHERE ped.cliente_id=cl.id_cliente
         ) as total_gastado
      FROM cliente cl) as resultado
   WHERE resultado.id_cliente IN 
      (SELECT DISTINCT cl.id_cliente
         FROM cliente cl
         INNER JOIN incidencia inc ON cl.id_cliente=inc.cliente_id
         INNER JOIN incidencia_tecnico itec ON inc.id_incidencia=itec.id_incidencia
         INNER JOIN tecnico tec ON itec.id_tecnico=tec.id_tecnico
         INNER JOIN trabajador tr ON tec.id_tecnico=tr.id_trabajador
         WHERE tr.nombre LIKE ('%Cynthia%') AND tr.apellido_1 LIKE ('%Concepcion%'))
   AND total_gastado>0;

#--11. Muestra el modelo de tlf y la cantidad que hemos vendido de todos aquellos que al menos hayan sido comprados dos veces
   SELECT tlf.modelo AS modelo, COUNT(tp.id_telefono) AS veces_vendido
      FROM telefono tlf
      RIGHT JOIN telefono_pedido tp ON tlf.id_telefono=tp.id_telefono
      GROUP BY tlf.id_telefono
      HAVING COUNT(tp.id_telefono)>1;


#--12. Muestra el modelo de tlf, el precio y la cantidad que hemos vendido de todos aquellos modelos que cuesten más de 250€
   SELECT tlf.modelo AS modelo, tlf.pvp as precio, COUNT(tp.id_telefono) AS veces_vendido
      FROM telefono tlf
      RIGHT JOIN telefono_pedido tp ON tlf.id_telefono=tp.id_telefono   
      WHERE tlf.pvp>250
      GROUP BY tp.id_telefono;

#--13. Muestra las marcas, ordenadas de mayor a menor según la cantidad de dispositivos que hayamos vendido de cada una y
#-- muestra también la cantidad de dispositivos de cada marca
SELECT mrk.nombre AS nombre_marca, COUNT(tp.id_telefono) AS dispositivos_vendidos
   FROM marca mrk
   INNER JOIN telefono tlf ON mrk.id_marca=tlf.marca_id
   INNER JOIN telefono_pedido tp ON tlf.id_telefono=tp.id_telefono
   GROUP BY tlf.marca_id
   ORDER BY dispositivos_vendidos DESC;

#--14. Para comprobar la anterior consulta, mostramos el nombre, la marca y la cantidad vendida de cada modelo
#-- de teléfono ordenado alfabéticamente por nombre de modelo
SELECT tlf.modelo AS nombre_modelo, mrk.nombre AS nombre_marca, COUNT(tp.id_telefono) AS dispositivos_vendidos
   FROM marca mrk
   INNER JOIN telefono tlf ON mrk.id_marca=tlf.marca_id
   INNER JOIN telefono_pedido tp ON tlf.id_telefono=tp.id_telefono
   GROUP BY tlf.id_telefono
   ORDER BY nombre_modelo;

-- Pràctica UF3P1 - Usuaris i permisos

#-- Usuarios y permisos
#-- La documentacion de los permisos se encuentra en: Documentacion pemisos m2
USE moviles;

#-- Creación superadministrador 
#-- SELECT PASSWORD('phone');
CREATE USER jjosue IDENTIFIED BY '*A655F0E73BC30CA4CFDDE7D4DFBC558521C08ABE';
GRANT ALL PRIVILEGES ON *.* TO jjosue WITH GRANT OPTION;

#-- Supervisor
CREATE USER juan IDENTIFIED BY 'admin';
CREATE ROLE supervisor;
GRANT ALL PRIVILEGES ON moviles.* TO supervisor WITH GRANT OPTION;
REVOKE DELETE ON moviles.* FROM supervisor;
GRANT supervisor TO juan;

#-- Técnicos
CREATE ROLE tecnico;
GRANT SELECT,UPDATE,INSERT ON incidencia_tecnico TO tecnico;
GRANT SELECT,UPDATE,INSERT,DELETE ON incidencia TO tecnico;
GRANT SELECT,UPDATE ON cliente TO tecnico;
GRANT SELECT,UPDATE,INSERT,DELETE ON pedido TO tecnico;
GRANT SELECT,UPDATE,INSERT,DELETE ON telefono_pedido TO tecnico;

CREATE USER luigi IDENTIFIED BY 'tecnico';
CREATE USER joselito IDENTIFIED BY '123';
GRANT tecnico TO luigi,joselito;
GRANT SELECT ON transportista TO luigi;
    
#-- CREACION roles:comercial
CREATE ROLE comercial;
GRANT SELECT, INSERT, DELETE ON moviles.suministrador TO comercial;
GRANT SELECT, INSERT ON moviles.marca TO comercial;
GRANT ALL PRIVILEGES ON moviles.telefono_suministrador TO comercial;
GRANT SELECT, INSERT, UPDATE(pvp, stock)
	ON moviles.telefono TO comercial;

#-- Usuarios Comerciales
CREATE USER marrua IDENTIFIED BY 'arrua';
CREATE USER nortega IDENTIFIED BY 'ortega';
CREATE USER kcardozo IDENTIFIED BY 'cardozo';
CREATE USER pcalero IDENTIFIED BY 'calero';

#-- Asignación de roles
GRANT comercial TO marrua,nortega,kcardozo,pcalero;


#-- Usuario cliente.
CREATE USER cliente IDENTIFIED BY 'tpbclient';
GRANT SELECT(dni,nombre,apellido,email,telefono,direccion), UPDATE(email,telefono,direccion)
	ON moviles.cliente TO cliente; 
GRANT SELECT(id_pedido,direccion_envio,estado), UPDATE(direccion)	
	ON moviles.pedido TO cliente;
GRANT SELECT(id_incidencia, descripcion, fecha_notificacion, fecha_resolucion), INSERT(descripcion), UPDATE(descripcion) 
	ON moviles.incidencia TO cliente;


FLUSH PRIVILEGES;


/* ________ Pràctica PROGRAMACIó CONDICIONAL ___________ */

USE moviles;

/* 
1. Inserta trabajadores indicando si son técnicos (T) o comerciales (C). De inicio, no tendrán especialización, 
en el caso de los técnicos, ni suministrador asignado en el caso de los comerciales.
*/

DELIMITER //
CREATE PROCEDURE insertaTrabajador(IN in_supervisor SMALLINT(3), IN in_dni VARCHAR(9), IN in_nombre VARCHAR(20),
									IN in_ap1 VARCHAR(20), IN in_ap2 VARCHAR(20), IN in_email VARCHAR(30), IN in_direccion VARCHAR(50),
                                    IN in_salario DECIMAL(7, 2), IN in_fecha_nac DATE, IN in_fecha_contr DATE , IN tipo_trabajador CHAR(1))
BEGIN
DECLARE id_temp INT;

	INSERT INTO trabajador (supervisor_id, dni, nombre, apellido_1, apellido_2, email, direccion, salario, fecha_nacimiento, 		fecha_contrato) 
	VALUES (in_supervisor, in_dni, in_nombre, in_ap1, in_ap2, in_email, in_direccion, in_salario, in_fecha_nac, in_fecha_contr);

	SET id_temp = LAST_INSERT_ID();	

	CASE tipo_trabajador
		WHEN 'C' THEN INSERT INTO comercial VALUES (id_temp);
		WHEN 'T' THEN INSERT INTO tecnico (id_tecnico) VALUES (id_temp);
	END CASE;
END//
DELIMITER ;

CALL insertaTrabajador(1, '44170797F', 'Aitana', 'Sánchez', 'Hernández', 'sanherait@nos.com', 'Terrassa', 1400, '1998-07-21', '2020-03-15', 'T');
CALL insertaTrabajador(2, '51876091C', 'Atenea', 'Arcos', 'Egea', 'ate@olymp.com', 'Meteora', 1350, '1993-11-21', '2018-10-02', 'C');
SELECT id_trabajador, nombre, apellido_1 FROM trabajador;
SELECT id_tecnico FROM tecnico;
SELECT id_comercial FROM comercial;


/* 
2. Procedimiento que aplica un descuento o un aumento porcentual indicando el precio original y el descuento. Le pasamos un double y un porcentaje (negativo o positivo) de tipo double y nos devolverá el numero inicial con el cambio porcentual aplicado.
*/

DELIMITER //
CREATE PROCEDURE cambioPorcentaje (INOUT x DOUBLE, IN porcentaje DOUBLE)
BEGIN
DECLARE cambio DOUBLE;

SET cambio = TRUNCATE(porcentaje/100, 4);
SET x = x+TRUNCATE(x*cambio, 2);

END//
DELIMITER ;

SET @precio = 100.23342;
CALL cambioPorcentaje(@precio, -10.5);
SELECT @precio;


/*
3. Pasamos la id de un pedido y nos devuelve el estado y las fechas de envío y de entrega del pedido correspondiente a esa id
 */

DELIMITER //
CREATE PROCEDURE getPedidoById (IN in_id_pedido INT, OUT estado_pedido ENUM('P', 'E', 'R'), OUT f_envio DATE, OUT f_entrega DATE)
BEGIN
SELECT estado, fecha_envio, fecha_entrega INTO estado_pedido, f_envio, f_entrega FROM pedido WHERE id_pedido = in_id_pedido;
END//
DELIMITER ;
CALL getPedidoById(1, @estado, @f_envio, @f_entrega);
SELECT @estado, @f_envio, @f_entrega;


/*
4. Recorre todos los pedidos y comprueba los estados según las fechas de envio y entrega. Si hay fecha de envio pero no de entrega comprobará que el estado sea E, en caso contrario hará un update del estado. Si no tiene fecha de envio ni de entrega, lo mismo con P. Por último si tiene todas las fechas, el mismo procedimiento con R.
*/

DELIMITER //
CREATE PROCEDURE actualizaEstadoPedidos ()
BEGIN

DECLARE contador INT;
DECLARE max INT;
DECLARE estado CHAR;
DECLARE f_envio DATE;
DECLARE f_entrega DATE;

SET contador = (SELECT MIN(id_pedido) FROM pedido);
SET max = (SELECT MAX(id_pedido) FROM pedido);

REPEAT
	CALL getPedidoById(contador, estado, f_envio, f_entrega);
    -- Sería más eficiente haciendo solo un get y que traiga todos los datos.
    IF ((f_envio IS NULL) AND (f_entrega IS NULL) AND (estado <> 'P')) THEN
		UPDATE pedido SET estado = 'P' WHERE id_pedido = contador;
	ELSEIF ((f_envio IS NOT NULL) AND (f_entrega IS NULL) AND (estado <> 'E')) THEN
		UPDATE pedido SET estado = 'E' WHERE id_pedido = contador;
	ELSEIF ((f_entrega IS NOT NULL) AND (estado <> 'R')) THEN
		UPDATE pedido SET estado = 'R' WHERE id_pedido = contador;
	END IF;
	SET contador = contador+1;
UNTIL (contador=max+1)

END REPEAT;
END//
DELIMITER ;

UPDATE pedido SET estado = 'P' WHERE id_pedido IN (1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
UPDATE pedido SET estado = 'E' WHERE id_pedido IN (11, 12, 13, 14, 15);
UPDATE pedido SET estado = 'R' WHERE id_pedido IN (16, 17, 18, 19, 20, 21);
SELECT id_pedido, estado, fecha_envio, fecha_entrega FROM pedido;
CALL actualizaEstadoPedidos();
SELECT id_pedido, estado, fecha_envio, fecha_entrega FROM pedido;


/* 
5. Procedimiento al que le pasamos la id de un pedido y nos devuelve devuelva una tabla con el id y el importe total.
*/

DELIMITER //
CREATE PROCEDURE getImporteTotalByIdPedido (IN in_id_pedido INT)
BEGIN
SELECT tp.id_pedido, SUM(tp.cantidad*te.pvp) AS total
	FROM telefono_pedido tp
    INNER JOIN telefono te ON tp.id_telefono = te.id_telefono
    WHERE tp.id_pedido = in_id_pedido;
END//
DELIMITER ;
CALL getImporteTotalByIdPedido(1);
CALL getImporteTotalByIdPedido(2); 


/* 
6. Dada una fecha F y un numero de dias N, elimina todas las incidencias que lleven resueltas N dias desde la fecha F indicada. 
Si no hay incidencias por borrar o los datos no son correctos devuelve un error.
*/

DELIMITER //
CREATE PROCEDURE eliminaIncidencias(IN fecha DATE, IN dias SMALLINT, OUT err VARCHAR(100))
BEGIN

DECLARE dia_anterior DATE;
DECLARE ultimo_dia DATE;
DECLARE control BOOLEAN;
DECLARE contador SMALLINT;
DECLARE borra_id INT;

SET contador=0;

IF (fecha IS NULL OR dias IS NULL) THEN
    SET err = "No ha introducido datos correctos.";
ELSE
	SET dia_anterior = fecha;
    SET control = FALSE;
    SET ultimo_dia = DATE_ADD(fecha, INTERVAL -1*dias DAY);
	WHILE (dia_anterior > ultimo_dia) DO    
        IF EXISTS(SELECT id_incidencia FROM incidencia WHERE DATE(fecha_notificacion)=dia_anterior AND fecha_resolucion IS NOT NULL) THEN	   
			SET borra_id = (SELECT id_incidencia FROM incidencia WHERE DATE(fecha_notificacion)=dia_anterior AND fecha_resolucion IS NOT NULL);
            DELETE FROM incidencia_tecnico WHERE id_incidencia = borra_id;
            DELETE FROM incidencia WHERE id_incidencia = borra_id;
			SET control = TRUE;
            SET contador = contador+1;
        END IF;
        SET dia_anterior = DATE_ADD(dia_anterior, INTERVAL -1 DAY);
    END WHILE;
    IF (control = FALSE) THEN
		SET err = "No se ha encontrado ninguna incidencia resuelta en el periodo indicado.";
	ELSE SET err=CONCAT("Se han eliminado ",contador, " registros." );
	END IF;
END IF;

END//
DELIMITER ;

CALL eliminaIncidencias('2021-09-10',10, @error);
CALL eliminaIncidencias('2022-12-21',NULL, @error);
CALL eliminaIncidencias(NULL,20, @error);
SELECT id_incidencia, fecha_notificacion, fecha_resolucion FROM incidencia;
CALL eliminaIncidencias('2022-10-28', 8, @error);
SELECT @error;
SELECT id_incidencia, fecha_notificacion, fecha_resolucion FROM incidencia;
-- Insert dels registres afectats
INSERT INTO incidencia (cliente_id, tecnico_supervisor, descripcion, fecha_notificacion, fecha_inicio, fecha_resolucion)
   VALUES (9, 3, 'Retraso pedido', '2022-10-22 14:52:34', '2022-11-20 11:15:23', '2022-11-23 19:25:21');
INSERT INTO incidencia (cliente_id, tecnico_supervisor, descripcion, fecha_notificacion, fecha_inicio, fecha_resolucion)
   VALUES (14, 7, 'Telefono roto', '2022-10-23 19:31:12', '2022-11-29 17:24:43', '2022-11-30 11:30:10');
INSERT INTO incidencia_tecnico VALUES (23, 7);
INSERT INTO incidencia_tecnico VALUES (24, 1);
INSERT INTO incidencia_tecnico VALUES (24, 11);


/* 
7. Mediante el nombre del pais, nos devuelve el nombre de los suministradores que pertenecen a ese país y que marca de telefono reparten. Si no encuentra ningún suministrador perteneciente al país indicado nos lo muestra como error.
*/

DROP PROCEDURE IF EXISTS pais_del_sumistrador;
DELIMITER //
	CREATE PROCEDURE pais_del_sumistrador(IN nombres VARCHAR(30),OUT merror VARCHAR (60))
	BEGIN
    SET merror='';

    IF(SELECT 1 FROM pais AS p WHERE p.nombre=nombres) THEN
	SELECT s.nombre AS Suministrador, ma.nombre AS Marcas
    	FROM pais AS p
			INNER JOIN suministrador AS s ON s.pais_id=p.id_pais
			INNER JOIN telefono_suministrador AS tes ON tes.id_suministrador=s.id_suministrador
			INNER JOIN telefono AS te ON te.id_telefono=tes.id_telefono
			INNER JOIN marca AS ma ON ma.id_marca=te.marca_id
    	WHERE p.nombre=nombres;
    ELSE SET merror='No hay Suministradores con ese pais';
    END IF;
    END //
DELIMITER ;

CALL pais_del_sumistrador('Austria hungria',@merror);
SELECT @merror;
CALL pais_del_sumistrador('España',@merror);
SELECT @merror;


/* 
8. Pasamos al procedimiento el nombre de un cliente, y éste nos devuelve el modelo, la marca y el estado del pedido. Si no encuentra ese cliente, devolverá un error.
*/

DROP PROCEDURE IF EXISTS telefono_de_clientes;
DELIMITER //
	CREATE PROCEDURE telefono_de_clientes(IN nombres VARCHAR(20),OUT merror VARCHAR (60))
	BEGIN
    SET merror='';

    IF(SELECT id_cliente FROM cliente AS c WHERE c.nombre=nombres LIMIT 1) THEN
		SELECT te.modelo,ma.nombre AS Marca,p.estado 
		FROM cliente  AS c 
			INNER JOIN pedido AS p ON p.cliente_id=c.id_cliente
			INNER JOIN telefono_pedido AS tep ON tep.id_pedido=p.id_pedido
			INNER JOIN telefono AS te ON te.id_telefono=tep.id_telefono
			INNER JOIN marca AS ma ON ma.id_marca=te.marca_id
		WHERE c.nombre=nombres;
    ELSE SET merror='EL nombre del cliente esta incorrecto';
    END IF;
    END //
DELIMITER ;

CALL telefono_de_clientes('Juan',@merror);
SELECT @merror;
/* 
9. Procedimiento que borra (B) o añada (A) entradas de pais pasándole un CHAR que indique la acción a realizar. Además del char pasáremos el código y el nombre del país en el caso de añadir un registro nuevo. Nos devolverá un error en el caso de pasar una acción equivocada o que el país ya exista.
*/

DROP PROCEDURE IF EXISTS borrar_crear_pais;
DELIMITER //
	CREATE PROCEDURE borrar_crear_pais(IN borcre ENUM('A','B'),IN codigo VARCHAR(3),IN nombres VARCHAR(30),OUT merror VARCHAR (60))
	BEGIN
	DECLARE idpais SMALLINT(6);

    SET merror='';

    CASE borcre
		WHEN 'A' THEN
				IF(SELECT id_pais FROM pais AS p WHERE p.nombre!=nombres LIMIT 1) THEN
					INSERT INTO pais (codigo, nombre) VALUES (codigo, nombres);
				SET idpais = LAST_INSERT_ID();
					INSERT INTO suministrador (pais_id) VALUES (idpais);
				ELSE SET merror='El pais ya esta existe';
				END IF;
		WHEN 'B' THEN
			IF(SELECT 1 FROM pais AS p WHERE p.nombre=nombres) THEN
                DELETE FROM suministrador WHERE pais_id=(SELECT id_pais FROM pais WHERE nombre=nombres);
                DELETE FROM pais WHERE nombre=nombres;
			ELSE SET merror='El pais no existe';
			END IF;
		ELSE SET merror='La accion solo puede ser "A" o "B" y no puede estar vacio';
    END CASE;
    END //
DELIMITER ;

CALL borrar_crear_pais('A','PAR','Paraguay',@merror);
CALL borrar_crear_pais('B','PAR','Paraguay',@merror);


/* 
10. Procedimiento al que le pasamos un numero N y nos devuelve el modelo, la marca y el estado del pedido de los dispositivos que han comprado los N primeros clientes en nuestra tienda.
*/

DROP PROCEDURE IF EXISTS getUsuarioMarcas;
DELIMITER //
	CREATE PROCEDURE getUsuarioMarcas(IN numero SMALLINT(6))
	BEGIN
    DECLARE nom VARCHAR(20);
    DECLARE numinc SMALLINT (6);
    SET numinc=1;
        WHILE (numinc <= numero) DO
        SET nom=(SELECT c.nombre
			FROM cliente AS c
            WHERE numinc=c.id_cliente);

		SET @orden=CONCAT("SELECT c.id_cliente AS ",nom,",te.modelo,ma.nombre AS Marca,p.estado 
			FROM cliente  AS c
			INNER JOIN pedido AS p ON p.cliente_id=c.id_cliente
			INNER JOIN telefono_pedido AS tep ON tep.id_pedido=p.id_pedido
			INNER JOIN telefono AS te ON te.id_telefono=tep.id_telefono
			INNER JOIN marca AS ma ON ma.id_marca=te.marca_id
            WHERE ",numinc,"=c.id_cliente");
            PREPARE orden FROM @orden;
            EXECUTE orden;
            DEALLOCATE PREPARE orden;
            SET numinc=numinc+1;
		END WHILE;
    END //
DELIMITER ;
CALL getUsuarioMarcas(3);

/* 
11. Introducimos el nombre del cliente, el modelo del teléfono comprado y una fecha, si el pedido en el que va ese teléfono lleva más de 15 días sin ser entregado desde la fecha indicada nos devuelve un mensaje indicando que se ha retrasado. En el caso contrario devuelve un mensaje explicando que aún está dentro de los tiempos de entrega habituales.
*/
DROP PROCEDURE IF EXISTS pedido_retarde;
DELIMITER //
	CREATE PROCEDURE pedido_retarde(IN nombres VARCHAR(20),IN modelo VARCHAR(20),IN fecha_actual DATE ,OUT merror VARCHAR (90))
	BEGIN
    
	DECLARE fecha DATE;
	DECLARE numinc MEDIUMINT;

    SET numinc:=1;
    SET merror='';
            IF EXISTS(SELECT 1 FROM cliente WHERE nombre=nombres) AND EXISTS (SELECT 1 FROM telefono AS t WHERE t.modelo=modelo) THEN
            
                IF EXISTS(SELECT estado FROM pedido AS p INNER JOIN cliente AS c ON c.id_cliente=p.cliente_id WHERE c.nombre=nombres AND p.estado IN ("E") LIMIT 1) THEN
					SET fecha:=(SELECT fecha_envio
						FROM cliente  AS c 
						INNER JOIN pedido AS p ON p.cliente_id=c.id_cliente
						INNER JOIN telefono_pedido AS tep ON tep.id_pedido=p.id_pedido
						INNER JOIN telefono AS te ON te.id_telefono=tep.id_telefono
						INNER JOIN marca AS ma ON ma.id_marca=te.marca_id
						WHERE c.nombre=nombres AND p.estado="E" AND te.modelo=modelo);
					REPEAT
						SET fecha = ADDDATE(fecha, INTERVAL 1 DAY);
						SET numinc:=numinc+1;
					UNTIL (numinc >= 16 OR fecha > fecha_actual)
					END REPEAT;
					IF(numinc>=15) THEN
						SET merror='El pedido se esta retrasando, te lo enviaremos lo antes posible';
					ELSE SET merror=' Aun no han pasado los 15 dias, el pedido esta de camino';
					END IF;
                ELSE SET merror='El pedido ya esta entregado o aun esta en preparacion';
                END IF;
            ELSE SET merror='El cliente o el modelo no existen';
            END IF;
END //
DELIMITER ;
SELECT te.modelo,p.estado
						FROM cliente  AS c 
						INNER JOIN pedido AS p ON p.cliente_id=c.id_cliente
						INNER JOIN telefono_pedido AS tep ON tep.id_pedido=p.id_pedido
						INNER JOIN telefono AS te ON te.id_telefono=tep.id_telefono
						INNER JOIN marca AS ma ON ma.id_marca=te.marca_id
						WHERE c.nombre="Juan";
CALL pedido_retarde('aegaeraf','SangomiA2','2023-03-15',@merror);
SELECT @merror;
CALL pedido_retarde('Ander','gfnbhn','2023-03-15',@merror);
SELECT @merror;
CALL pedido_retarde('Juan','XS22','2023-03-15',@merror);
SELECT @merror;
CALL pedido_retarde('Ander','SangomiA2','2023-03-15',@merror);
SELECT @merror;
CALL pedido_retarde('Ander','SangomiA2','2021-01-11',@merror);
SELECT @merror;