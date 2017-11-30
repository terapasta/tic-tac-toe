const isPlainObject = require('lodash.isplainobject')
const get = require('lodash.get')

const Base = require('./base')
const lineValidateSignature = require('@line/bot-sdk/dist/validate-signature').default

const {
  LINE_CHANNEL_SECRET,
} = require('../env')

class LineServer extends Base {
  get name () { return 'line' }

  constructor (lineClient, lineBot) {
    super([])
    this.lineClient = lineClient
    this.lineBot = lineBot
    this.chatListeners = [
      this.signatureValidator.bind(this),
      this.handleEvents.bind(this)
    ]
  }

  signatureValidator (req, res, next) {
    const { body } = req
    let strBody = Buffer.isBuffer(body) ? body.toString() : body
    let parsedBody = strBody
    if (isPlainObject(strBody)) {
      strBody = JSON.stringify(strBody)
    } else {
      parsedBody = JSON.parse(strBody)
    }
    delete parsedBody.botToken
    const sanitizedBody = JSON.stringify(parsedBody)
    const isValidSignature = lineValidateSignature(
      sanitizedBody, LINE_CHANNEL_SECRET, req.headers['x-line-signature'])

    if (!isValidSignature) {
      return next(new Error('invalid x-line-signature'))
    }
    req.body = JSON.parse(strBody)
    next(req, res)
  }

  handleEvents (req, res) {
    const events = get(req, 'body.events', [])
    const botToken = get(req, 'body.botToken', null)
    const promises = events.map(event => (
      this.lineBot.handleEvent(botToken, event)
    ))
    Promise.all(promises)
      .then(result => res.json(result))
      .catch(console.error)
  }
}

module.exports = LineServer