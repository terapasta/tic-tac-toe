require('console-stamp')(console, 'yyyy-mm-dd HH:MM:ss.l')
const restify = require('restify')
const socketio = require('socket.io')
const corsMiddleware = require('restify-cors-middleware')

const cors = corsMiddleware({
  origins: [
    'http://localhost:3000',
    'https://app.my-ope.net',
    'https://stage.my-ope.net',
  ],
  allowHeaders: ['*']
})

class All {
  constructor (servers) {
    this.servers = servers
    this.app = restify.createServer()
    this.app.use(restify.plugins.bodyParser({ mapParams: false }))
    this.app.use(restify.plugins.queryParser())
    this.app.pre(cors.preflight)
    this.app.use(cors.actual)
    this.io = socketio.listen(this.app.server)
  }

  run () {
    this.io.on('connection', (socket) => {
      console.log('connected')

      socket.on('join', (data) => {
        console.log('join', data)
        socket.join(data.roomId)
      })

      socket.on('disconnect', () => {
        console.log('disconnected')
      })

      socket.on('error', () => {
        console.log('error')
      })

      Object.keys(this.servers).forEach(key => {
        this.servers[key].socket = socket
        this.servers[key].io = this.io
      })
    })

    this.app.on('SignatureValidationFailed', (req, res, err, callback) => {
      console.error(err)
      return callback()
    })

    Object.keys(this.servers).forEach(key => {
      const s = this.servers[key]
      s.mapRoute(this.app)
    })
    this.app.listen(3978, () => {
      console.log('%s listening to %s', this.app.name, this.app.url)
    })
  }
}

module.exports = All