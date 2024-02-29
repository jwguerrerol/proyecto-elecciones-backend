const jwt = require('jsonwebtoken')
const bcrypt = require('bcrypt')
const { pool } = require('../db/connection')
const loginRouter = require('express').Router()
require('dotenv').config

loginRouter.post('/', async (request, response, next) => {
  try {
    const { correo_usuario, clave_usuario } = request.body
    const query = await pool.query("SELECT * FROM usuarios WHERE correo_usuario=$1;", [correo_usuario])
    const user = query.rows[0]
    /* console.log({ user }) */
    
    const passwordCorrect = user === undefined ? 
      false 
      :
      await bcrypt.compare(clave_usuario, user.clave_usuario)

      if (!(user && passwordCorrect)) {
        return response.status(401).json({
          error: 'Email o contraseña incorrectos'
      })
    }

    const userForToken = {
      id: user.id_usuario,
      email : user.correo_usuario,
      role: user.id_role
    }

    // without expire
    //   const token = jwt.sign(userForToken, process.env.SECRET, { expiresIn: 60*60 })
    const token = jwt.sign(userForToken, process.env.SECRET)

    response
      .status(200)
      .send({ token, email: user.correo_usuario, role: user.id_role, id: user.id_usuario })
  } catch (error) {
      return response.status(500)
  }
})

module.exports = loginRouter