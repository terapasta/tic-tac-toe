class Base {
  constructor (...chatListeners) {
    this.chatListeners = chatListeners
  }

  get name () {
    throw new Error('You must implement getter `name`')
  }

  mapRoute (app) {
    app.get(`/${this.name}/healthcheck`, (req, res) => res.send('OK'))

    app.post(`/${this.name}/:botToken`,
      this.reqBodyMiddleware.bind(this),
      ...this.chatListeners
    )
  }

  reqBodyMiddleware (req, res, next) {
    if (req.body) {
      this.passToChatListener(req, res, next)
    } else {
      let requestData = ''
      req.on('data', (chunk) => requestData += chunk)
      req.on('end', () => {
        req.body = requestData
        this.passToChatListener(req, res, next);
      })
    }
  }

  passToChatListener (req, res, next) {
    req.body = Object.assign(JSON.parse(req.body), {
      botToken: req.params.botToken
    })
    next(req, res)
  }
}

module.exports = Base