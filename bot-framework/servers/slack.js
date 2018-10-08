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
    // NOTE:
    // Azure上の App Service で環境変数を指定できるので、API に問い合わせる必要がない
    // そもそも Bot Service上にデプロイされたボットが通信するためには
    // MicrosoftAppId と MicrosoftAppPassword が必要なので、
    // APIサーバーに問い合わせるというシステム設計だと動かない気がする？
    // （そんなに真面目に検討していないので、必要なら再検討）
    const connector = new builder.ChatConnector({
      appId: MicrosoftAppId,
      appPassword: MicrosoftAppPassword,
    })
    new SlackBot(connector)
    connector.listen()(req, res, next)
  }
}

module.exports = Slack