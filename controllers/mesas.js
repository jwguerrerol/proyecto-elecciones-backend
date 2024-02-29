const { pool } = require('../db/connection')
const mesasRouter = require('express').Router()
require('dotenv').config()

const urlBase = `${process.env.URL_BASE}`
const multer = require("multer");
const path = require('path')

const cloudinary = require('cloudinary').v2;
const { CloudinaryStorage } = require('multer-storage-cloudinary');

/* // FORMA ANTERIOR DE ALMACER LOS ARCHIVOS EN EL SERVIDOR BACKEND
// Configura la ubicación donde se guardarán las imágenes
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, './uploads/images/users'); // Directorio de destino
  },
  filename: (req, file, cb) => {
    const extname = path.extname(file.originalname);
    const filename = `${Date.now()}-${Math.random().toString(36).substring(2, 7)}${extname}`;
    cb(null, filename);
  },
});

// Configura los tipos de archivos permitidos y el tamaño máximo del archivo
const upload = multer({
  storage: storage,
  limits: {
    fileSize: 1024 * 1024 * 5, // 5 MB
  },
  fileFilter: (req, file, cb) => {
    const allowedFileTypes = /jpeg|jpg|png|gif/;
    const extname = allowedFileTypes.test(path.extname(file.originalname).toLowerCase());
    if (extname) {
      return cb(null, true);
    }
    cb("Error: Solo se permiten imágenes JPEG, JPG, PNG o GIF.");
  },
}); */

// ALMACENANDO ARCHIVOS EN CLOUDINARY
cloudinary.config({
  cloud_name: process.env.CLOUD_NAME,
  api_key: process.env.API_KEY,
  api_secret: process.env.API_SECRET,
});

// Configura la ubicación donde se guardarán las imágenes
const storage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: 'formulariose14', // Carpeta en Cloudinary donde se almacenarán las imágenes
    allowed_formats: ['jpg', 'jpeg', 'png', 'gif'], // Tipos de archivo permitidos
    // Puedes agregar otras opciones de configuración de Cloudinary aquí
  },
  transformation: [
    { width: 1200, height: 1200, crop: 'limit' } // Configura la optimización de la imagen aquí
  ]
});

// Configura los tipos de archivos permitidos y el tamaño máximo del archivo
const upload = multer({
  storage: storage,
  /* limits: {
    fileSize: 1024 * 1024 * 5, // 5 MB
  }, */
  fileFilter: (req, file, cb) => {
    const allowedFileTypes = /jpeg|jpg|png|gif/;
    const extname = allowedFileTypes.test(path.extname(file.originalname).toLowerCase());
    if (extname) {
      return cb(null, true);
    }
    cb("Error: Solo se permiten imágenes JPEG, JPG, PNG o GIF.");
  },
});

mesasRouter.get('/mesas', async (request, response) => {
  try {
    const result = await pool.query('SELECT *, puestosdevotacion.id_departamento, puestosdevotacion.id_municipio FROM mesas JOIN puestosdevotacion ON mesas.id_puestodevotacion = puestosdevotacion.id_puestodevotacion;')
    const mesas = result.rows
    response.json(mesas).status(200)
  } catch (error) {
    response.send({ error }).status(500)
  }
})

mesasRouter.get(`/mesas/:id`, async (request, response) => {
  const { id } = request.params
  const result = await pool.query('SELECT * FROM mesas WHERE id_mesa = $1;', [id])
  const mesa = result.rows
  response.json(mesa)
})

mesasRouter.post('/mesas', upload.single('url_imagen_e14'), async (request, response) => {
  /* console.log(request.file) */
  /* const sentFile = request.file !== undefined ? request.file.path : ''
  console.log({ sentFile }) */
  /* const nombreImagen = request.body.url_imagen_e14 */
  const urlImagen = request.file !== undefined ? `${request.file.path}` : ''
  /* console.log({ urlImagen })
  console.log(request.body.url_imagen_e14)

  const file = request.file
  console.log({ file }) */

  const estado_envio_mesa = 'enviado'

  try {
    const {
      id_puestodevotacion,
      id_mesa,
      id_usuario,
      votos_incinerados,
      total_sufragantes,
      total_votos_urna,
      votos_candidato1,
      votos_candidato2,
      votos_candidato3,
      votos_candidato4,
      votos_candidato5,
      votos_candidato6,
      votos_candidato7,
      votos_candidato8,
      votos_candidato9,
      votos_blancos,
      votos_nulos,
      votos_no_marcados,
      total_votosmesa,
      observaciones,
      url_imagen_e14
    } = request.body;
    /* console.log(id_puestodevotacion,
      id_mesa,
      votos_incinerados,
      total_sufragantes,
      total_votos_urna,
      votos_candidato1,
      votos_candidato2,
      votos_candidato3,
      votos_candidato4,
      votos_candidato5,
      votos_candidato6,
      votos_candidato7,
      votos_candidato8,
      votos_candidato9,
      votos_blancos,
      votos_nulos,
      votos_no_marcados,
      total_votosmesa,
      observaciones,
      url_imagen_e14
      ) */
    await pool.query(
      'INSERT INTO mesas (id_puestodevotacion, id_mesa, id_usuario, votos_incinerados, total_sufragantes, total_votos_urna, votos_candidato1, votos_candidato2, votos_candidato3, votos_candidato4, votos_candidato5, votos_candidato6, votos_candidato7, votos_candidato8, votos_candidato9, votos_blancos, votos_nulos, votos_no_marcados, total_votosmesa, observaciones, url_imagen_e14, estado_envio_mesa) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $20, $21, $22)',
      [
        id_puestodevotacion,
        id_mesa,
        id_usuario,
        votos_incinerados,
        total_sufragantes,
        total_votos_urna,
        votos_candidato1,
        votos_candidato2,
        votos_candidato3,
        votos_candidato4,
        votos_candidato5,
        votos_candidato6,
        votos_candidato7,
        votos_candidato8,
        votos_candidato9,
        votos_blancos,
        votos_nulos,
        votos_no_marcados,
        total_votosmesa,
        observaciones,
        urlImagen,
        estado_envio_mesa
      ]
    );
    response.json(response.data).status(200);
  } catch (error) {
    response.send(error);
  }
});


mesasRouter.put(`/mesas/:id`, upload.single('url_imagen_e14'), async (request, response) => {
  /* console.log(request.body) */
  const id = Number(request.params.id)
  /* console.log(request.file) */
  /* console.log(request.file) */
  /* const sentFile = request.file !== undefined ? request.file.path : ''
  console.log({ sentFile }) */
  const { id_usuario, id_puestodevotacion, id_mesa, votos_incinerados, total_sufragantes, total_votos_urna, votos_candidato1, votos_candidato2, votos_candidato3, votos_candidato4, votos_candidato5,  votos_candidato6, votos_candidato7,  votos_candidato8, votos_candidato9, votos_blancos, votos_nulos,votos_no_marcados,  total_votosmesa, observaciones, url_imagen_e14, estado_envio_mesa } = request.body
  /* console.log({ url_imagen_e14 }) */

  
  /* const nombreImagen = request.body.url_imagen_e14 */
  const imagenAnterior = await pool.query('SELECT url_imagen_e14 FROM mesas WHERE id_puestodevotacion = $1 AND id_mesa = $2;', [id_puestodevotacion, id])
  /* console.log(imagenAnterior.rows[0]) */
  const urlImagen = request.file?.path ? request?.file.path : imagenAnterior.rows[0].url_imagen_e14
  /* console.log({ urlImagen }) */
  /* console.log({ urlImagen })
  console.log(request.body.url_imagen_e14)

  const file = request.file
  console.log({ file }) */
  const mesa = await pool.query('SELECT id_mesa FROM mesas WHERE id_puestodevotacion = $1 AND id_mesa = $2;', [id_puestodevotacion, id])
  /* console.log(mesa.rows) */
  try {
    const query = await pool.query('UPDATE mesas SET id_usuario = $1, id_puestodevotacion = $2, id_mesa = $3, votos_incinerados = $4, total_sufragantes = $5, total_votos_urna = $6, votos_candidato1 = $7, votos_candidato2 = $8, votos_candidato3 = $9, votos_candidato4 = $10, votos_candidato5 = $11,  votos_candidato6 = $12, votos_candidato7 = $13,  votos_candidato8 = $14, votos_candidato9 = $15, votos_blancos = $16, votos_nulos = $17,votos_no_marcados = $18,  total_votosmesa = $19, observaciones = $20, url_imagen_e14 = $21, estado_envio_mesa = $22  WHERE id_puestodevotacion = $2 AND id_mesa= $3;', [id_usuario, id_puestodevotacion, id_mesa, votos_incinerados, total_sufragantes, total_votos_urna, votos_candidato1, votos_candidato2, votos_candidato3, votos_candidato4, votos_candidato5,  votos_candidato6, votos_candidato7,  votos_candidato8, votos_candidato9, votos_blancos, votos_nulos,votos_no_marcados,  total_votosmesa, observaciones, urlImagen, estado_envio_mesa ])
    if (mesa.rows.length === 0) {
      return response.json({ message: 'mesa not found' })
    } else if (mesa.rows.length > 0) {
      return response.json({ message: 'mesa updated' }).status(200)
    }
  } catch (error) {
    return response.json({ error: error }).status(204)
  }
})

mesasRouter.delete(`/mesas/:id`, async (request, response) => {
  const { id } = request.params
  const mesa = await pool.query('SELECT id_mesa FROM mesas WHERE id_mesa=$1', [id])
  /* console.log(mesa.rows) */

  const query = await pool.query('DELETE FROM mesas WHERE id_mesa=$1', [id])
  response.status(204).end()
})

module.exports = mesasRouter