const {
  ChatConnector,
} = require('botbuilder')

const SlackBot = require('../bots/slack')
const Base = require('./base')
const api = require('../api')

class Slack extends Base {
  get name () { return 'slack' }

  constructor (bot) {
    super([])
    this.bot = bot
    this.chatListeners = [
      this.handleEvent.bind(this)
    ]
  }

  handleEvent (req, res, next) {
    const { botToken } = req.body
    api.fetchSlackCredential({ botToken }).then(_res => {
      const { microsoftAppId, microsoftAppPassword } = _res.data['bot::SlackCredential']
      const connector = new ChatConnector({ microsoftAppId, microsoftAppPassword })
      new SlackBot(connector)
      connector.listen()(req, res, next)
    }).catch(console.error)
  }
}

module.exports = Slack