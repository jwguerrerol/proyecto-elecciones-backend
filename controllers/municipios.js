const { pool } = require('../db/connection')
const municipiosRouter = require('express').Router()

municipiosRouter.get( '/municipios', async (request, response) => {
  try {
    const result = await pool.query('SELECT * FROM municipios ORDER BY id_municipio;')
    const municipios = result.rows
    response.json(municipios).status(200)
  } catch (error) {
    response.send({ error }).status(500)
  }
})

municipiosRouter.get( `/municipios/:id`, async (request, response) => {
  const { id } = request.params
  const result = await pool.query('SELECT * FROM municipios WHERE id_municipio = $1;', [id])
  const municipio = result.rows
  response.json(municipio)
})

municipiosRouter.post( '/municipios', async (request, response) => {
  /* console.log(request.body) */
  try {
    const { id_municipio, nom_municipio, id_departamento } = request.body
    await pool.query('INSERT INTO municipios (id_municipio, nom_municipio, id_departamento) VALUES  ($1, $2, $3)', [id_municipio, nom_municipio, id_departamento])
    response.status(200).json(request.body)
  } catch (error) {
    response.send(error)
  }
})

municipiosRouter.put( `/municipios/:id`, async (request, response) => {
  const id = Number(request.params.id)
  const { id_municipio, nom_municipio, id_departamento } = request.body
  const municipio = await pool.query('SELECT id_municipio FROM municipios WHERE id_municipio = $1;', [id])
  /* console.log(municipio.rows) */
  try {
    const query = await pool.query('UPDATE municipios SET nom_municipio = $2, id_departamento = $3 WHERE id_municipio= $1;', [id_municipio, nom_municipio, id_departamento])
    if (municipio.rows.length === 0){
      return response.json({ message: 'municipio not found'})
    }
    return response.status(200).end()
  } catch (error) {
    return response.status(204)
  }
})

municipiosRouter.delete( `/municipios/:id`, async (request, response) => {
  const { id } = request.params
  const municipio = await pool.query('SELECT id_municipio FROM municipios WHERE id_municipio=$1',[id])
  /* console.log(municipio.rows) */

  const query = await pool.query('DELETE FROM municipios WHERE id_municipio=$1',[id])
  response.status(204).end()
})

module.exports = municipiosRouter