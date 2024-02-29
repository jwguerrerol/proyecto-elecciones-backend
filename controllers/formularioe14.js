const { pool } = require('../db/connection')
const formulariose14Router = require('express').Router()

formulariose14Router.get( `/formulariose14/:id_puestodevotacion/:id_mesa`, async (request, response) => {
  const { id_puestodevotacion, id_mesa } = request.params
  try {
    const result = await pool.query(`SELECT mesas.id_puestodevotacion, mesas.id_mesa, mesas.id_usuario, mesas.votos_incinerados, mesas.total_sufragantes, mesas.total_votos_urna, mesas.votos_candidato1, mesas.votos_candidato2, mesas.votos_candidato3, mesas.votos_candidato4, mesas.votos_candidato5, mesas.votos_candidato6, mesas.votos_candidato7, mesas.votos_candidato8, mesas.votos_candidato9, mesas.votos_blancos, mesas.votos_nulos, mesas.votos_no_marcados, mesas.total_votosmesa, mesas.observaciones, mesas.url_imagen_e14, mesas.created_at, puestosdevotacion.id_departamento, puestosdevotacion.id_municipio FROM mesas JOIN puestosdevotacion ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion WHERE puestosdevotacion.id_puestodevotacion = ${ id_puestodevotacion } AND id_mesa = ${id_mesa};`)
    const res = result.rows
    if (res.length > 0) {
      const dataForm = res[0]
      return response.json(dataForm)
    }
    return response.json({ error: "El formulario no ha sido enviado"})
    } catch (error) {
    return response.json(error).status(500)
  }
})

module.exports = formulariose14Router