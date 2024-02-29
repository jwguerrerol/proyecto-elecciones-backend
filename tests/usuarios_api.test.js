const { disconnectToDB, pool, conectionDB } = require('../db/connection')
const supertest = require('supertest')
const app = require('../app')
require('dotenv').config()

const api = supertest(app)

beforeEach( async () => {
  await pool.query('DELETE FROM usuarios;')
  await pool.query("INSERT INTO usuarios (id_usuario, nom_usuario, correo_usuario, clave_usuario, id_role) VALUES (1,'jhon guerrero','jhwalter1@gmail.com','colombia2023',1), (2,'armando corral','armandocorral@gmail.com','colombia2023',2),(3,'juan contador','juancontador@gmail.com','colombia2023',3);")
})

test('usuarios are returned as json', async () => {
  await api
    .get('/usuarios')
    .expect(200)
    .expect('Content-Type', /application\/json/)
})

test('there are three users', async () => {
  const response = await api.get('/usuarios')
  expect(response.body).toHaveLength(3)
})

test('add users', async () => {
  await pool.query("INSERT INTO usuarios (id_usuario, nom_usuario, correo_usuario, clave_usuario, id_role) VALUES (7,'walter de la sierra','walter de la sierra@gmail.com','colombia2023',1);")
  const response = await api.get('/usuarios')
  expect(response.body).toHaveLength(4)
})

test('delete user', async () => {
  await pool.query('DELETE FROM usuarios WHERE id_usuario = 7;')
  const response = await api.get('/usuarios')
  expect(response.body).toHaveLength(3)
})

afterAll(() => {
  disconnectToDB()
})