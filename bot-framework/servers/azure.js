const connector = require('../bots/azure')
const Base = require('./base')

class Azure extends Base {
  get name () { return 'azure' }

  constructor (bot) {
    super([])
    this.bot = bot
    this.chatListeners = [
      this.handleEvent.bind(this)
    ]
  }

  handleEvent (req, res, next) {
    connector.listen()(req, res, next)
  }
}

module.exports = Azure