const Base = require('./base')

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
    console.log(req.headers['x-chatworkwebhooksignature'], req.body)
    res.send('OK')
  }

  handleEvents (req, res, next) {
  }
}

module.exports = Chatwork
