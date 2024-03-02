const { pool } = require('../db/connection')
const registerRouter = require('express').Router()
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

registerRouter.put( '/register', upload.single('url_imagen'), async (request, response) => {

  let urlImagen = request.file !== undefined ? `${request.file.path}` : '/images/user-icon.png'
  console.log({ urlImagen })
  console.log('here top')

  const dateFormCompare = new Date('1970-01-01T00:00:00.000Z')

  try {
    const verifyCreatedUserAdminInitial = await pool.query("SELECT * FROM usuarios WHERE updateAt = $1", [dateFormCompare])
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
    await pool.query('UPDATE usuarios SET nom_usuario = $1, clave_usuario = $2, id_role = $3, id_puestodevotacion = $4, url_imagen = $5, updateAt = $6 WHERE id_usuario = 1', [nom_usuario, passwordHash, id_role, id_puestodevotacion, urlImagen, new Date()])
    return response.status(200).json(request.body)
  } catch (error) {
    return response.send(error.message)
  }
})

module.exports = registerRouter