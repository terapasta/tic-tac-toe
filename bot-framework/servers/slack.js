var builder = require('botbuilder');

const SlackBot = require('../bots/microsoft')
const Base = require('./base')
const api = require('../api')
const {
  MicrosoftAppId,
  MicrosoftAppPassword,
} = require('../env')

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
    const connector = new builder.ChatConnector({
      appId: MicrosoftAppId,
      appPassword: MicrosoftAppPassword,
    })
    new SlackBot(connector)
    connector.listen()(req, res, next)
  }
}

module.exports = Slack