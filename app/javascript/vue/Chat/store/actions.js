import api from '../../../../../bot-framework/api/functions'

import {
  ADD_MESSAGES,
  SET_IS_PROCESSING,
  SET_IS_CONNECTED,
  SET_NOTIFICATION,
} from './mutationTypes'

const headers = {
  'X-Chat-Client': 'MyOpeWebsocketChat'
}

export default {
  async fetchMessages ({ commit, state }) {
    const { botToken, guestKey } = state
    const res = await api.fetchMessages({
      botToken,
      guestKey,
      perPage: 10,
    }, { headers })
    commit(ADD_MESSAGES, { messages: res.data.messages })
  },

  async createMessage ({ commit, state }, { message }) {
    commit(SET_IS_PROCESSING, { isProcessing: true })
    const { botToken, guestKey } = state
    try {
      await api.createMessage({
        message,
        botToken,
        guestKey,
      }, { headers })
    } finally {
      commit(SET_IS_PROCESSING, { isProcessing: false })
    }
  },

  clearNotification ({ commit }) {
    commit(SET_NOTIFICATION, { notification: '' })
  },

  connected ({ commit }) {
    commit(SET_IS_CONNECTED, { isConnected: true })
  },

  disconnected ({ commit }) {
    commit(SET_IS_CONNECTED, { isConnected: false })
  }
}
