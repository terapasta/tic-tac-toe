import axios from 'axios'
import * as api from './api'

import {
  ADD_MESSAGES,
  SET_MESSAGE_PAGING,
  REPLACE_MESSAGE,
  SET_IS_PROCESSING,
  SET_IS_CONNECTED,
  SET_NOTIFICATION,
} from './mutationTypes'

const headers = {
  'X-Chat-Client': 'MyOpeWebsocketChat'
}

export default {
  async initAPI ({ state }) {
    axios.defaults.baseURL = state.botServerHost
  },

  async fetchMessages ({ commit, state }, params = {}) {
    commit(SET_IS_PROCESSING, { isProcessing: true })
    const { page } = params
    const { botToken, guestKey, messagePage } = state
    try {
      const res = await api.fetchMessages({
        botToken,
        guestKey,
        page: page || messagePage,
        perPage: 20,
      }, { headers })
      const { messages, paging } = res.data
      commit(ADD_MESSAGES, { messages })
      commit(SET_MESSAGE_PAGING, { paging })
    } finally {
      commit(SET_IS_PROCESSING, { isProcessing: false })
    }
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
  },

  async saveGuestUser ({ commit, state }, { name, email }) {
    const { guestId } = state
    if (guestId == null) {
      return await api.createGuestUser({ name, email})
    } else {
      return await api.updateGuestUser({ guestId, name, email })
    }
  },
}
