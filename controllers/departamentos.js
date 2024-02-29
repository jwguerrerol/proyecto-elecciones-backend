const { pool } = require('../db/connection')
const departamentosRouter = require('express').Router()

departamentosRouter.get( '/departamentos', async (request, response) => {
  try {
    const result = await pool.query('SELECT * FROM departamentos;')
    const departamentos = result.rows
    response.json(departamentos).status(200)
  } catch (error) {
    response.send({ error }).status(500)
  }
})

departamentosRouter.get( `/departamentos/:id`, async (request, response) => {
  const { id } = request.params
  const result = await pool.query('SELECT * FROM departamentos WHERE id_departamento = $1;', [id])
  const departamento = result.rows
  response.json(departamento)
})

departamentosRouter.post( '/departamentos', async (request, response) => {
  /* console.log(request.body) */
  try {
    const { id_departamento, nom_departamento } = request.body
    await pool.query('INSERT INTO departamentos (id_departamento, nom_departamento ) VALUES  ($1, $2)', [id_departamento, nom_departamento ])
    response.status(200).json(request.body)
  } catch (error) {
    response.send(error)
  }
})

departamentosRouter.put( `/departamentos/:id`, async (request, response) => {
  const id = Number(request.params.id)
  const { id_departamento, nom_departamento } = request.body
  const departamento = await pool.query('SELECT id_departamento FROM departamentos WHERE id_departamento = $1;', [id])
  /* console.log(departamento.rows) */
  try {
    const query = await pool.query('UPDATE departamentos SET nom_departamento = $2 WHERE id_departamento= $1;', [id_departamento, nom_departamento])
    if (departamento.rows.length === 0){
      return response.json({ message: 'departamento not found'})
    }
    return response.status(200).end()
  } catch (error) {
    return response.status(204)
  }
})

departamentosRouter.delete( `/departamentos/:id`, async (request, response) => {
  const { id } = request.params
  const departamento = await pool.query('SELECT id_departamento FROM departamentos WHERE id_departamento=$1',[id])
  /* console.log(departamento.rows) */

  const query = await pool.query('DELETE FROM departamentos WHERE id_departamento=$1',[id])
  response.status(204).end()
})

module.exports = departamentosRouter