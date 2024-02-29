const { pool } = require('../db/connection')
const rolesRouter = require('express').Router()
const jwt = require('jsonwebtoken')
const middleware = require('../utils/middleware')
require('dotenv').config()


rolesRouter.get( '/roles', async (request, response) => {
  try {
    const result = await pool.query('SELECT * FROM roles;')
    const roles = result.rows
    response.json(roles).status(200)
  } catch (error) {
    response.send({ error }).status(500)
  }
})

rolesRouter.get( `/roles/:id`, async (request, response) => {
  const { id } = request.params
  const result = await pool.query('SELECT * FROM roles WHERE id_role = $1;', [id])
  const role = result.rows
  response.json(role)
})

rolesRouter.post( '/roles', async (request, response) => {
  const body = request.body

  try {
    const { id_role, nom_role } = request.body
    await pool.query('INSERT INTO roles (id_role, nom_role) VALUES  ($1, $2)', [id_role, nom_role])
    response.status(200).json(request.body)
  } catch (error) {
    response.send(error)
  }
})

rolesRouter.put( `/roles/:id`, async (request, response) => {
  const id = Number(request.params.id)
  const { id_role, nom_role } = request.body
  const role = await pool.query('SELECT id_role FROM roles WHERE id_role = $1;', [id])
  /* console.log(role.rows) */
  try {
    const query = await pool.query('UPDATE roles SET nom_role = $2 WHERE id_role= $1;', [id_role, nom_role])
    if (role.rows.length === 0){
      return response.json({ message: 'role not found'})
    }
    return response.status(200).end()
  } catch (error) {
    return response.status(204)
  }
})

rolesRouter.delete( `/roles/:id`, async (request, response) => {
  const { id } = request.params
  const role = await pool.query('SELECT id_role FROM roles WHERE id_role=$1',[id])
  /* console.log(role.rows) */

  const query = await pool.query('DELETE FROM roles WHERE id_role=$1',[id])
  response.status(204).end()
})

module.exports = rolesRouter