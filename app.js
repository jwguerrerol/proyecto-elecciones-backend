const express = require('express')
const cors = require('cors')
const multer = require('multer')
const path = require('path')
const config = require('./utils/config')
const { requestLogger, unknownEndpoint, tokenExtractor, errorHandler } = require('./utils/middleware')
const usuariosRouter = require('./controllers/usuarios')
const { conectionDB } = require('./db/connection')
const loginRouter = require('./controllers/login')
const rolesRouter = require('./controllers/roles')
const zonasRouter = require('./controllers/zonas')
const departamentosRouter = require('./controllers/departamentos')
const municipiosRouter = require('./controllers/municipios')
const partidosRouter = require('./controllers/partidos')
const candidatosRouter = require('./controllers/candidatos')
const puestosdevotacionRouter = require('./controllers/puestosdevotacion')
const mesasRouter = require('./controllers/mesas')
const consultasRouter = require('./controllers/consultas')
const formulariose14Router = require('./controllers/formularioe14')

const urlBase = `${process.env.URL_BASE}`

const app = express()

app.use(cors())
app.use(express.json())
app.use(requestLogger)

app.use(express.static(path.join(__dirname, 'build')));

// Ruta principal que sirve el archivo HTML de tu aplicación React
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'build', 'index.html'));
});

// Servir imágenes guardadas en uploads/images, con una ruta diferente protegiendo además los archivos del servidor
app.use('/uploads/images', express.static('./uploads/images'));

app.use('/login',loginRouter)
app.use(usuariosRouter)
/* app.use(tokenExtractor) */
// Ruta para subir la imagen
app.use(consultasRouter)
app.use(rolesRouter)
app.use(zonasRouter)
app.use(departamentosRouter)
app.use(municipiosRouter)
app.use(partidosRouter)
app.use(candidatosRouter)
app.use(puestosdevotacionRouter)
app.use(mesasRouter)
app.use(formulariose14Router)

app.use(unknownEndpoint)
app.use(errorHandler)
module.exports = app