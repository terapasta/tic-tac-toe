const api = require('../api')
const Base = require('./base')
const ChatworkBot = require('../bots/chatwork')

class Chatwork extends Base {
  get name () { return 'chatwork' }

  constructor () {
    super()
    this.chatListeners = [
      this.beforeSignatureValidation.bind(this),
      this.handleEvents.bind(this)
    ]
  }

  beforeSignatureValidation (req, res, next) {
    const { botToken } = req.body
    api.fetchChatworkCredential({ botToken }).then(res => {
      const credential = res.data['bot::ChatworkCredential']
      const { webhookToken, apiToken } = credential
      req.chatworkBot = new ChatworkBot(apiToken)

      const validator = this.createSignatureValidator('x-chatworkwebhooksignature', new Buffer(webhookToken, 'base64'))
      validator(req, res, next)
    }).catch(console.error)
  }

  handleEvents (req, res, next) {
    if (req.body.webhook_event_type !== 'mention_to_me') {
      return
    }
    req.chatworkBot.handleEvent(req.body)
  }
}

module.exports = Chatwork
