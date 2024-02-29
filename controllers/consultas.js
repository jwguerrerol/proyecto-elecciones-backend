const { pool } = require('../db/connection')
const consultasRouter = require('express').Router()

consultasRouter.get('/consultas/mesas-enviadas', async (request, response) => {
  try {
    const query = await pool.query(' SELECT puestosdevotacion.id_municipio, mesas.id_puestodevotacion, mesas.id_mesa FROM mesas JOIN puestosdevotacion ON puestosdevotacion.id_puestodevotacion = mesas.id_puestodevotacion  WHERE mesas.estado_envio_mesa = true GROUP BY mesas.id_puestodevotacion, mesas.id_mesa, puestosdevotacion.id_municipio ORDER BY mesas.id_puestodevotacion ASC;')
      const result = query.rows
      if(result.length > 0) {
        return  response.json(result).status(200)
      }

      if(result === 0) {
        return response.status(204)
      }
  } catch(error){
    return response.json(error).status(500)
  }
})

consultasRouter.get('/consultas/mesas', async (request, response) => {
  try {
    const query = await pool.query('SELECT puestosdevotacion.id_departamento, departamentos.nom_departamento, puestosdevotacion.id_municipio, municipios.nom_municipio,  mesas.id_puestodevotacion,  mesas.id_mesa, estado_envio_mesa  FROM mesas JOIN puestosdevotacion ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion JOIN departamentos ON puestosdevotacion.id_departamento = departamentos.id_departamento JOIN municipios ON puestosdevotacion.id_municipio = municipios.id_municipio   GROUP BY mesas.id_puestodevotacion, departamentos.nom_departamento, puestosdevotacion.id_municipio, municipios.nom_municipio,   mesas.id_mesa, puestosdevotacion.id_departamento ORDER BY mesas.id_puestodevotacion ASC, mesas.id_mesa ASC;')
      const result = query.rows
      if(result.length > 0) {
        return  response.json(result).status(200)
      }

      if(result === 0) {
        return response.status(204)
      }
  } catch(error){
    return response.json(error).status(500)
  }
})

consultasRouter.get('/consultas/votos/candidatos/:departamentoSeleccionado/:municipioSeleccionado/:puestoDeVotacionSeleccionado/:mesaSeleccionada', async (request, response) => {

  const departamentoSeleccionado = Number(request.params.departamentoSeleccionado)
  const municipioSeleccionado = Number(request.params.municipioSeleccionado)
  const puestoDeVotacionSeleccionado = Number(request.params.puestoDeVotacionSeleccionado)
  const mesaSeleccionada = Number(request.params.mesaSeleccionada)
  /* console.log( departamentoSeleccionado, municipioSeleccionado, puestoDeVotacionSeleccionado, mesaSeleccionada ) */

  const candidatos = await pool.query('SELECT * FROM candidatos').then(response => response.rows)
  const votosPorDefecto = candidatos.map(candidato => {
    return { ...candidato, votos : 0 }
  })

  if (departamentoSeleccionado && municipioSeleccionado && puestoDeVotacionSeleccionado && mesaSeleccionada) {
    /* console.log('parametros recibidos desde la url 1') */
    try {
      const query = await pool.query(`
      SELECT resultados.id_departamento, departamentos.nom_departamento, resultados.id_municipio, municipios.nom_municipio, resultados.id_puestodevotacion, puestosdevotacion.nom_puestodevotacion, resultados.id_mesa, resultados.id_candidato, candidatos.nom_candidato, candidatos.url_imagen, candidatos.id_partido, partidos.nom_partido, resultados.votos
      FROM 
          (SELECT id_departamento, id_municipio, id_puestodevotacion, id_mesa, id_candidato, sum(votos) votos  from v_c 
          WHERE id_departamento = ${ departamentoSeleccionado } AND id_municipio = ${ municipioSeleccionado}  AND  id_puestodevotacion = ${ puestoDeVotacionSeleccionado } AND id_mesa = ${ mesaSeleccionada } AND estado_envio_mesa = true
          GROUP BY id_departamento, id_candidato, id_municipio, id_puestodevotacion, id_mesa
          ORDER BY id_candidato ASC)  resultados 
      JOIN departamentos ON resultados.id_departamento = departamentos.id_departamento
      JOIN municipios ON resultados.id_municipio = municipios.id_municipio
      JOIN puestosdevotacion ON resultados.id_puestodevotacion = puestosdevotacion.id_puestodevotacion  
      JOIN candidatos ON resultados.id_candidato = candidatos.id_candidato 
      JOIN partidos ON candidatos.id_partido = partidos.id_partido
      ORDER BY id_candidato ASC
      `)
      const queryrows = query.rows
      /* console.log({ queryrows }) */
      if(queryrows[0]) {
        return response.json(queryrows).status(200)
      } else if (queryrows.length === 0) {
        return response.json({ error: 'No se han recibido datos de la mesa seleccionada'}).status(200)
      } else {
        return response.json(votosPorDefecto).status(200)
      }
    } catch (error) {
      return response.send({ error: '' }).status(500)
    }
  } else if (departamentoSeleccionado && municipioSeleccionado && puestoDeVotacionSeleccionado) {
    /* console.log('parametros recibidos desde la url 2') */
    try {
      const query = await pool.query(`
      SELECT resultados.id_departamento, departamentos.nom_departamento, resultados.id_municipio, municipios.nom_municipio, resultados.id_puestodevotacion, puestosdevotacion.nom_puestodevotacion, resultados.id_candidato, candidatos.nom_candidato, candidatos.url_imagen, candidatos.id_partido, partidos.nom_partido, resultados.votos
      FROM 
          (SELECT id_departamento, id_municipio, id_puestodevotacion, id_candidato, sum(votos) votos  from v_c 
          WHERE id_departamento = ${ departamentoSeleccionado } AND id_municipio = ${ municipioSeleccionado }  AND  id_puestodevotacion = ${ puestoDeVotacionSeleccionado } AND estado_envio_mesa = true
          GROUP BY id_departamento, id_candidato, id_municipio, id_puestodevotacion
          ORDER BY id_candidato ASC)  resultados 
      JOIN departamentos ON resultados.id_departamento = departamentos.id_departamento
      JOIN municipios ON resultados.id_municipio = municipios.id_municipio
      JOIN puestosdevotacion ON resultados.id_puestodevotacion = puestosdevotacion.id_puestodevotacion  
      JOIN candidatos ON resultados.id_candidato = candidatos.id_candidato 
      JOIN partidos ON candidatos.id_partido = partidos.id_partido
      ORDER BY id_candidato ASC
      `)
      const queryrows = query.rows
      /* console.log({ queryrows }) */
      if(queryrows[0]) {
        return response.json(queryrows).status(200)
      } else if (queryrows.length === 0) {
        return response.json({ error: 'No se han recibido datos del puesto de votación seleccionado'}).status(200)
      } else {
        return response.json(votosPorDefecto).status(200)
      }
    } catch (error) {
      return response.send({ error }).status(500)
    }
  } else if (departamentoSeleccionado && municipioSeleccionado ) {
    /* console.log('parametros recibidos desde la url 3') */
    try {
      const query = await pool.query(`
      SELECT resultados.id_departamento, resultados.id_municipio, municipios.nom_municipio, departamentos.nom_departamento, resultados.id_candidato, resultados.votos, candidatos.nom_candidato, candidatos.url_imagen, candidatos.id_partido, partidos.nom_partido 
      FROM 
          (SELECT id_departamento, id_municipio, id_candidato, sum(votos) votos  from v_c 
          WHERE id_departamento = ${ departamentoSeleccionado } AND id_municipio = ${ municipioSeleccionado } AND estado_envio_mesa = true 
          GROUP BY id_departamento, id_candidato, id_municipio
          ORDER BY id_candidato ASC)  resultados 
      JOIN departamentos ON resultados.id_departamento = departamentos.id_departamento
      JOIN municipios ON resultados.id_municipio = municipios.id_municipio  
      JOIN candidatos ON resultados.id_candidato = candidatos.id_candidato 
      JOIN partidos ON candidatos.id_partido = partidos.id_partido
      ORDER BY id_candidato ASC
      `)
      const queryrows = query.rows
      /* console.log({ queryrows }) */
      if(queryrows[0]) {
        return response.json(queryrows).status(200)
      } else if (queryrows.length === 0) {
        return response.json({ error: 'No se han recibido datos del municipio seleccionado'}).status(200)
      } else {
        return response.json(votosPorDefecto).status(200)
      }
    } catch (error) {
      return response.send({ error }).status(500)
    }
  } else if (departamentoSeleccionado ) {
    /* console.log('parametros recibidos desde la url 4') */
    try {
      const query = await pool.query(`
      select resultados.id_departamento, departamentos.nom_departamento, resultados.id_candidato, resultados.votos, candidatos.nom_candidato, candidatos.url_imagen, candidatos.id_partido, partidos.nom_partido FROM (select id_departamento, id_candidato, sum(votos) votos  from v_c WHERE id_departamento = ${ departamentoSeleccionado } AND estado_envio_mesa = true  GROUP BY id_departamento, id_candidato ORDER BY id_candidato ASC)  resultados JOIN departamentos ON resultados.id_departamento = departamentos.id_departamento  JOIN candidatos ON resultados.id_candidato = candidatos.id_candidato JOIN partidos ON candidatos.id_partido = partidos.id_partido ORDER BY id_candidato ASC`)
      const queryrows = query.rows
      /* console.log('resultados fitro solo departamento')
      console.log({ queryrows }) */
      if(queryrows[0]) {
        return response.json(queryrows).status(200)
      } else {
        return response.json(votosPorDefecto).status(200)
      }
    } catch (error) {
      return response.send({ error }).status(500)
    }
  }

  return response.send(error).status(500)
})

consultasRouter.get('/consultas/votos/otras-opciones', async (request, response) => {
  try {
    const query = await pool.query(`SELECT SUM(votos_nulos) AS votos_nulos, SUM(votos_blancos) AS votos_blancos, SUM(votos_no_marcados) AS votos_no_marcados FROM mesas;`)
    response.json(query.rows[0]).status(200)
  } catch (error) {
    response.send({ error }).status(500)
  }
})

consultasRouter.get('/consultas/votos/otras-opciones/:departamentoSeleccionado/:municipioSeleccionado/:puestoDeVotacionSeleccionado/:mesaSeleccionada', async (request, response) => {

  const departamentoSeleccionado = Number(request.params.departamentoSeleccionado)
  const municipioSeleccionado = Number(request.params.municipioSeleccionado)
  const puestoDeVotacionSeleccionado = Number(request.params.puestoDeVotacionSeleccionado)
  const mesaSeleccionada = Number(request.params.mesaSeleccionada)
  /* console.log( departamentoSeleccionado, municipioSeleccionado, puestoDeVotacionSeleccionado, mesaSeleccionada ) */

  const objectForError = {
    votos_blancos: 0,
    votos_nulos: 0,
    votos_no_marcados: 0
  }

  if (departamentoSeleccionado && municipioSeleccionado && puestoDeVotacionSeleccionado && mesaSeleccionada) {
    console.log('parametros recibidos desde la url 1')
    try {
      const query = await pool.query(`SELECT SUM(mesas.votos_blancos) AS votos_blancos, SUM(mesas.votos_nulos) AS votos_nulos, SUM(mesas.votos_no_marcados) AS votos_no_marcados FROM mesas JOIN puestosdevotacion  ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion WHERE  puestosdevotacion.id_departamento = ${ departamentoSeleccionado } AND puestosdevotacion.id_municipio = ${ municipioSeleccionado } AND mesas.id_puestodevotacion = ${ puestoDeVotacionSeleccionado } AND mesas.id_mesa = ${mesaSeleccionada};`)
      const queryrows = query.rows[0]
      /* console.log({ queryrows }) */
      if(queryrows.votos_blancos) {
        return response.json(queryrows).status(200)
      } else {
        return response.json(objectForError).status(200)
      }
    } catch (error) {
      return response.send({ error }).status(500)
    }
  } else if (departamentoSeleccionado && municipioSeleccionado && puestoDeVotacionSeleccionado) {
    /* console.log('parametros recibidos desde la url 2') */
    try {
      const query = await pool.query(`SELECT SUM(mesas.votos_blancos) AS votos_blancos, SUM(mesas.votos_nulos) AS votos_nulos, SUM(mesas.votos_no_marcados) AS votos_no_marcados FROM mesas JOIN puestosdevotacion  ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion WHERE  puestosdevotacion.id_departamento = ${ departamentoSeleccionado } AND puestosdevotacion.id_municipio = ${ municipioSeleccionado } AND mesas.id_puestodevotacion = ${ puestoDeVotacionSeleccionado };`)
      const queryrows = query.rows[0]
      /* console.log({ queryrows }) */
      if(queryrows.votos_blancos) {
        return response.json(queryrows).status(200)
      } else {
        return response.json(objectForError).status(200)
      }
    } catch (error) {
      return response.send({ error }).status(500)
    }
  } else if (departamentoSeleccionado && municipioSeleccionado ) {
    /* console.log('parametros recibidos desde la url 3') */
    try {
      const query = await pool.query(`SELECT SUM(mesas.votos_blancos) AS votos_blancos, SUM(mesas.votos_nulos) AS votos_nulos, SUM(mesas.votos_no_marcados) AS votos_no_marcados FROM mesas JOIN puestosdevotacion  ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion WHERE  puestosdevotacion.id_departamento = ${ departamentoSeleccionado } AND puestosdevotacion.id_municipio = ${ municipioSeleccionado };`)
      const queryrows = query.rows[0]
      /* console.log({ queryrows }) */
      if(queryrows.votos_blancos) {
        return response.json(queryrows).status(200)
      } else {
        return response.json(objectForError).status(200)
      }
    } catch (error) {
      return response.send({ error }).status(500)
    }
  } else if (departamentoSeleccionado ) {
   /*  console.log('parametros recibidos desde la url 4') */
    try {
      const query = await pool.query(`SELECT SUM(mesas.votos_blancos) AS votos_blancos, SUM(mesas.votos_nulos) AS votos_nulos, SUM(mesas.votos_no_marcados) AS votos_no_marcados FROM mesas JOIN puestosdevotacion  ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion WHERE  puestosdevotacion.id_departamento = 1 AND puestosdevotacion.id_municipio = 1;`)
      const queryrows = query.rows[0]
      /* console.log({ queryrows }) */
      if(queryrows.votos_blancos) {
        return response.json(queryrows).status(200)
      } else {
        return response.json(objectForError).status(200)
      }
    } catch (error) {
      return response.send({ error }).status(500)
    }
  } 

  return response.send(error).status(500)
})


consultasRouter.get('/consultas/mesas-por-usuario/:id', async (request, response) => {
  const id = request.params.id
  try {
    const query = await pool.query(`SELECT usuarios.id_usuario, usuarios.nom_usuario, correo_usuario, usuarios.id_role, roles.nom_role, puestosdevotacion.id_puestodevotacion, puestosdevotacion.nom_puestodevotacion,puestosdevotacion.mesas_instaladas, departamentos.id_departamento, departamentos.nom_departamento, municipios.id_municipio, municipios.nom_municipio  FROM usuarios JOIN roles ON usuarios.id_role = roles.id_role JOIN puestosdevotacion ON usuarios.id_puestodevotacion = puestosdevotacion.id_puestodevotacion JOIN departamentos ON puestosdevotacion.id_departamento = departamentos.id_departamento JOIN municipios ON puestosdevotacion.id_municipio = municipios.id_municipio  WHERE usuarios.id_usuario = ${id};`)
    response.json(query.rows[0]).status(200)
  } catch (error) {
    response.send({ error }).status(500)
  }
})

// Es necesario actualizar para que solo reciba el parametro usuario, pero esta en espera de si solo trae las mesas cargadas por el usuario logueado
consultasRouter.get('/consultas/mesas-enviadas/:id_puestodevotacion/:id_usuario', async (request, response) => {
  const id_puestodevotacion = request.params.id_puestodevotacion

  /* console.log({ id_puestodevotacion }) */
    
  try {
    const query = await pool.query(`SELECT puestosdevotacion.id_departamento, departamentos.nom_departamento, puestosdevotacion.id_municipio, municipios.nom_municipio,  mesas.id_puestodevotacion,  mesas.id_mesa, estado_envio_mesa  FROM mesas JOIN puestosdevotacion ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion JOIN departamentos ON puestosdevotacion.id_departamento = departamentos.id_departamento JOIN municipios ON puestosdevotacion.id_municipio = municipios.id_municipio WHERE mesas.id_puestodevotacion = ${ id_puestodevotacion }   GROUP BY mesas.id_puestodevotacion, departamentos.nom_departamento, puestosdevotacion.id_municipio, municipios.nom_municipio,   mesas.id_mesa, puestosdevotacion.id_departamento ORDER BY mesas.id_puestodevotacion ASC, mesas.id_mesa ASC;`)
    const results = query.rows

    if(results.length > 0) {
      /* const newResults = results.map( result => result.id_mesa) */
      return response.json(results).status(200)
    } else {
      const newResults = []
      return response.json(newResults).status(200)
    } 
  } catch (error) {
    return response.json(error).status(500)
  }
})


consultasRouter.get('/consultas/mesas-enviadas/:id_departamento/:id_municipio/:id_puestodevotacion', async (request, response) => {
  const id_departamento = request.params.id_departamento
  const id_municipio = request.params.id_municipio
  const id_puestodevotacion = request.params.id_puestodevotacion

  /* console.log({ id_departamento })
  console.log({ id_municipio })
  console.log({ id_puestodevotacion }) */
    
  try {
    const query = await pool.query(`SELECT id_mesa FROM v_c WHERE id_departamento =${id_departamento} AND id_municipio = ${id_municipio} AND id_puestodevotacion = ${id_puestodevotacion} GROUP BY id_mesa;`)
    const results = query.rows
    const newResults = results.map( result => result.id_mesa)

    return response.json(newResults).status(200)
    
  } catch (error) {
    return response.json(error).status(500)
  }
})

/* consultasRouter.get('/consultas/filtros/:nombre_tabla', async (request, response) => {
  const { nombre_tabla } = request.params

  if(nombre_tabla === 'puestosdevotacion'){
    let arreglo = [...nombre_tabla] 
    let indice = 5
    arreglo = arreglo.slice(0,6).concat(arreglo.slice(7,17))
    const nombre_tabla_singular = arreglo.join('');
    console.log(nombre_tabla_singular)
    try {
      const query = await pool.query(`SELECT id_${ nombre_tabla_singular }, nom_${ nombre_tabla_singular }, mesas_instaladas, id_departamento, id_municipio FROM ${ nombre_tabla } ;`)
      const results = query.rows
      return response.json(results).status(200)
      
    } catch (error) {
      return response.json(error).status(500)
    }
  }if(nombre_tabla === 'municipios'){
    let arreglo = [...nombre_tabla] 
    let indice = 5
    arreglo = arreglo.slice(0,6).concat(arreglo.slice(7,17))
    const nombre_tabla_singular = arreglo.join('');
    console.log(nombre_tabla_singular)
    try {
      const query = await pool.query(`SELECT * FROM municipios;`)
      const results = query.rows
      return response.json(results).status(200)
      
    } catch (error) {
      return response.json(error).status(500)
    }
  }
  const nombre_tabla_singular = nombre_tabla.slice(0,-1)

  console.log(nombre_tabla, nombre_tabla_singular)
    
  try {
    const query = await pool.query(`SELECT id_${ nombre_tabla_singular }, nom_${ nombre_tabla_singular } FROM ${ nombre_tabla } ;`)
    const results = query.rows
    return response.json(results).status(200)
    
  } catch (error) {
    return response.json(error).status(500)
  }
}) */

consultasRouter.get('/consultas/resultados/candidatos', async(request, response) => {
  try {
    const query = await pool.query(`
      SELECT  resultados.id_candidato, candidatos.nom_candidato, candidatos.url_imagen, candidatos.id_partido, partidos.nom_partido, resultados.votos
      FROM 
          (SELECT id_candidato, sum(votos) votos  from v_c 
          WHERE estado_envio_mesa = true
          GROUP BY id_departamento, id_candidato)  resultados 
      JOIN candidatos ON resultados.id_candidato = candidatos.id_candidato 
      JOIN partidos ON candidatos.id_partido = partidos.id_partido
      GROUP BY resultados.id_candidato, candidatos.nom_candidato, candidatos.url_imagen, candidatos.id_partido, partidos.nom_partido, resultados.votos
      ORDER BY votos DESC
    `)
    const queryrows = query.rows
    /* console.log({ queryrows }) */
    if(queryrows[0]) {
      return response.json(queryrows).status(200)
    } else {
      return response.json({error: 'Consulta vacia'}).status(200)
    }

  }catch (error){
    return response.send({ error }).status(500)
  }
})

consultasRouter.get('/consultas/resultados/otras-opciones', async(request, response) => {
    try {
      const query = await pool.query(`SELECT SUM(mesas.votos_blancos) AS votos_blancos, SUM(mesas.votos_nulos) AS votos_nulos, SUM(mesas.votos_no_marcados) AS votos_no_marcados FROM mesas JOIN puestosdevotacion  ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion`)
      const queryrows = query.rows[0]
      /* console.log({ queryrows }) */
      if(queryrows.votos_blancos) {
        return response.json(queryrows).status(200)
      } else {
        return response.json(objectForError).status(200)
      }
    } catch (error) {
      return response.send({ error }).status(500)
    }
})

module.exports = consultasRouter