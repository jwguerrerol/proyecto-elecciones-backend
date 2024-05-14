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
(1, 1, 1, 1, 'I.E. LUIS HERNANDEZ VARGAS', 22),
(1, 1, 1, 2, 'C.E. MARCO FIDEL SUAREZ', 12),
(1, 1, 1, 3, 'IE CENTRO SOCIAL', 15),
(1, 1, 1, 4, 'I E CENTRO SOCIAL SEDE PRIMARIA', 12),
(1, 1, 1, 5, 'IE SALVADOR CAMACHO ROLDAN', 3),
(1, 1, 1, 6, 'IE CARLOS LLERAS RESTREPO', 29),
(1, 1, 1, 7, 'IE BRAULIO GONZALEZ SD SIMON BOLIVAR', 19),
(1, 1, 1, 8, 'IE BRAULIO GONZALEZ SD CENTRO', 31),
(1, 1, 1, 9, 'IE GABRIEL GARCIA MARQUEZ', 5),
(1, 1, 1, 10, 'I TEC EMPRESARIAL YOPAL ITEY', 35),
(1, 1, 1, 11, 'IE MANUELA BELTRAN', 17),
(1, 1, 1, 12, 'IE EL CAMPIÑA', 16),
(1, 1, 1, 13, 'IE EL PARAISO', 37),
(1, 1, 1, 14, 'IE JORGE ELIECER GAITAN', 11),
(1, 1, 1, 15, 'IE MANUELA BELTRAN SEDE EL GAVAN', 1),
(1, 1, 1, 16, 'I TEC AMBIENTAL SAN MATEO', 33),
(1, 1, 1, 17, 'MEGACOLEGIO EL PROGRESO COMUNA CINCO', 29),
(1, 1, 1, 18, 'IE EMP LLANO LINDO SD A', 9),
(1, 1, 1, 19, 'IE EMP LLANO LINDO SD B', 4),
(1, 1, 1, 20, 'IE TERESA DE CALCUTA', 1),
(1, 1, 1, 21, 'I E BRAULIO GONZALEZ SD CAMPESTRE', 5),
(1, 1, 2, 22, 'CARCEL MUNICIPAL', 1),
(1, 1, 2, 23, 'ALCARAVAN LA NIATA', 3),
(1, 1, 2, 24, 'PUNTO NUEVO', 2),
(1, 1, 2, 25, 'MATELIMON', 2),
(1, 1, 2, 26, 'EL CHARTE', 4),
(1, 1, 2, 27, 'GUAFILLA', 1),
(1, 1, 2, 28, 'EL MORRO', 8),
(1, 1, 2, 29, 'EL TALADRO', 2),
(1, 1, 2, 30, 'LA CHAPARRERA', 7),
(1, 1, 2, 31, 'MORICHAL', 7),
(1, 1, 2, 32, 'SAN RAFAEL', 1),
(1, 1, 2, 33, 'TACARIMENA', 3),
(1, 1, 2, 34, 'TILODIRAN', 4),
(1, 1, 2, 35, 'QUEBRADASECA', 2),
(1, 2, 1, 36, 'INST. EDUC. CAMILO TORRES REST', 22),
(1, 2, 1, 37, 'INST. EDUC. JORGE ELIECER GAIT', 18),
(1, 2, 1, 38, 'INST. EDUC. ANTONIO NARIÑO', 18),
(1, 2, 1, 39, 'INST. EDUC. SAN AGUSTIN(NUEVA', 22),
(1, 2, 2, 40, 'BELLAVISTA', 1),
(1, 2, 2, 41, 'CUNAMA', 1),
(1, 2, 2, 42, 'CUPIAGUA', 3),
(1, 2, 2, 43, 'GUADALCANAL', 1),
(1, 2, 2, 44, 'LA TURUA', 2),
(1, 2, 2, 45, 'MONTERRALO', 2),
(1, 2, 2, 46, 'SAN JOSE DEL BUBUY', 3),
(1, 2, 2, 47, 'SAN MIGUEL DE FARALLONES', 1),
(1, 2, 2, 48, 'UNETE', 1),
(1, 3, 1, 49, 'PUESTO CABECERA MUNICIPAL', 6),
(1, 4, 1, 50, 'PUESTO CABECERA MUNICIPAL', 16),
(1, 4, 2, 51, 'BERLIN', 1),
(1, 4, 2, 52, 'CHIRE', 1),
(1, 4, 2, 53, 'CORRALITO', 1),
(1, 4, 2, 54, 'EL GUAFAL', 1),
(1, 4, 2, 55, 'LA FRONTERA (LA CHAPA)', 1),
(1, 4, 2, 56, 'LAS CAMELIAS', 1),
(1, 4, 2, 57, 'LAS TAPIAS', 1),
(1, 4, 2, 58, 'MANARE', 1),
(1, 4, 2, 59, 'PASO REAL DE ARIPORO', 1),
(1, 4, 2, 60, 'PUERTO COLOMBIA', 1),
(1, 4, 2, 61, 'RESGUARDO CAÑO MOCHUELO', 2),
(1, 4, 2, 62, 'SAN JOSE DE ARIPORO', 1),
(1, 4, 2, 63, 'SAN NICOLAS', 1),
(1, 4, 2, 64, 'SAN SALVADOR', 1),
(1, 4, 2, 65, 'SANTA BARBARA', 1),
(1, 4, 2, 66, 'SANTA RITA', 1),
(1, 5, 1, 67, 'PUESTO CABECERA MUNICIPAL', 3),
(1, 6, 2, 68, 'JESUS BERNAL PINZON', 18),
(1, 6, 2, 69, 'LUIS ENRIQUE BARON LEAL', 14),
(1, 6, 2, 70, 'CHAVINABE', 1),
(1, 6, 2, 71, 'SANTA MARIA DE PALMARITO', 1),
(1, 6, 2, 72, 'GUAFALPINTADO', 1),
(1, 6, 2, 73, 'LA POYATA', 1),
(1, 6, 2, 74, 'LA ARMENIA', 1),
(1, 6, 2, 75, 'LAS GAVIOTAS', 1),
(1, 6, 2, 76, 'PASO REAL DE GUARIAMENA', 1),
(1, 6, 2, 77, 'SAN JOAQUIN DE GARIBAY', 1),
(1, 6, 2, 78, 'STA ELENA DE CUSIVA', 2),
(1, 7, 1, 79, 'PUESTO CABECERA MUNICIPAL', 34),
(1, 7, 2, 80, 'BRISAS DEL LLANO', 1),
(1, 7, 2, 81, 'EL PORVENIR', 1),
(1, 7, 2, 82, 'LA ORQUETA', 1),
(1, 7, 2, 83, 'PALO NEGRO', 1),
(1, 7, 2, 84, 'VILLA CAROLA', 2),
(1, 8, 1, 85, 'PUESTO CABECERA MUNICIPAL', 10),
(1, 8, 2, 86, 'BARBACOAS', 1),
(1, 8, 2, 87, 'BARRANQUILLA', 1),
(1, 8, 2, 88, 'COREA', 1),
(1, 8, 2, 89, 'EL CAUCHO', 1),
(1, 8, 2, 90, 'EL CONCHAL', 1),
(1, 8, 2, 91, 'EL CAZADERO', 1),
(1, 8, 2, 92, 'EL PRETEXTO', 1),
(1, 8, 2, 93, 'GUANAPALO', 1),
(1, 8, 2, 94, 'PALMIRA', 1),
(1, 8, 2, 95, 'PEDREGAL', 2),
(1, 8, 2, 96, 'PUERTO TOCARIA', 4),
(1, 8, 2, 97, 'SIRIVANA', 1),
(1, 8, 2, 98, 'VIZERTA', 1),
(1, 9, 1, 99, 'PUESTO CABECERA MUNICIPAL', 21),
(1, 9, 2, 100, 'BANCO LARGO', 1),
(1, 9, 2, 101, 'BOCAS DEL CRAVO', 1),
(1, 9, 2, 102, 'CHURRUBAY', 1),
(1, 9, 2, 103, 'EL ALGARROBO (CRAVOSUR)', 4),
(1, 9, 2, 104, 'EL DUYA', 1),
(1, 9, 2, 105, 'TUJUA', 1),
(1, 10, 1, 106, 'IE JUAN JOSE RONDON', 18),
(1, 10, 1, 107, 'IE SAGRADO CORAZON', 18),
(1, 10, 1, 108, 'INST TEC IND EL PALMAR ITEIPA', 19),
(1, 10, 1, 109, 'IE FRANCISCO JOSE DE CALDAS', 19),
(1, 10, 1, 110, 'CARCEL', 1),
(1, 10, 2, 111, 'BOCAS DE LA HERMOSA', 1),
(1, 10, 2, 112, 'CAÑO CHIQUITO', 2),
(1, 10, 2, 113, 'LAS GUAMAS', 2),
(1, 10, 2, 114, 'LA BARRANCA', 2),
(1, 10, 2, 115, 'MONTAÑA DEL TOTUMO', 3),
(1, 10, 2, 116, 'RESGUARDO CAÑO MOCHUELO COM. SAN JOSE', 2),
(1, 11, 1, 117, 'PUESTO CABECERA MUNICIPAL', 23),
(1, 11, 2, 118, 'EL BANCO', 2),
(1, 11, 2, 119, 'LA PLATA', 2),
(1, 12, 1, 120, 'PUESTO CABECERA MUNICIPAL', 3),
(1, 12, 2, 121, 'LOS ALPES', 1),
(1, 12, 2, 122, 'PUEBLO NUEVO', 1),
(1, 13, 1, 123, 'PUESTO CABECERA MUNICIPAL', 7),
(1, 13, 2, 124, 'AGUACLARA', 2),
(1, 13, 2, 125, 'EL SECRETO', 1),
(1, 14, 2, 126, 'PUESTO CABECERA MUNICIPAL', 6),
(1, 14, 2, 127, 'CHAPARRAL Y BARRO NEGRO', 1),
(1, 15, 1, 128, 'PUESTO CABECERA MUNICIPAL', 15),
(1, 15, 2, 129, 'MIRAMAR DE GUANAPALO (BOCAS D', 1),
(1, 15, 2, 130, 'GAVIOTAS QUITEVE', 1),
(1, 15, 2, 131, 'JAGUEYES', 1),
(1, 15, 2, 132, 'LA VENTUROSA', 2),
(1, 15, 2, 133, 'RIVERITA', 1),
(1, 15, 2, 134, 'SAN FRANCISCO', 1),
(1, 15, 2, 135, 'SAN RAFAEL DE GUANAPALO', 1),
(1, 15, 2, 136, 'SIRIVANA ALGODONALE', 1),
(1, 16, 1, 137, 'PUESTO CABECERA MUNICIPAL', 11),
(1, 16, 2, 138, 'EL ARIPORO', 1),
(1, 16, 2, 139, 'TABLON DE TAMARA', 1),
(1, 16, 2, 140, 'TABLONCITO', 1),
(1, 16, 2, 141, 'TEN (TEISLANDIA)', 1),
(1, 16, 2, 142, 'ECCE HOMO', 1),
(1, 16, 2, 143, 'GUARAQUE', 1),
(1, 16, 2, 144, 'SANTO DOMINGO', 1),
(1, 17, 1, 145, 'INSTITUCION EDUCATIVA JOSE MARIA CORDOBA', 22),
(1, 17, 1, 146, 'IE TECNICA EMPRESARIAL DEL LLANO', 28),
(1, 17, 2, 147, 'CARUPANA', 1),
(1, 17, 2, 148, 'COROCITO', 2),
(1, 17, 2, 149, 'PASO CUSIANA', 4),
(1, 17, 2, 150, 'EL RAIZAL', 2),
(1, 17, 1, 151, 'ESC. RURAL LA URAMA', 2),
(1, 18, 1, 152, 'INS.TEC.INTREGRADO B', 13),
(1, 18, 1, 153, 'INS. TEC. INTEGRADO A', 12),
(1, 18, 2, 154, 'BELGICA', 1),
(1, 18, 2, 155, 'BOCAS DEL PAUTO', 2),
(1, 18, 2, 156, 'CAIMAN', 1),
(1, 18, 2, 157, 'SANTA MARTA', 0),
(1, 18, 2, 158, 'GUAMAL', 1),
(1, 18, 2, 159, 'PASO REAL DE LA SOLEDAD', 1),
(1, 18, 2, 160, 'EL CONVENTO', 2),
(1, 18, 2, 161, 'LOS CHOCHOS', 1),
(1, 18, 2, 162, 'SANTA IRENE', 1),
(1, 18, 2, 163, 'SAN VICENTE', 1),
(1, 19, 1, 164, 'I.E. FABIO RIVEROS', 29),
(1, 19, 1, 165, 'I.E. EZEQUIEL MORENO Y DIAZ SD MORICHAL', 16),
(1, 19, 1, 166, 'IE NUESTRA SEÑORA DE LOS DOLORES DE MANA', 19),
(1, 19, 1, 167, 'IE EZEQUIEL MORENO Y DIAZ SD BELLO HORIZ', 13),
(1, 19, 2, 168, 'CARIBAYONA', 3),
(1, 19, 2, 169, 'SAN AGUSTIN', 2),
(1, 19, 2, 170, 'SANTA HELENA DE UPIA', 2);

INSERT INTO roles (id_role,nom_role) VALUES (1,'Administrador'),(2,'Candidato'),(3,'Editor');


INSERT INTO usuarios (id_role,id_puestodevotacion, id_usuario,nom_usuario,correo_usuario,clave_usuario,url_imagen, updateAt) 
VALUES (1,1,1,'admin','admin@gmail.com','$2b$10$8pYo.Bf0WwZkWyb6vQotSue.xO15CqPsVE4pQyPdrnhXRI9xg18yu','https://res.cloudinary.com/do56sbqpw/image/upload/v1695579119/users/scj7lrbuka5lyj4erwbl.png',TO_TIMESTAMP(0)),
(2,2,2,'candidato','candidato@gmail.com','$2b$10$qYg2e1IcF5mutGDwE3Vt2.yfXSB5nPYTE6gm2YXT25tVYdekPq4qe','https://res.cloudinary.com/do56sbqpw/image/upload/v1695579119/users/scj7lrbuka5lyj4erwbl.png', CURRENT_TIMESTAMP),
(3,3,3,'editor','editor@gmail.com','$2b$10$jf.qzTQntF5cTpo3s8kcoerk2G1a3RNKw3wXlpjVimZr6CtcXOl9u','https://res.cloudinary.com/do56sbqpw/image/upload/v1695579119/users/scj7lrbuka5lyj4erwbl.png', CURRENT_TIMESTAMP);

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
