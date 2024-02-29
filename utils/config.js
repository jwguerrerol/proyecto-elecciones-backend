require('dotenv').config()

const PORT = process.env.PORT || 443
const DB_USER = process.env.DB_USER
const DB_USER_PASSWORD = process.env.DB_USER_PASSWORD
const DB_DATABASE = process.env.DB_DATABASE
const DB_HOST = process.env.DB_HOST
const DB_PORT = process.env.DB_PORT
const TEST_PORT = process.env.TEST_PORT || 4000
const TEST_DB_USER = process.env.TEST_DB_USER
const TEST_DB_USER_PASSWORD = process.env.TEST_DB_USER_PASSWORD
const TEST_DB_DATABASE = process.env.TEST_DB_DATABASE
const TEST_DB_HOST = process.env.TEST_DB_HOST
const TEST_DB_PORT = process.env.TEST_DB_PORT

module.exports = {
  PORT,
  DB_USER,
  DB_USER_PASSWORD,
  DB_DATABASE,
  DB_HOST,
  DB_PORT,
  TEST_PORT,
  TEST_DB_USER,
  TEST_DB_USER_PASSWORD,
  TEST_DB_DATABASE,
  TEST_DB_HOST,
  TEST_DB_PORT

}