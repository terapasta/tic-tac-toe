import sortBy from 'lodash/sortBy'

import {
  ADD_MESSAGE,
  ADD_MESSAGES,

  SET_IS_PROCESSING,

  SET_IS_CONNECTED,

  SET_NOTIFICATION,
} from './mutationTypes'

export default {
  [ADD_MESSAGE] (state, { message }) {
    const messages = sortBy([...state.messages, message], it => (
      it.createdAt
    ))
    state.messages = messages
  },

  [ADD_MESSAGES] (state, { messages }) {
    const newMessages = sortBy([...state.messages, ...messages], it => (
      it.createdAt
    ))
    state.messages = newMessages
  },

  [SET_NOTIFICATION] (state, { notification }) {
    state.notification = notification
  },

  [SET_IS_PROCESSING] (state, { isProcessing }) {
    state.isProcessing = isProcessing
  },

  [SET_IS_CONNECTED] (state, { isConnected }) {
    state.isConnected = isConnected
  }
}
