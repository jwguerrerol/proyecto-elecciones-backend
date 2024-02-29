const { pool } = require('../db/connection')
const usuariosRouter = require('express').Router()
const bcrypt = require('bcrypt')
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
    folder: 'users', // Carpeta en Cloudinary donde se almacenarán las imágenes
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

usuariosRouter.get( '/usuarios', async (request, response) => {
  try {
    const result = await pool.query('SELECT * FROM usuarios ORDER BY id_usuario ASC;')
    const usuarios = result.rows
    response.json(usuarios).status(200)
  } catch (error) {
    response.send({ error }).status(500)
  }
})

usuariosRouter.get( `/usuarios/:id`, async (request, response) => {
  const { id } = request.params
  const result = await pool.query(`SELECT usuarios.id_usuario id_usuario, usuarios.nom_usuario nom_usuario, usuarios.correo_usuario  correo_usuario, usuarios.clave_usuario clave_usuario, usuarios.id_role id_role, roles.nom_role nom_role, usuarios.id_puestodevotacion id_puestodevotacion, puestosdevotacion.nom_puestodevotacion nom_puestodevotacion, usuarios.url_imagen url_imagen FROM usuarios JOIN roles ON roles.id_role = usuarios.id_role JOIN puestosdevotacion ON usuarios.id_puestodevotacion = puestosdevotacion.id_Puestodevotacion  WHERE usuarios.id_usuario = ${ id }`)
  /* console.log(result.rows) */
  const usuario = result.rows
  response.json(usuario)
})

usuariosRouter.put( '/register', upload.single('url_imagen'), async (request, response) => {

  let urlImagen = request.file !== undefined ? `${request.file.path}` : '/images/user-icon.png'
  console.log({ urlImagen })
  console.log('here top')

  try {
    const verifyCreatedUserAdminInitial = await pool.query("SELECT * FROM usuarios WHERE updateAt = '1969-12-31 19:00:00'")
    console.log('here')
    console.log({ rows : verifyCreatedUserAdminInitial.rowCount})
    if(verifyCreatedUserAdminInitial.rowCount === 0 ) {
      console.log('top')
      return response.status(401).json({
        message: 'Usuario administrador ya fue generado'
      })
    }
  } catch (error) {
    return response.status(500)
  }
 
  /* const file = request.file */
  const { nom_usuario, clave_usuario, correo_usuario } = request.body
  const id_puestodevotacion = 1
  const id_role = 1
  const id_usuario = 4

  console.log( nom_usuario, clave_usuario, correo_usuario, id_puestodevotacion, id_role, urlImagen )
  console.log('bottom')

  try {
    const saltRounds = 10;
    const passwordHash = await bcrypt.hash(clave_usuario, saltRounds);
    // update usuario admin
    await pool.query('UPDATE usuarios SET nom_usuario = $1, clave_usuario = $2, id_role = $3, id_puestodevotacion = $4, url_imagen = $5, updateAt = $6', [nom_usuario, passwordHash, id_role, id_puestodevotacion, urlImagen, new Date()])
    return response.status(200).json(request.body)
  } catch (error) {
    return response.send(error.message)
  }
})

usuariosRouter.post( '/usuarios', upload.single('url_imagen'), async (request, response) => {
  /* console.log(request.body) */
  /* const sentFile = request.file !== undefined ? request.file.path : '' */
  let urlImagen = request.file !== undefined ? `${request.file.path}` : '/images/user-icon.png'
 
  /* const file = request.file */
  const { id_usuario, nom_usuario, clave_usuario, correo_usuario, id_role, id_puestodevotacion, url_imagen } = request.body
  const usuario = await pool.query('SELECT id_usuario FROM usuarios WHERE id_usuario = $1;', [id_usuario])
  /* urlImagen = (urlImagen === undefined || urlImagen === '' || urlImagen === null) ? '' : urlImagen */
  try {
    const {id_usuario, nom_usuario, correo_usuario, clave_usuario, id_role, id_puestodevotacion, url_imagen} = request.body
    const saltRounds = 10;
    const passwordHash = await bcrypt.hash(clave_usuario, saltRounds);
    await pool.query('INSERT INTO usuarios (id_usuario, nom_usuario, correo_usuario, clave_usuario, id_role, id_puestodevotacion, url_imagen) VALUES  ($1, $2, $3, $4, $5, $6, $7)', [id_usuario, nom_usuario, correo_usuario, passwordHash, id_role, id_puestodevotacion, urlImagen])
    response.status(200).json(request.body)
  } catch (error) {
    response.send(error)
  }
})

usuariosRouter.put( `/usuarios/:id`, upload.single('url_imagen'), async (request, response) => {
  /* console.log(request.body)
  console.log(request.file) */
  /* const sentFile = request.file !== undefined ? request.file.path : '' */
  /* console.log({ sentFile }) */
  let urlImagen = request.file !== undefined ? `${request.file.path}` : ''
  /* console.log({ urlImagen }) */
 
  /* const file = request.file */
  /* console.log({ file }) */
  const id = Number(request.params.id)
  const { nom_usuario, clave_usuario, correo_usuario, id_role, id_puestodevotacion, url_imagen } = request.body
  const usuario = await pool.query('SELECT id_usuario FROM usuarios WHERE id_usuario = $1;', [id])
  const imagenAnteriorTemp = await pool.query('SELECT url_imagen FROM usuarios WHERE id_usuario = $1;', [id])
  const imagenAnterior = imagenAnteriorTemp.rows[0].url_imagen
  /* console.log({ imagenAnterior}) */
  /* urlImagen = (urlImagen === undefined || urlImagen === '' || urlImagen === null) ? imagenAnterior : urlImagen  */
  /* console.log(usuario.rows) */
  const saltRounds = 10;
  const passwordHash = await bcrypt.hash(clave_usuario, saltRounds);
  try {
    const query = await pool.query('UPDATE usuarios SET nom_usuario = $1, clave_usuario = $2, correo_usuario = $3, id_puestodevotacion = $4, id_role = $5, url_imagen = $6 WHERE id_usuario= $7;', [nom_usuario, passwordHash, correo_usuario, id_puestodevotacion, id_role, urlImagen, id])
    if (usuario.rows.length === 0){
      return response.json({ message: 'user not found'})
    }
    return response.status(200).end()
  } catch (error) {
    return response.json(error).status(204)
  }
})

usuariosRouter.delete( `/usuarios/:id`, async (request, response) => {
  const { id } = request.params
  const query = await pool.query('DELETE FROM usuarios WHERE id_usuario=$1',[id])
  response.status(204).end()
})

module.exports = usuariosRouter