import {
  ADD_MESSAGE,
} from './mutationTypes'

export const createWebsocketHandlers = (store, socket) => ({
  connect () {
    console.log('connected')
    const { botToken, guestKey } = store.state
    store.dispatch('connected')
    const roomId = `${botToken}:${guestKey}`
    socket.emit('join', { roomId })

    // DEV
    window.socket = socket
  },

  disconnect () {
    console.log('disconnected')
    store.dispatch('disconnected')
  },

  event (payload) {
    console.log('event', payload)
    switch (payload.action) {
      case 'create':
        store.commit(ADD_MESSAGE, { message: payload.data.message })
        break
      case 'rating':
        store.dispatch('applyRating', payload.data)
        break
      default:
        break
    }
  },

  error (...args) {
    console.error(args)
  },
})
