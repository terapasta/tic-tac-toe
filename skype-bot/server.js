const restify = require('restify')

class Server {
  constructor (connector) {
    this.connector = connector
    this.chatListener = connector.listen()
    this.server = restify.createServer()
  }

  run () {
    this.server.get('/healthcheck', (req, res) => {
      res.send('OK')
    })
    this.server.post('/:botToken', (req, res) => {
      if (req.body) {
        this.passToChatListener(req, res)
      } else {
        let requestData = ''
        req.on('data', (chunk) => requestData += chunk)
        req.on('end', () => {
          req.body = requestData
          this.passToChatListener(req, res);
        })
      }
    })
    this.server.listen(process.env.PORT || 3978, () => {
      console.log('%s listening to %s', this.server.name, this.server.url)
    })
  }

  passToChatListener (req, res) {
    req.body = Object.assign(JSON.parse(req.body), {
      botToken: req.params.botToken
    })
    this.chatListener(req, res)
  }


}

module.exports = Server