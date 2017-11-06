const restify = require('restify')

const {
  port
} = process.env

class Server {
  constructor (connector) {
    this.connector = connector
    this.chatListener = connector.listen()
    this.server = restify.createServer()
  }

  run () {
    const { listen, name, url } = this.server
    listen(port || 3978, () => {
      console.log('%s listening to %s', name, url)
    })
  }

  passToChatListener (req, res) {
    req.body = Object.assign(JSON.parse(req.body), {
      botToken: req.params.botToken
    })
    this.chatListener(req, res)
  }
}

export default Server