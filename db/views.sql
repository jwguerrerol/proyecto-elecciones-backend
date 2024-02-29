/*Vista base*/

CREATE VIEW v_c AS
SELECT puestosdevotacion.id_departamento, puestosdevotacion.id_municipio, mesas.id_puestodevotacion, mesas.id_mesa, candidatos.id_candidato AS id_candidato, candidatos.id_partido, mesas.votos_candidato1 AS votos
FROM mesas JOIN candidatos ON candidatos.id_candidato= 1 JOIN puestosdevotacion ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion
UNION ALL
SELECT puestosdevotacion.id_departamento, puestosdevotacion.id_municipio, mesas.id_puestodevotacion, mesas.id_mesa, candidatos.id_candidato AS id_candidato, candidatos.id_partido, mesas.votos_candidato2 AS votos
FROM mesas JOIN candidatos ON candidatos.id_candidato= 2 JOIN puestosdevotacion ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion
UNION ALL
SELECT puestosdevotacion.id_departamento, puestosdevotacion.id_municipio, mesas.id_puestodevotacion, mesas.id_mesa, candidatos.id_candidato AS id_candidato, candidatos.id_partido, mesas.votos_candidato3 AS votos
FROM mesas JOIN candidatos ON candidatos.id_candidato= 3 JOIN puestosdevotacion ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion
UNION ALL
SELECT puestosdevotacion.id_departamento, puestosdevotacion.id_municipio, mesas.id_puestodevotacion, mesas.id_mesa, candidatos.id_candidato AS id_candidato, candidatos.id_partido, mesas.votos_candidato4 AS votos
FROM mesas JOIN candidatos ON candidatos.id_candidato= 4 JOIN puestosdevotacion ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion
UNION ALL
SELECT puestosdevotacion.id_departamento, puestosdevotacion.id_municipio, mesas.id_puestodevotacion, mesas.id_mesa, candidatos.id_candidato AS id_candidato, candidatos.id_partido, mesas.votos_candidato5 AS votos
FROM mesas JOIN candidatos ON candidatos.id_candidato= 5 JOIN puestosdevotacion ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion
UNION ALL
SELECT puestosdevotacion.id_departamento, puestosdevotacion.id_municipio, mesas.id_puestodevotacion, mesas.id_mesa, candidatos.id_candidato AS id_candidato, candidatos.id_partido, mesas.votos_candidato6 AS votos
FROM mesas JOIN candidatos ON candidatos.id_candidato= 6 JOIN puestosdevotacion ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion
UNION ALL
SELECT puestosdevotacion.id_departamento, puestosdevotacion.id_municipio, mesas.id_puestodevotacion, mesas.id_mesa, candidatos.id_candidato AS id_candidato, candidatos.id_partido, mesas.votos_candidato7 AS votos
FROM mesas JOIN candidatos ON candidatos.id_candidato= 7 JOIN puestosdevotacion ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion
UNION ALL
SELECT puestosdevotacion.id_departamento, puestosdevotacion.id_municipio, mesas.id_puestodevotacion, mesas.id_mesa, candidatos.id_candidato AS id_candidato, candidatos.id_partido, mesas.votos_candidato8 AS votos
FROM mesas JOIN candidatos ON candidatos.id_candidato= 8 JOIN puestosdevotacion ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion
UNION ALL
SELECT puestosdevotacion.id_departamento, puestosdevotacion.id_municipio, mesas.id_puestodevotacion, mesas.id_mesa, candidatos.id_candidato AS id_candidato, candidatos.id_partido, mesas.votos_candidato9 AS votos
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
GROUP BY puestosdevotacion.id_departamento, departamentos.nom_departamento, puestosdevotacion.id_municipio, municipios.nom_municipio, v_c.id_puestodevotacion, puestosdevotacion.nom_puestodevotacion, v_c.id_candidato, candidatos.nom_candidato, candidatos.url_imagen, candidatos.id_partido, partidos.nom_partido, mesas.estado_envio_mesa
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
GROUP BY puestosdevotacion.id_departamento, departamentos.nom_departamento, puestosdevotacion.id_municipio, municipios.nom_municipio,  v_c.id_candidato, candidatos.nom_candidato, candidatos.url_imagen, candidatos.id_partido, partidos.nom_partido, mesas.estado_envio_mesa 
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
GROUP BY puestosdevotacion.id_departamento, departamentos.nom_departamento, v_c.id_candidato, candidatos.nom_candidato, candidatos.url_imagen, candidatos.id_partido, partidos.nom_partido, mesas.estado_envio_mesa 
ORDER BY votos DESC;

/*Vista sin filtros para la pagina de resultados*/

CREATE VIEW vista_votos_sin_filtros AS
SELECT 
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
JOIN candidatos 
    ON v_c.id_candidato = candidatos.id_candidato 
JOIN partidos 
    ON candidatos.id_partido = partidos.id_partido
GROUP BY v_c.id_candidato, candidatos.nom_candidato, candidatos.id_partido, partidos.nom_partido, mesas.estado_envio_mesa 
ORDER BY votos DESC;