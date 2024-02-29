const app = require('./app')
const config = require('./utils/config')
const logger = require('./utils/logger')
const { conectionDB } = require('./db/connection')
// enable https: module https and fs
const https = require('https');
const fs = require('fs');

/* const options = {
  key: fs.readFileSync('./certs/key.pem'),
  cert: fs.readFileSync('./certs/cert.pem'),
  passphrase: "310410913"
}

const server = https.createServer(options, app) */

// Without HTTPS
app.listen(config.PORT, () => {
  logger.info(`Server HTTP running on port ${ config.PORT }`)
})

/* server.listen(config.PORT, () => {
    logger.info(`Server HTTPS running on port ${ config.PORT }`)
}) */

conectionDB()