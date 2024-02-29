const { pool } = require('../db/connection')
const candidatosRouter = require('express').Router()

candidatosRouter.get( '/candidatos', async (request, response) => {
  try {
    const result = await pool.query('SELECT candidatos.id_departamento, candidatos.id_candidato, candidatos.nom_candidato, candidatos.url_imagen, partidos.id_partido, partidos.nom_partido, partidos.url_imagen logo_partido FROM candidatos JOIN partidos ON candidatos.id_partido = partidos.id_partido ORDER BY candidatos.id_candidato ASC;')
    const candidatos = result.rows
    response.json(candidatos).status(200)
  } catch (error) {
    response.send({ error }).status(500)
  }
})

candidatosRouter.get( `/candidatos/:id`, async (request, response) => {
  const { id } = request.params
  const result = await pool.query('SELECT * FROM candidatos WHERE id_candidato = $1;', [id])
  const candidato = result.rows
  response.json(candidato)
})

candidatosRouter.post( '/candidatos', async (request, response) => {
  try {
    const { id_candidato, nom_candidato, id_departamento, id_partido, url_imagen } = request.body
    await pool.query('INSERT INTO candidatos (id_candidato, nom_candidato, id_departamento, id_partido, url_imagen) VALUES  ($1, $2, $3, $4, $5)', [id_candidato, nom_candidato, id_departamento, id_partido, url_imagen])
    response.status(200).json(request.body)
  } catch (error) {
    response.send(error)
  }
})

candidatosRouter.put( `/candidatos/:id`, async (request, response) => {
  const id = Number(request.params.id)
  const { id_candidato, nom_candidato, id_departamento, id_partido, url_imagen } = request.body
  const candidato = await pool.query('SELECT id_candidato FROM candidatos WHERE id_candidato = $1;', [id])
  try {
    const query = await pool.query('UPDATE candidatos SET nom_candidato = $2, id_departamento = $3, id_partido = $4, url_imagen = $5 WHERE id_candidato= $1;', [id_candidato, nom_candidato, id_departamento, id_partido, url_imagen])
    if (candidato.rows.length === 0){
      return response.json({ message: 'candidato not found'})
    }
    return response.status(200).end()
  } catch (error) {
    return response.status(204)
  }
})

candidatosRouter.delete( `/candidatos/:id`, async (request, response) => {
  const { id } = request.params
  const candidato = await pool.query('SELECT id_candidato FROM candidatos WHERE id_candidato=$1',[id])

  const query = await pool.query('DELETE FROM candidatos WHERE id_candidato=$1',[id])
  response.status(204).end()
})

module.exports = candidatosRouter

