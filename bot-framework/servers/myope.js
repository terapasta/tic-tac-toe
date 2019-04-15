class MyOpeServer {
  mapRoute (app) {
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

    app.get('/myope/:botToken/messages', (req, res) => {
      res.send('OK')
    })
  }

  wsEmit ({ botToken, guestKey, payload }) {
    const roomId = `${botToken}:${guestKey}`
    this.io.sockets.in(roomId).emit('event', payload)
  }
}

module.exports = MyOpeServer
