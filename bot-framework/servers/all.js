const restify = require('restify')

class All {
  constructor (servers) {
    this.servers = servers
    this.app = restify.createServer()
  }

  run () {
    this.app.on('SignatureValidationFailed', (req, res, err, callback) => {
      console.error(err)
      return callback()
    })
    Object.keys(this.servers).forEach(key => {
      const s = this.servers[key]
      s.mapRoute(this.app)
    })
    this.app.listen(process.env.PORT || 3978, () => {
      console.log('%s listening to %s', this.app.name, this.app.url)
    })
  }
}

module.exports = All