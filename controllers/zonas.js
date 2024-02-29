const { pool } = require('../db/connection')
const zonasRouter = require('express').Router()

zonasRouter.get( '/zonas', async (request, response) => {
  try {
    const result = await pool.query('SELECT * FROM zonas;')
    const zonas = result.rows
    response.json(zonas).status(200)
  } catch (error) {
    response.send({ error }).status(500)
  }
})

zonasRouter.get( `/zonas/:id`, async (request, response) => {
  const { id } = request.params
  const result = await pool.query('SELECT * FROM zonas WHERE id_zona = $1;', [id])
  const zona = result.rows
  response.json(zona)
})

zonasRouter.post( '/zonas', async (request, response) => {
  /* console.log(request.body) */
  try {
    const { id_zona, nom_zona } = request.body
    await pool.query('INSERT INTO zonas (id_zona, nom_zona ) VALUES  ($1, $2)', [id_zona, nom_zona])
    response.status(200).json(request.body)
  } catch (error) {
    response.send(error)
  }
})

zonasRouter.put( `/zonas/:id`, async (request, response) => {
  const id = Number(request.params.id)
  const { id_zona, nom_zona } = request.body
  const zona = await pool.query('SELECT id_zona FROM zonas WHERE id_zona = $1;', [id])
 /*  console.log(zona.rows) */
  try {
    const query = await pool.query('UPDATE zonas SET nom_zona = $2  WHERE id_zona= $1;', [id_zona, nom_zona])
    if (zona.rows.length === 0){
      return response.json({ message: 'zona not found'})
    }
    return response.status(200).end()
  } catch (error) {
    return response.status(204)
  }
})

zonasRouter.delete( `/zonas/:id`, async (request, response) => {
  const { id } = request.params
  const zona = await pool.query('SELECT id_zona FROM zonas WHERE id_zona=$1',[id])
  /* console.log(zona.rows) */

  const query = await pool.query('DELETE FROM zonas WHERE id_zona=$1',[id])
  response.status(204).end()
})

module.exports = zonasRouter