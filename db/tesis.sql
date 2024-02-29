DROP VIEW IF EXISTS vista_votos_sin_filtros;
DROP VIEW IF EXISTS vista_votos_solo_filtro_departamento;
DROP VIEW IF EXISTS vista_votos_sin_filtro_mesas_puestosdevotacion;
DROP VIEW IF EXISTS vista_votos_sin_filtro_mesas;
DROP VIEW IF EXISTS vista_votos_todos_los_filtros;
DROP VIEW IF EXISTS v_c;

DROP TABLE IF EXISTS candidatos;
DROP TABLE IF EXISTS partidos;
DROP TABLE IF EXISTS mesas;
DROP TABLE IF EXISTS usuarios;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS puestosdevotacion;
DROP TABLE IF EXISTS zonas;
DROP TABLE IF EXISTS municipios;
DROP TABLE IF EXISTS departamentos;

CREATE TABLE departamentos (
    id_departamento   INTEGER       NOT NULL,      
    nom_departamento  VARCHAR(50)   NOT NULL,

    PRIMARY KEY (id_departamento)
);

CREATE TABLE municipios (
    id_municipio      INTEGER       NOT NULL,
    nom_municipio     VARCHAR(50)   NOT NULL,
	id_departamento   INTEGER       NOT NULL,

	PRIMARY KEY(id_municipio),
	FOREIGN KEY(id_departamento)    REFERENCES departamentos
);

CREATE TABLE zonas (
    id_zona           INTEGER       NOT NULL,
    nom_zona          VARCHAR(50)   NOT NULL,

    PRIMARY KEY (id_zona)
);

CREATE TABLE partidos (
    id_partido        INTEGER       NOT NULL,
    nom_partido       VARCHAR(60)   NOT NULL,
    url_imagen        TEXT              NULL,

    PRIMARY KEY (id_partido) 
);

CREATE TABLE candidatos (
    id_departamento   INTEGER       NOT NULL,
    id_candidato      INTEGER       NOT NULL,
    nom_candidato     VARCHAR(70)       NULL,
    id_partido        INTEGER           NULL,
    url_imagen        TEXT              NULL,

    PRIMARY KEY (id_candidato),
    FOREIGN KEY (id_departamento) REFERENCES departamentos,
	FOREIGN KEY (id_partido) REFERENCES partidos
);

CREATE TABLE puestosdevotacion (
    id_departamento      INTEGER     NOT NULL,
    id_municipio         INTEGER     NOT NULL,
    id_zona              INTEGER     NOT NULL,
	id_puestodevotacion  INTEGER     NOT NULL,
    nom_puestodevotacion VARCHAR(60) NOT NULL,
    mesas_instaladas     INTEGER     NOT NULL,

    PRIMARY KEY (id_puestodevotacion),
    FOREIGN KEY (id_departamento) REFERENCES departamentos,
	FOREIGN KEY (id_municipio) REFERENCES municipios,
	FOREIGN KEY (id_zona) REFERENCES zonas
);

CREATE TABLE roles (
    id_role          INTEGER       NOT NULL,
    nom_role         TEXT          NOT NULL,

    PRIMARY KEY (id_role)
);


CREATE TABLE usuarios (
    id_role                 INTEGER      NOT NULL,
    id_puestodevotacion     INTEGER      NOT NULL,
    id_usuario              SERIAL       NOT NULL,
    nom_usuario             VARCHAR(60)  NOT NULL,
    correo_usuario          VARCHAR(60)  NOT NULL UNIQUE,
    clave_usuario           TEXT         NOT NULL,
	url_imagen              TEXT             NULL,
    updateAt TIMESTAMP NOT NULL DEFAULT CURRENT_DATE,            
    
	PRIMARY KEY (id_usuario),
    FOREIGN KEY (id_role) REFERENCES roles,
    FOREIGN KEY (id_puestodevotacion) REFERENCES puestosdevotacion
);

CREATE TABLE mesas (
    id_puestodevotacion  INTEGER     NOT NULL,
    id_mesa              INTEGER     NOT NULL,
    id_usuario           SERIAL      NOT NULL,
    votos_incinerados    INTEGER     NOT NULL,
	total_sufragantes    INTEGER     NOT NULL,
	total_votos_urna	 INTEGER 	 NOT NULL,
    votos_candidato1     INTEGER     NOT NULL,
    votos_candidato2     INTEGER     NOT NULL,
    votos_candidato3     INTEGER     NOT NULL,
    votos_candidato4     INTEGER     NOT NULL,
    votos_candidato5     INTEGER     NOT NULL,
    votos_candidato6     INTEGER     NOT NULL,
	votos_candidato7     INTEGER     NOT NULL,
	votos_candidato8     INTEGER     NOT NULL,
	votos_candidato9     INTEGER     NOT NULL,
    votos_blancos        INTEGER     NOT NULL,
    votos_nulos          INTEGER     NOT NULL,
    votos_no_marcados    INTEGER     NOT NULL,
    total_votosmesa      INTEGER     NOT NULL,
	observaciones		 TEXT		     NULL,
    url_imagen_e14       TEXT            NULL,
    estado_envio_mesa    BOOLEAN     NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id_mesa, id_puestodevotacion),
    FOREIGN KEY (id_usuario) REFERENCES usuarios,
	FOREIGN KEY (id_puestodevotacion) REFERENCES puestosdevotacion
);

/* REGISTROS FINALES PARA BASE DATOS */

INSERT INTO departamentos (id_departamento, nom_departamento) VALUES (1, 'Casanare');


INSERT INTO municipios (id_municipio, nom_municipio, id_departamento) VALUES 
(1,'Yopal',1),(2,'Aguazul',1),(3,'Chameza',1),(4,'Hato Corozal',1),(5,'La Salina',1),
(6,'Maní',1),(7,'Monterrey',1),(8,'Nunchía',1),(9,'Orocué',1),(10,'Paz de Ariporo',1),
(11,'Pore',1),(12,'Recetor',1),(13,'Sabanalarga',1),(14,'Sácama',1),(15,'San Luis de Palenque',1),
(16,'Támara',1),(17,'Tauramena',1),(18,'Trinidad',1),(19,'Villanueva',1);


INSERT INTO zonas (id_zona, nom_zona) VALUES (1,'Urbana'),(2,'Rural');


INSERT INTO partidos (id_partido,nom_partido,url_imagen) VALUES 
(1,'Coalición por Casanare','../../images/partidos/coalicion-por-casanare.png'),(2,'P. Fuerza Democratica','../../images/partidos/fuerza_democratica.jpg'),(3,'P. Liga Anticorrupción','../../images/partidos/liga-anticorrupcion.jpg'),
(4,'P. Fuerza Ciudadana','../../images/partidos/fuerza-ciudadana.jpg'),(5,'M. Salvación Nacional','../../images/partidos/salvacion-nacional.jpg'),(6,'P. Pacto Historico','../../images/partidos/pacto-historico.png'),
(7,'P. Fuerza de la Paz','../../images/partidos/la-fuerza-de-la-paz.jpg'),(8,'P. Firmes por el Cambio','../../images/partidos/firmes-por-el-cambio.png'),(9,'P. Centro Democratico','../../images/partidos/centro-democratico.jpg');


INSERT INTO candidatos (id_departamento,id_candidato,nom_candidato,id_partido,url_imagen) VALUES 
(1,1,'Cesar Augusto Ortíz Zorro',1,'../../images/opciones-de-voto/cesar-augusto-ortiz-zorro.png'),
(1,2,'Luis Alexis García Barrera',2,'../../images/opciones-de-voto/luis-alexis-garcia-barrera.png'),
(1,3,'Héctor Manuel Balaguera Quintana',3,'../../images/opciones-de-voto/hector-manuel-balaguera-quintana.png'),
(1,4,'Jacobo Rivera Gomez',4,'../../images/opciones-de-voto/jacobo-rivera-gomez.png'),
(1,5,'Alba Rocío Romero García',5,'../../images/opciones-de-voto/alba-rocio-romero-garcia.png'),
(1,6,'Joél Holmos Cordero',6,'../../images/opciones-de-voto/joel-olmos-cordero.png'),
(1,7,'Rubiela Benitez Enriquez',7,'../../images/opciones-de-voto/rubiela-benitex-enriquez.png'),
(1,8,'Guillermo Alexander Venlandía Granados',8,'../../images/opciones-de-voto/guillermo-alexander-velandia-granados.png'),
(1,9,'Marisela Duarte Rodriguez',9,'../../images/opciones-de-voto/marisela-duarte-rodriguez.png');

/* TRIGGER GENERA TODAS LAS MESAS*/

CREATE OR REPLACE FUNCTION generar_registros_mesas()
RETURNS TRIGGER AS $$
DECLARE 
        x INT := NEW.id_puestodevotacion;
        y INT := NEW.mesas_instaladas;
        z INT := 1;
    BEGIN
        WHILE (z <= y) LOOP
            INSERT INTO mesas (id_puestodevotacion, id_mesa, id_usuario, votos_incinerados, total_sufragantes, total_votos_urna,
            votos_candidato1, votos_candidato2, votos_candidato3, votos_candidato4, votos_candidato5, votos_candidato6,
            votos_candidato7, votos_candidato8, votos_candidato9, votos_blancos, votos_nulos, votos_no_marcados, total_votosmesa,
            observaciones, estado_envio_mesa, created_at)
        VALUES (x, z, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Ninguna', false, current_timestamp);

            z := z + 1;
        END LOOP;
        RETURN NULL;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_insert_puestosdevotacion2
AFTER UPDATE
ON puestosdevotacion
FOR EACH ROW
EXECUTE FUNCTION generar_registros_mesas();


INSERT INTO puestosdevotacion (id_departamento, id_municipio, id_zona, id_puestodevotacion, nom_puestodevotacion, mesas_instaladas)
VALUES
(1, 1, 1, 1, 'I.E. LUIS HERNANDEZ VARGAS', 26),
(1, 1, 1, 2, 'C.E. MARCO FIDEL SUAREZ', 13),
(1, 1, 1, 3, 'IE CENTRO SOCIAL', 22),
(1, 1, 1, 4, 'IE CARLOS LLERAS RESTREPO', 33),
(1, 1, 1, 5, 'IE BRAULIO GONZALEZ SD SIMON BOLIVAR', 16),
(1, 1, 1, 6, 'IE BRAULIO GONZALEZ SD CENTRO', 26),
(1, 1, 1, 7, 'I TEC EMPRESARIAL YOPAL ITEY', 28),
(1, 1, 1, 8, 'IE MANUELA BELTRAN', 14),
(1, 1, 1, 9, 'IE EL CAMPIÑA', 21),
(1, 1, 1, 10, 'IE EL PARAISO', 35),
(1, 1, 1, 11, 'I TEC AMBIENTAL SAN MATEO', 28),
(1, 1, 1, 12, 'MEGACOLEGIO EL PROGRESO COMUNA CINCO', 25),
(1, 1, 1, 13, 'IE EMP LLANO LINDO SD A', 5),
(1, 1, 1, 14, 'IE EMP LLANO LINDO SD B', 3),
(1, 1, 1, 15, 'CARCEL MUNICIPAL', 1),
(1, 1, 2, 16, 'ALCARAVAN LA NIATA', 3),
(1, 1, 2, 17, 'PUNTO NUEVO', 2),
(1, 1, 2, 18, 'MATELIMON', 2),
(1, 1, 2, 19, 'EL CHARTE', 4),
(1, 1, 2, 20, 'EL MORRO', 8),
(1, 1, 2, 21, 'EL TALADRO', 2),
(1, 1, 2, 22, 'LA CHAPARRERA', 7),
(1, 1, 2, 23, 'MORICHAL', 6),
(1, 1, 2, 24, 'TACARIMENA', 3),
(1, 1, 2, 25, 'TILODIRAN', 4),
(1, 1, 2, 26, 'QUEBRADASECA', 2),
(1, 2, 1, 27, 'INST. EDUC. CAMILO TORRES REST', 20),
(1, 2, 1, 28, 'INST. EDUC. JORGE ELIECER GAIT', 16),
(1, 2, 1, 29, 'INST. EDUC. ANTONIO NARIÑO', 17),
(1, 2, 1, 30, 'INST. EDUC. SAN AGUSTIN(NUEVA', 19),
(1, 2, 2, 31, 'BELLAVISTA', 1),
(1, 2, 2, 32, 'CUNAMA', 1),
(1, 2, 2, 33, 'CUPIAGUA', 3),
(1, 2, 2, 34, 'GUADALCANAL', 1),
(1, 2, 2, 35, 'LA TURUA', 2),
(1, 2, 2, 36, 'MONTERRALO', 2),
(1, 2, 2, 37, 'SAN JOSE DEL BUBUY', 3),
(1, 2, 2, 38, 'SAN MIGUEL DE FARALLONES', 1),
(1, 2, 2, 39, 'UNETE', 1),
(1, 3, 1, 40, 'PUESTO CABECERA MUNICIPAL', 6),
(1, 4, 1, 41, 'PUESTO CABECERA MUNICIPAL', 15),
(1, 4, 2, 42, 'BERLIN', 1),
(1, 4, 2, 43, 'CHIRE', 1),
(1, 4, 2, 44, 'CORRALITO', 1),
(1, 4, 2, 45, 'EL GUAFAL', 1),
(1, 4, 2, 46, 'LA FRONTERA (LA CHAPA)', 1),
(1, 4, 2, 47, 'LAS CAMELIAS', 1),
(1, 4, 2, 48, 'LAS TAPIAS', 1),
(1, 4, 2, 49, 'MANARE', 1),
(1, 4, 2, 50, 'PASO REAL DE ARIPORO', 1),
(1, 4, 2, 51, 'PUERTO COLOMBIA', 1),
(1, 4, 2, 52, 'RESGUARDO CAÑO MOCHUELO', 2),
(1, 4, 2, 53, 'SAN JOSE DE ARIPORO', 1),
(1, 4, 2, 54, 'SAN NICOLAS', 1),
(1, 4, 2, 55, 'SAN SALVADOR', 1),
(1, 4, 2, 56, 'SANTA BARBARA', 1),
(1, 4, 2, 57, 'SANTA RITA', 1),
(1, 5, 1, 58, 'PUESTO CABECERA MUNICIPAL', 3),
(1, 6, 1, 59, 'JESUS BERNAL PINZON', 18),
(1, 6, 1, 60, 'LUIS ENRIQUE BARON LEAL', 11),
(1, 6, 2, 61, 'CHAVINABE', 1),
(1, 6, 2, 62, 'FRONTERAS', 1),
(1, 6, 2, 63, 'GUAFALPINTADO', 1),
(1, 6, 2, 64, 'LA POYATA', 1),
(1, 6, 2, 65, 'LA ARMENIA', 1),
(1, 6, 2, 66, 'LAS GAVIOTAS', 1),
(1, 6, 2, 67, 'PASO REAL DE GUARIAMENA', 1),
(1, 6, 2, 68, 'SAN JOAQUIN DE GARIBAY', 1),
(1, 6, 2, 69, 'STA ELENA DE CUSIVA', 2),
(1, 7, 1, 70, 'PUESTO CABECERA MUNICIPAL', 31),
(1, 7, 2, 71, 'BRISAS DEL LLANO', 1),
(1, 7, 2, 72, 'EL PORVENIR', 1),
(1, 7, 2, 73, 'LA ORQUETA', 1),
(1, 7, 2, 74, 'PALO NEGRO', 1),
(1, 7, 2, 75, 'VILLA CAROLA', 2),
(1, 8, 1, 76, 'PUESTO CABECERA MUNICIPAL', 10),
(1, 8, 2, 77, 'BARBACOAS', 1),
(1, 8, 2, 78, 'BARRANQUILLA', 1),
(1, 8, 2, 79, 'COREA', 1),
(1, 8, 2, 80, 'EL AMPARO', 1),
(1, 8, 2, 81, 'EL CAUCHO', 1),
(1, 8, 2, 82, 'EL CONCHAL', 1),
(1, 8, 2, 83, 'EL CAZADERO', 1),
(1, 8, 2, 84, 'EL PRETEXTO', 1),
(1, 8, 2, 85, 'EL VELADERO', 1),
(1, 8, 2, 86, 'GUANAPALO', 1),
(1, 8, 2, 87, 'LA PALMIRA', 1),
(1, 8, 2, 88, 'PEDREGAL', 2),
(1, 8, 2, 89, 'PUERTO TOCARIA', 4),
(1, 8, 2, 90, 'SIRIVANA', 1),
(1, 8, 2, 91, 'VIZERTA', 1),
(1, 9, 1, 92, 'PUESTO CABECERA MUNICIPAL', 19),
(1, 9, 2, 93, 'BANCO LARGO', 1),
(1, 9, 2, 94, 'BOCAS DEL CRAVO', 1),
(1, 9, 2, 95, 'CHURRUBAY', 1),
(1, 9, 2, 96, 'EL ALGARROBO (CRAVOSUR)', 4),
(1, 9, 2, 97, 'EL DUYA', 1),
(1, 9, 2, 98, 'TUJUA', 1),
(1, 10, 1, 99, 'IE JUAN JOSE RONDON', 16),
(1, 10, 1, 100, 'IE SAGRADO CORAZON', 15),
(1, 10, 1, 101, 'INST TEC IND EL PALMAR ITEIPA', 17),
(1, 10, 1, 102, 'IE FRANCISCO JOSE DE CALDAS', 17),
(1, 10, 1, 103, 'CARCEL', 1),
(1, 10, 2, 104, 'BOCAS DE LA HERMOSA', 2),
(1, 10, 2, 105, 'CAÑO CHIQUITO', 2),
(1, 10, 2, 106, 'LAS GUAMAS', 2),
(1, 10, 2, 107, 'MORENO', 2),
(1, 10, 2, 108, 'MONTAÑA DEL TOTUMO', 3),
(1, 11, 1, 109, 'PUESTO CABECERA MUNICIPAL', 20),
(1, 11, 2, 110, 'EL BANCO', 2),
(1, 11, 2, 111, 'LA PLATA', 2),
(1, 12, 1, 112, 'PUESTO CABECERA MUNICIPAL', 3),
(1, 12, 2, 113, 'LOS ALPES', 1),
(1, 12, 2, 114, 'PUEBLO NUEVO', 1),
(1, 13, 1, 115, 'PUESTO CABECERA MUNICIPAL', 7),
(1, 13, 2, 116, 'AGUACLARA', 2),
(1, 13, 2, 117, 'EL SECRETO', 1),
(1, 14, 1, 118, 'PUESTO CABECERA MUNICIPAL', 5),
(1, 15, 1, 119, 'PUESTO CABECERA MUNICIPAL', 14),
(1, 15, 2, 120, 'MIRAMAR DE GUANAPALO (BOCAS D', 1),
(1, 15, 2, 121, 'GAVIOTAS QUITEVE', 1),
(1, 15, 2, 122, 'JAGUEYES', 1),
(1, 15, 2, 123, 'LA VENTUROSA', 2),
(1, 15, 2, 124, 'RIVERITA', 1),
(1, 15, 2, 125, 'SAN FRANCISCO', 1),
(1, 15, 2, 126, 'SAN RAFAEL DE GUANAPALO', 1),
(1, 15, 2, 127, 'SIRIVANA ALGODONALE', 1),
(1, 16, 1, 128, 'PUESTO CABECERA MUNICIPAL', 11),
(1, 16, 2, 129, 'EL ARIPORO', 1),
(1, 16, 2, 130, 'LA FLORIDA', 1),
(1, 16, 2, 131, 'TABLON DE TAMARA', 1),
(1, 16, 2, 132, 'TABLONCITO', 1),
(1, 16, 2, 133, 'TEN (TEISLANDIA)', 1),
(1, 17, 1, 134, 'PUESTO CABECERA MUNICIPAL', 43),
(1, 17, 2, 135, 'CARUPANA', 1),
(1, 17, 2, 136, 'COROCITO', 2),
(1, 17, 2, 137, 'PASO CUSIANA', 4),
(1, 17, 2, 138, 'EL RAIZAL', 2),
(1, 17, 2, 139, 'ESC. RURAL LA URAMA', 2),
(1, 18, 1, 140, 'INS.TEC.INTREGRADO B', 12),
(1, 18, 1, 141, 'INS. TEC. INTEGRADO A', 10),
(1, 18, 2, 142, 'BELGICA', 1),
(1, 18, 2, 143, 'BOCAS DEL PAUTO', 2),
(1, 18, 2, 144, 'CAIMAN', 1),
(1, 18, 2, 145, 'GUAMAL', 1),
(1, 18, 2, 146, 'PASO REAL DE LA SOLEDAD', 1),
(1, 18, 2, 147, 'EL CONVENTO', 2),
(1, 18, 2, 148, 'LOS CHOCHOS', 1),
(1, 18, 2, 149, 'SANTA IRENE', 1),
(1, 18, 2, 150, 'SAN VICENTE', 1),
(1, 19, 1, 151, 'I.E. FABIO RIVEROS', 20),
(1, 19, 1, 152, 'I.E. EZEQ. MORENO Y DIAZ SD MORICHAL', 15),
(1, 19, 1, 153, 'I.E. N. S DE LOS D. DE MANARE SD PARAISO', 17),
(1, 19, 1, 154, 'I.E. EZEQU M. Y DIAZ SD BELLO HORIZONTE', 13),
(1, 19, 2, 155, 'CARIBAYONA', 2),
(1, 19, 2, 156, 'SAN AGUSTIN', 2),
(1, 19, 2, 157, 'SANTA HELENA DE UPIA', 2);


INSERT INTO roles (id_role,nom_role) VALUES (1,'Administrador'),(2,'Candidato'),(3,'Editor');


INSERT INTO usuarios (id_role,id_puestodevotacion, id_usuario,nom_usuario,correo_usuario,clave_usuario,url_imagen, updateAt) 
VALUES (1,1,1,'admin','admin@gmail.com','$2b$10$8pYo.Bf0WwZkWyb6vQotSue.xO15CqPsVE4pQyPdrnhXRI9xg18yu','https://res.cloudinary.com/do56sbqpw/image/upload/v1695579119/users/scj7lrbuka5lyj4erwbl.png',''),
(2,2,2,'candidato','candidato@gmail.com','$2b$10$qYg2e1IcF5mutGDwE3Vt2.yfXSB5nPYTE6gm2YXT25tVYdekPq4qe','https://res.cloudinary.com/do56sbqpw/image/upload/v1695579119/users/scj7lrbuka5lyj4erwbl.png'),
(3,3,3,'editor','editor@gmail.com','$2b$10$jf.qzTQntF5cTpo3s8kcoerk2G1a3RNKw3wXlpjVimZr6CtcXOl9u','https://res.cloudinary.com/do56sbqpw/image/upload/v1695579119/users/scj7lrbuka5lyj4erwbl.png');

UPDATE puestosdevotacion SET id_departamento = 1 WHERE id_departamento = 1;

/* DO $$
DECLARE 
    x INT := NEW.id_puestodevotacion;
    y INT := NEW.mesas_instaladas;
    z INT := 1;
    BEGIN
        WHILE (z <= y) LOOP
            INSERT INTO mesas (id_puestodevotacion, id_mesa, id_usuario, votos_incinerados, total_sufragantes, total_votos_urna,
            votos_candidato1, votos_candidato2, votos_candidato3, votos_candidato4, votos_candidato5, votos_candidato6,
            votos_candidato7, votos_candidato8, votos_candidato9, votos_blancos, votos_nulos, votos_no_marcados, total_votosmesa,
            observaciones, estado_envio_mesa, created_at)
        VALUES (x, z, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 'Ninguna', false, current_timestamp);

            z := z + 1;
        END LOOP;
END $$; */

/*Vista base*/

CREATE VIEW v_c AS
SELECT puestosdevotacion.id_departamento, puestosdevotacion.id_municipio, mesas.id_puestodevotacion, mesas.id_mesa, mesas.estado_envio_mesa, candidatos.id_candidato AS id_candidato, candidatos.id_partido, mesas.votos_candidato1 AS votos
FROM mesas JOIN candidatos ON candidatos.id_candidato= 1 JOIN puestosdevotacion ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion
UNION ALL
SELECT puestosdevotacion.id_departamento, puestosdevotacion.id_municipio, mesas.id_puestodevotacion, mesas.id_mesa, mesas.estado_envio_mesa, candidatos.id_candidato AS id_candidato, candidatos.id_partido, mesas.votos_candidato2 AS votos
FROM mesas JOIN candidatos ON candidatos.id_candidato= 2 JOIN puestosdevotacion ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion
UNION ALL
SELECT puestosdevotacion.id_departamento, puestosdevotacion.id_municipio, mesas.id_puestodevotacion, mesas.id_mesa, mesas.estado_envio_mesa, candidatos.id_candidato AS id_candidato, candidatos.id_partido, mesas.votos_candidato3 AS votos
FROM mesas JOIN candidatos ON candidatos.id_candidato= 3 JOIN puestosdevotacion ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion
UNION ALL
SELECT puestosdevotacion.id_departamento, puestosdevotacion.id_municipio, mesas.id_puestodevotacion, mesas.id_mesa, mesas.estado_envio_mesa, candidatos.id_candidato AS id_candidato, candidatos.id_partido, mesas.votos_candidato4 AS votos
FROM mesas JOIN candidatos ON candidatos.id_candidato= 4 JOIN puestosdevotacion ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion
UNION ALL
SELECT puestosdevotacion.id_departamento, puestosdevotacion.id_municipio, mesas.id_puestodevotacion, mesas.id_mesa, mesas.estado_envio_mesa, candidatos.id_candidato AS id_candidato, candidatos.id_partido, mesas.votos_candidato5 AS votos
FROM mesas JOIN candidatos ON candidatos.id_candidato= 5 JOIN puestosdevotacion ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion
UNION ALL
SELECT puestosdevotacion.id_departamento, puestosdevotacion.id_municipio, mesas.id_puestodevotacion, mesas.id_mesa, mesas.estado_envio_mesa, candidatos.id_candidato AS id_candidato, candidatos.id_partido, mesas.votos_candidato6 AS votos
FROM mesas JOIN candidatos ON candidatos.id_candidato= 6 JOIN puestosdevotacion ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion
UNION ALL
SELECT puestosdevotacion.id_departamento, puestosdevotacion.id_municipio, mesas.id_puestodevotacion, mesas.id_mesa, mesas.estado_envio_mesa, candidatos.id_candidato AS id_candidato, candidatos.id_partido, mesas.votos_candidato7 AS votos
FROM mesas JOIN candidatos ON candidatos.id_candidato= 7 JOIN puestosdevotacion ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion
UNION ALL
SELECT puestosdevotacion.id_departamento, puestosdevotacion.id_municipio, mesas.id_puestodevotacion, mesas.id_mesa, mesas.estado_envio_mesa, candidatos.id_candidato AS id_candidato, candidatos.id_partido, mesas.votos_candidato8 AS votos
FROM mesas JOIN candidatos ON candidatos.id_candidato= 8 JOIN puestosdevotacion ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion
UNION ALL
SELECT puestosdevotacion.id_departamento, puestosdevotacion.id_municipio, mesas.id_puestodevotacion, mesas.id_mesa, mesas.estado_envio_mesa, candidatos.id_candidato AS id_candidato, candidatos.id_partido, mesas.votos_candidato9 AS votos
FROM mesas JOIN candidatos ON candidatos.id_candidato= 9 JOIN puestosdevotacion ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion;



/*Vista necesaria para la pagina de consultas*/

CREATE VIEW vista_votos_todos_los_filtros AS
SELECT 
puestosdevotacion.id_departamento,
departamentos.nom_departamento,
puestosdevotacion.id_municipio,
municipios.nom_municipio,
v_c.id_puestodevotacion,
puestosdevotacion.nom_puestodevotacion,
v_c.id_mesa,
v_c.id_candidato,
candidatos.nom_candidato,
candidatos.id_partido,
partidos.nom_partido,
sum(v_c.votos) AS votos,
candidatos.url_imagen,
mesas.estado_envio_mesa
FROM v_c 
JOIN mesas
    on v_c.id_mesa = mesas.id_mesa
JOIN puestosdevotacion
    ON  v_c.id_puestodevotacion = puestosdevotacion.id_puestodevotacion
JOIN departamentos
    ON puestosdevotacion.id_departamento = departamentos.id_departamento
JOIN municipios
    ON puestosdevotacion.id_municipio = municipios.id_municipio
JOIN candidatos 
    ON v_c.id_candidato = candidatos.id_candidato 
JOIN partidos 
    ON candidatos.id_partido = partidos.id_partido
GROUP BY puestosdevotacion.id_departamento, departamentos.nom_departamento, puestosdevotacion.id_municipio, municipios.nom_municipio, v_c.id_puestodevotacion, puestosdevotacion.nom_puestodevotacion, v_c.id_mesa, v_c.id_candidato, candidatos.nom_candidato, candidatos.url_imagen, candidatos.id_partido, partidos.nom_partido, mesas.estado_envio_mesa
ORDER BY votos DESC;

/*Vista necesaria para la pagina de consultas sin filtro: id_mesa*/

CREATE VIEW vista_votos_sin_filtro_mesas AS
SELECT 
puestosdevotacion.id_departamento,
departamentos.nom_departamento,
puestosdevotacion.id_municipio,
municipios.nom_municipio,
v_c.id_puestodevotacion,
puestosdevotacion.nom_puestodevotacion,
v_c.id_candidato,
candidatos.nom_candidato,
candidatos.id_partido,
partidos.nom_partido,
sum(v_c.votos) AS votos,
candidatos.url_imagen,
mesas.estado_envio_mesa
FROM v_c 
JOIN mesas
    on v_c.id_mesa = mesas.id_mesa
JOIN puestosdevotacion
    ON  v_c.id_puestodevotacion = puestosdevotacion.id_puestodevotacion
JOIN departamentos
    ON puestosdevotacion.id_departamento = departamentos.id_departamento
JOIN municipios
    ON puestosdevotacion.id_municipio = municipios.id_municipio
JOIN candidatos 
    ON v_c.id_candidato = candidatos.id_candidato 
JOIN partidos 
    ON candidatos.id_partido = partidos.id_partido
GROUP BY puestosdevotacion.id_departamento, departamentos.nom_departamento, puestosdevotacion.id_municipio, municipios.nom_municipio, v_c.id_puestodevotacion, puestosdevotacion.nom_puestodevotacion, v_c.id_candidato, candidatos.nom_candidato, candidatos.url_imagen, candidatos.id_partido, partidos.nom_partido, mesas.estado_envio_mesa, v_c.id_mesa
ORDER BY votos DESC;

/*Vista necesaria para la pagina de consultas sin filtros: id_mesa y id_puestodevotacion*/

CREATE VIEW vista_votos_sin_filtro_mesas_puestosdevotacion AS
SELECT 
puestosdevotacion.id_departamento,
departamentos.nom_departamento,
puestosdevotacion.id_municipio,
municipios.nom_municipio,
v_c.id_candidato,
candidatos.nom_candidato,
candidatos.id_partido,
partidos.nom_partido,
sum(v_c.votos) AS votos,
candidatos.url_imagen,
mesas.estado_envio_mesa
FROM v_c 
JOIN mesas
    on v_c.id_mesa = mesas.id_mesa
JOIN puestosdevotacion
    ON  v_c.id_puestodevotacion = puestosdevotacion.id_puestodevotacion
JOIN departamentos
    ON puestosdevotacion.id_departamento = departamentos.id_departamento
JOIN municipios
    ON puestosdevotacion.id_municipio = municipios.id_municipio
JOIN candidatos 
    ON v_c.id_candidato = candidatos.id_candidato 
JOIN partidos 
    ON candidatos.id_partido = partidos.id_partido
GROUP BY puestosdevotacion.id_departamento, departamentos.nom_departamento, puestosdevotacion.id_municipio, municipios.nom_municipio,  v_c.id_candidato, candidatos.nom_candidato, candidatos.url_imagen, candidatos.id_partido, partidos.nom_partido, mesas.estado_envio_mesa, v_c.id_mesa 
ORDER BY votos DESC;

/*Vista necesaria para la pagina de consultas sin filtros: id_mesa, id_puestodevotacion y id_municipio*/

CREATE VIEW vista_votos_solo_filtro_departamento AS
SELECT 
puestosdevotacion.id_departamento,
departamentos.nom_departamento,
v_c.id_candidato,
candidatos.nom_candidato,
candidatos.id_partido,
partidos.nom_partido,
sum(v_c.votos) AS votos,
candidatos.url_imagen,
mesas.estado_envio_mesa
FROM v_c 
JOIN mesas
    on v_c.id_mesa = mesas.id_mesa
JOIN puestosdevotacion
    ON  v_c.id_puestodevotacion = puestosdevotacion.id_puestodevotacion
JOIN departamentos
    ON puestosdevotacion.id_departamento = departamentos.id_departamento
JOIN municipios
    ON puestosdevotacion.id_municipio = municipios.id_municipio
JOIN candidatos 
    ON v_c.id_candidato = candidatos.id_candidato 
JOIN partidos 
    ON candidatos.id_partido = partidos.id_partido
GROUP BY puestosdevotacion.id_departamento, departamentos.nom_departamento, v_c.id_candidato, candidatos.nom_candidato, candidatos.url_imagen, candidatos.id_partido, partidos.nom_partido, mesas.estado_envio_mesa, v_c.id_mesa
ORDER BY votos DESC;

/*Vista sin filtros para la pagina de resultados*/

CREATE VIEW vista_votos_sin_filtros AS
SELECT 
v_c.id_mesa,
candidatos.nom_candidato,
candidatos.id_partido,
partidos.nom_partido,
sum(v_c.votos) AS votos,
candidatos.url_imagen,
mesas.estado_envio_mesa
FROM v_c 
JOIN mesas
    on v_c.id_mesa = mesas.id_mesa
JOIN candidatos 
    ON v_c.id_candidato = candidatos.id_candidato 
JOIN partidos 
    ON candidatos.id_partido = partidos.id_partido
GROUP BY v_c.id_candidato, candidatos.nom_candidato, candidatos.id_partido, partidos.nom_partido, mesas.estado_envio_mesa, candidatos.url_imagen, v_c.id_mesa
ORDER BY votos DESC;