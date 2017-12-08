const get = require('lodash.get')
const line = require('@line/bot-sdk')

const LineBot = require('../bots/line')
const api = require('../api')
const Base = require('./base')

class LineServer extends Base {
  get name () { return 'line' }

  constructor (lineBot) {
    super([])
    this.lineBot = lineBot
    this.chatListeners = [
      this.beforeSignatureValidation.bind(this),
      this.handleEvents.bind(this)
    ]
  }

  beforeSignatureValidation (req, res, next) {
    const { botToken } = req.body
    api.fetchLineCredential({ botToken }).then(res => {
      req.lineClient = new line.Client(res.data['bot::LineCredential'])
      req.lineBot = new LineBot()
      req.lineBot.lineClient = req.lineClient

      const { channelSecret } = res.data['bot::LineCredential']
      const validator = this.createSignatureValidator('x-line-signature', channelSecret)
      validator(req, res, next)
    }).catch(console.error)
  }

  handleEvents (req, res) {
    const events = get(req, 'body.events', [])
    const botToken = get(req, 'body.botToken', null)
    const promises = events.map(event => (
      req.lineBot.handleEvent(botToken, event)
    ))
    Promise.all(promises)
      .then(result => res.json(result))
      .catch(console.error)
  }
}

module.exports = LineServer