const api = require('../api')

class MyOpeServer {
  mapRoute (app) {
    const requestHeaders = {
      'X-Chat-Client': 'MyOpeChat'
    }

    app.get('/myope/healthcheck', (req, res) => {
      try {
        res.send('OK!!')
        const botToken = '1f55f962003c93205fd8d3648d3117c8b0b92280b0e145a2191659d33037d8d4'
        const guestKey = 'bf3992bdddd00452669480d2e267f5745aea503fcb26dec225ea049ff563df4fdaef5e23111123da785a283853735976240162d0cd51a4d9f0065240a2f5134a'
        this.wsEmit({
          botToken,
          guestKey,
          payload: { action: 'test', message: 'test' }
        })
      } catch (err) {
        console.error(err)
      }
    })

    app.get('/myope/:botToken/messages', async (req, res) => {
      const {
        olderThanId = 0,
        perPage = 20,
        botToken,
        guestKey,
      } = { ...req.params, ...req.query }
      const response = await api.fetchMessages({
        botToken,
        guestKey,
        olderThanId,
        perPage,
      })
      const {
        'x-next-page-exists': nextPageExists,
      } = response.headers
      const { messages } = response.data
      res.send({
        messages,
        nextPageExists: nextPageExists === 'true'
      })
    })

    app.post('/myope/:botToken/messages', async (req, res) => {
      try {
        const {
          botToken,
          guestKey,
          message
        } = { ...req.params, ...req.body }
        const response = await api.createMessage(
          { botToken, guestKey, message },
          { headers: requestHeaders }
        )
        response.data.messages.forEach(message => {
          const payload = { action: 'create', data: { message } }
          this.wsEmit({ botToken, guestKey, payload })
        })
        res.send('OK')
      } catch (err) {
        const { response } = err
        if (response) {
          res.status(response.status)
          res.send(response.statusText)
        } else {
          res.status(500)
          res.send('Something went wrong')
        }
      }
    })

    app.post('/myope/:botToken/choices', (req, res) => {
      res.send('OK')
    })

    app.post('/myope/:botToken/messages/:messageId/rating', (req, res) => {
      res.send('OK')
    })

    app.post('/myope/guest_users', (req, res) => {
      console.log(req)
      res.send('test')
    })

    app.put('/myope/guest_users', (req, res) => {
      res.send('OK')
    })
  }

  wsEmit ({ botToken, guestKey, payload }) {
    const roomId = `${botToken}:${guestKey}`
    this.io.sockets.in(roomId).emit('event', payload)
  }
}

module.exports = MyOpeServer
