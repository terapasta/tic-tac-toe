const Base = require('./base')

class Chatwork extends Base {
  get name () { return 'chatwork' }

  constructor () {
    super()
    this.chatListeners = [
      this.signatureValidator.bind(this),
      this.handleEvents.bind(this)
    ]
  }

  signatureValidator (req, res, next) {
    console.log(req.headers['x-chatworkwebhooksignature'], req.body)
    res.status(200).send('OK')
  }

  handleEvents (req, res, next) {
  }
}

module.exports = Chatwork
