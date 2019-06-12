import axios from 'axios'
import * as api from './api'

import {
  ADD_MESSAGES,
  REPLACE_MESSAGE,
  SET_IS_PROCESSING,
  SET_IS_CONNECTED,
  SET_NOTIFICATION,
  SET_MESSAGES_NEXT_PAGE_EXISTS,
} from './mutationTypes'

export default {
  async initAPI ({ state }) {
    axios.defaults.baseURL = state.botServerHost
  },

  async fetchMessages ({ commit, state }, params = {}) {
    commit(SET_IS_PROCESSING, { isProcessing: true })
    const { olderThanId } = params
    const { botToken, guestKey } = state
    try {
      const res = await api.fetchMessages({
        botToken,
        guestKey,
        olderThanId: olderThanId || 0,
        perPage: 20,
      })
      const { messages, nextPageExists } = res.data
      commit(ADD_MESSAGES, { messages })
      commit(SET_MESSAGES_NEXT_PAGE_EXISTS, { nextPageExists })
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
      })
    } catch (err) {
      console.error(err)
      // TODO handle error
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
      })
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
    })
  },

  async bad ({ state }, { message }) {
    const { botToken, guestKey } = state
    await api.createRating({
      botToken,
      guestKey,
      messageId: message.id,
      ratingLevel: 'bad',
    })
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

  async moveInitialSelectionHigher ({ commit, state }, { selection }) {
    const { botToken, guestKey } = state
    return api.moveInitialSelectionHigher({ botToken, guestKey, initialSelectionId: selection.id })
  },

  async moveInitialSelectionLower ({ commit, state }, { selection }) {
    const { botToken, guestKey } = state
    return api.moveInitialSelectionLower({ botToken, guestKey, initialSelectionId: selection.id })
  },

  async fetchInitialSelections ({ commit, state }) {
    const { botToken } = state
    const res = await api.fetchInitialSelections({ botToken })
    console.log(res)
  },
}
