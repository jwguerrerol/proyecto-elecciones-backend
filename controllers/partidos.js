const { pool } = require('../db/connection')
const partidosRouter = require('express').Router()

partidosRouter.get( '/partidos', async (request, response) => {
  try {
    const result = await pool.query('SELECT * FROM partidos;')
    const partidos = result.rows
    response.json(partidos).status(200)
  } catch (error) {
    response.send({ error }).status(500)
  }
})

partidosRouter.get( `/partidos/:id`, async (request, response) => {
  const { id } = request.params
  const result = await pool.query('SELECT * FROM partidos WHERE id_partido = $1;', [id])
  const partido = result.rows
  response.json(partido)
})

partidosRouter.post( '/partidos', async (request, response) => {
  /* console.log(request.body) */
  try {
    const { id_partido, nom_partido, url_imagen } = request.body
    await pool.query('INSERT INTO partidos (id_partido, nom_partido, url_imagen ) VALUES  ($1, $2, $3)', [id_partido, nom_partido, url_imagen])
    response.status(200).json(request.body)
  } catch (error) {
    response.send(error)
  }
})

partidosRouter.put( `/partidos/:id`, async (request, response) => {
  const id = Number(request.params.id)
  const { id_partido, nom_partido, url_imagen } = request.body
  const partido = await pool.query('SELECT id_partido FROM partidos WHERE id_partido = $1;', [id])
  /* console.log(partido.rows) */
  try {
    const query = await pool.query('UPDATE partidos SET nom_partido = $2, url_imagen = $3 WHERE id_partido= $1;', [id_partido, nom_partido, url_imagen])
    if (partido.rows.length === 0){
      return response.json({ message: 'partido not found'})
    }
    return response.status(200).end()
  } catch (error) {
    return response.status(204)
  }
})

partidosRouter.delete( `/partidos/:id`, async (request, response) => {
  const { id } = request.params
  const partido = await pool.query('SELECT id_partido FROM partidos WHERE id_partido=$1',[id])
  /* console.log(partido.rows) */

  const query = await pool.query('DELETE FROM partidos WHERE id_partido=$1',[id])
  response.status(204).end()
})

module.exports = partidosRouter