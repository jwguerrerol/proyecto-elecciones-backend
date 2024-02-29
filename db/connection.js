const Pool = require('pg').Pool
const Client = require('pg').Client
const config = require('../utils/config')
require('dotenv').config()

let connectionData = {}

if (process.env.NODE_ENV === 'production') {
  connectionData = {
    connectionString: process.env.POSTGRES_URL + "?sslmode=require",
  }
} else if (process.env.NODE_ENV === 'development') {
  connectionData = {
    user: config.DB_USER,
    password: config.DB_USER_PASSWORD,
    database: config.DB_DATABASE,
    host: config.DB_HOST,
    port: config.DB_PORT
  }
} else if (process.env.NODE_ENV === 'test') {
    console.log('database test')
    connectionData = {
    user: config.TEST_DB_USER,
    password: config.TEST_DB_USER_PASSWORD,
    database: config.TEST_DB_DATABASE,
    host: config.TEST_DB_HOST,
    port: config.TEST_DB_PORT
  }
}

const pool = new Pool(connectionData)

const client = new Client(connectionData)

const conectionDB = async () => {
  await client.connect()
    .then( response => (
      console.log('connected to postgresql')
    ))
    .catch( error => {
      console.log({ error })
    })
}

const disconnectToDB = async () => {
  await client.end()
    .then( response => (
      console.log('finished connection to postgresql')
    ))
    .catch( error => {
      console.log({ error })
    })
}

module.exports = {
  pool,
  client,
  conectionDB,
  disconnectToDB
}