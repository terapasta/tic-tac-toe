import {
  ADD_MESSAGE,
} from './mutationTypes'

export const createWebsocketHandlers = store => ({
  connected () {
    store.dispatch('connected')
  },

  disconnected () {
    store.dispatch('disconnected')
  },

  rejected () {
    store.dispatch('disconnected')
  },

  received (payload) {
    switch (payload.action) {
      case 'create':
        store.commit(ADD_MESSAGE, { message: payload.data.message })
        break
      default:
        break
    }
  },

  bindError (channel) {
    channel.consumer.connection.webSocket.onerror = err => {
      console.log('an error occurred')
    }
  },
})
