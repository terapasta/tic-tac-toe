const get = require('lodash.get')

const Base = require('./base')

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
      this.createSignatureValidator('x-line-signature', LINE_CHANNEL_SECRET),
      this.handleEvents.bind(this)
    ]
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