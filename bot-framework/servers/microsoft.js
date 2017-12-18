const {
  ChatConnector,
} = require('botbuilder')

const MicrosoftBot = require('../bots/microsoft')
const Base = require('./base')
const api = require('../api')

class Microsoft extends Base {
  get name () { return 'microsoft' }

  constructor (bot) {
    super([])
    this.bot = bot
    this.chatListeners = [
      this.handleEvent.bind(this)
    ]
  }

  handleEvent (req, res, next) {
    const { botToken } = req.body
    api.fetchMicrosoftCredential({ botToken }).then(_res => {
      const { appId, appPassword } = _res.data['bot::MicrosoftCredential']
      const connector = new ChatConnector({ appId, appPassword })
      new MicrosoftBot(connector)
      connector.listen()(req, res, next)
    }).catch(console.error)
  }
}

module.exports = Microsoft