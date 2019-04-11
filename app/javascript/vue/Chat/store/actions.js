import api from '../../../../../bot-framework/api/functions'

import {
  ADD_MESSAGES,
  REPLACE_MESSAGE,
  SET_IS_PROCESSING,
  SET_IS_CONNECTED,
  SET_NOTIFICATION,
} from './mutationTypes'

const headers = {
  'X-Chat-Client': 'MyOpeWebsocketChat'
}

export default {
  async fetchMessages ({ commit, state }) {
    const { botToken, guestKey, messagePage } = state
    const res = await api.fetchMessages({
      botToken,
      guestKey,
      page: messagePage,
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

  async selectDecisionBranch ({ commit, state }, { decisionBranch }) {
    commit(SET_IS_PROCESSING, { isProcessing: true })
    const { botToken, guestKey } = state
    try {
      await api.createChoice({
        botToken,
        guestKey,
        choiceId: decisionBranch.id,
      }, { headers })
    } finally {
      commit(SET_IS_PROCESSING, { isProcessing: false })
    }
  },

  async good ({ state }, { message }) {
    const { botToken, guestKey } = state
    await api.createRating({
      botToken,
      guestKey,
      messageId: message.id,
      ratingLevel: 'good',
    }, { headers })
  },

  async bad ({ state }, { message }) {
    const { botToken, guestKey } = state
    await api.createRating({
      botToken,
      guestKey,
      messageId: message.id,
      ratingLevel: 'bad',
    }, { headers })
  },

  clearNotification ({ commit }) {
    commit(SET_NOTIFICATION, { notification: '' })
  },

  connected ({ commit }) {
    commit(SET_IS_CONNECTED, { isConnected: true })
  },

  disconnected ({ commit }) {
    commit(SET_IS_CONNECTED, { isConnected: false })
  },

  applyRating ({ commit, state }, { rating }) {
    const message = state.messages.find(it => it.id === rating.messageId)
    message.rating = rating.level
    commit(REPLACE_MESSAGE, { message })
  }
}
