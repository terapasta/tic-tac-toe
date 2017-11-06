const path = require('path')
const dotenv = require('dotenv')
const get = require('lodash/get')
const isEmpty = require('is-empty')

const {
  ChatConnector,
} = require('botbuilder')

const Bot = require('./bot')
const Server = require('./server')

dotenv.config({ path: path.dirname(__dirname) + '/.env' })

const {
  MICROSOFT_APP_ID,
  MICROSOFT_APP_PASSWORD,
} = process.env

const connector = new ChatConnector({
  appId: MICROSOFT_APP_ID,
  appPassword: MICROSOFT_APP_PASSWORD
})

new Bot(connector)
new Server(connector).run()