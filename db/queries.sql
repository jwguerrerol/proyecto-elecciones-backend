/* Consulta para cuando se reciben todos los datos: id_departamento, id_municipio, id_puestodevotacion y id_mesa */

SELECT 
id_departamento,
nom_departamento,
id_municipio,
nom_municipio,
id_puestodevotacion,
nom_puestodevotacion,
id_mesa,
id_candidato,
nom_candidato,
id_partido,
nom_partido,
sum(votos) AS votos
FROM vista_votos_todos_los_filtros
WHERE
id_departamento = 1
AND
id_municipio = 1
AND
id_puestodevotacion = 1
AND
id_mesa = 5
GROUP BY
id_departamento,
nom_departamento,
id_municipio,
nom_municipio,
id_puestodevotacion,
nom_puestodevotacion,
id_mesa,
id_candidato,
nom_candidato,
id_partido,
nom_partido,
votos
ORDER BY
votos
DESC;

/* Consulta para cuando no se recibe el id_mesa */

SELECT 
id_departamento,
nom_departamento,
id_municipio,
nom_municipio,
id_puestodevotacion,
nom_puestodevotacion,
id_candidato,
nom_candidato,
id_partido,
nom_partido,
sum(votos)
FROM vista_votos_sin_filtro_mesas
WHERE
id_departamento = 1
AND
id_municipio = 1
AND
id_puestodevotacion = 1
GROUP BY
id_departamento,
nom_departamento,
id_municipio,
nom_municipio,
id_puestodevotacion,
nom_puestodevotacion,
id_candidato,
nom_candidato,
id_partido,
nom_partido,
votos
ORDER BY
votos
DESC;

/* Consulta para cuando no se filtra por: id_mesa ni id_puestodevotacion */

SELECT 
id_departamento,
nom_departamento,
id_municipio,
nom_municipio,
id_candidato,
nom_candidato,
id_partido,
nom_partido,
sum(votos)
FROM vista_votos_sin_filtro_mesas_puestosdevotacion
WHERE
id_departamento = 1
AND
id_municipio = 1
GROUP BY
id_departamento,
nom_departamento,
id_municipio,
nom_municipio,
id_candidato,
nom_candidato,
id_partido,
nom_partido,
votos
ORDER BY
votos
DESC;

/* Consulta para cuando solo se filtra por id_departamento*/

SELECT 
id_departamento,
nom_departamento,
id_candidato,
nom_candidato,
id_partido,
nom_partido,
sum(votos)
FROM vista_votos_solo_filtro_departamento
WHERE
id_departamento = 1
GROUP BY
id_departamento,
nom_departamento,
id_candidato,
nom_candidato,
id_partido,
nom_partido,
votos
ORDER BY
votos
DESC;