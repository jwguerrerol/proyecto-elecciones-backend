const { pool } = require('../db/connection')
const puestosdevotacionRouter = require('express').Router()

puestosdevotacionRouter.get( '/puestosdevotacion', async (request, response) => {
  try {
    const result = await pool.query('SELECT * FROM puestosdevotacion;')
    const puestosdevotacion = result.rows
    response.json(puestosdevotacion).status(200)
  } catch (error) {
    response.send({ error }).status(500)
  }
})

puestosdevotacionRouter.get( `/puestosdevotacion/:id`, async (request, response) => {
  const { id } = request.params
  const result = await pool.query('SELECT * FROM puestosdevotacion WHERE id_puestodevotacion = $1;', [id])
  const puestodevotacion = result.rows
  response.json(puestodevotacion)
})

puestosdevotacionRouter.post( '/puestosdevotacion', async (request, response) => {
  const id_puestodevotacion = parseInt(request.body)
  try {
    const { nom_puestodevotacion, id_departamento, id_municipio, id_zona, mesas_instaladas  } = request.body
    await pool.query('INSERT INTO puestosdevotacion (id_puestodevotacion, nom_puestodevotacion, id_departamento, id_municipio, id_zona, mesas_instaladas ) VALUES  ($1, $2, $3, $4, $5, $6)', [id_puestodevotacion, nom_puestodevotacion, id_departamento, id_municipio, id_zona, mesas_instaladas ])
    response.status(200).json(request.body)
  } catch (error) {
    response.send(error)
  }
})

puestosdevotacionRouter.put( `/puestosdevotacion/:id`, async (request, response) => {
  const id = Number(request.params.id)
  const { id_puestodevotacion, nom_puestodevotacion, id_departamento, id_municipio, id_zona, mesas_instaladas  } = request.body
  const puestodevotacion = await pool.query('SELECT id_puestodevotacion FROM puestosdevotacion WHERE id_puestodevotacion = $1;', [id])
  /* console.log(puestodevotacion.rows) */
  try {
    const query = await pool.query('UPDATE puestosdevotacion SET nom_puestodevotacion = $2, id_departamento = $3, id_municipio = $4, id_zona = $5, mesas_instaladas  = $6 WHERE id_puestodevotacion= $1;', [id_puestodevotacion, nom_puestodevotacion, id_departamento, id_municipio, id_zona, mesas_instaladas ])
    if (puestodevotacion.rows.length === 0){
      return response.json({ message: 'puestodevotacion not found'})
    }
    return response.status(200).end()
  } catch (error) {
    return response.status(204)
  }
})

puestosdevotacionRouter.delete( `/puestosdevotacion/:id`, async (request, response) => {
  const { id } = request.params
  const puestodevotacion = await pool.query('SELECT id_puestodevotacion FROM puestosdevotacion WHERE id_puestodevotacion=$1',[id])
  /* console.log(puestodevotacion.rows) */

  const query = await pool.query('DELETE FROM puestosdevotacion WHERE id_puestodevotacion=$1',[id])
  response.status(204).end()
})

module.exports = puestosdevotacionRouter