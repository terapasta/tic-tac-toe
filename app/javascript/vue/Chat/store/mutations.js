import sortBy from 'lodash/sortBy'
import findIndex from 'lodash/findIndex'
import isEmpty from 'is-empty'

import {
  ADD_MESSAGE,
  ADD_MESSAGES,
  REPLACE_MESSAGE,

  SET_MESSAGE_PAGING,
  SET_MESSAGES_NEXT_PAGE_EXISTS,

  SET_IS_PROCESSING,

  SET_IS_CONNECTED,

  SET_NOTIFICATION,

  REPLACE_INITIAL_SELECTIONS,
  SET_GUEST_ID,
} from './mutationTypes'

export default {
  [ADD_MESSAGE] (state, { message }) {
    const messages = sortBy([...state.messages, message], it => (
      it.createdAt
    ))
    state.messages = messages
  },

  [ADD_MESSAGES] (state, { messages }) {
    const newMessages = sortBy([...messages, ...state.messages], it => (
      it.createdAt
    ))
    state.messages = newMessages
  },

  [REPLACE_MESSAGE] (state, { message }) {
    const index = findIndex(state.messages, it => it.id === message.id)
    state.messages = [
      ...state.messages.slice(0, index),
      message,
      ...state.messages.slice(index + 1),
    ]
  },

  [SET_NOTIFICATION] (state, { notification }) {
    state.notification = notification
  },

  [SET_IS_PROCESSING] (state, { isProcessing }) {
    state.isProcessing = isProcessing
  },

  [SET_IS_CONNECTED] (state, { isConnected }) {
    state.isConnected = isConnected
  },

  [SET_MESSAGES_NEXT_PAGE_EXISTS] (state, { nextPageExists }) {
    state.messagesNextPageExists = nextPageExists
  },

  [REPLACE_INITIAL_SELECTIONS] (state, { initialSelections }) {
    console.log(initialSelections)
    const firstMessage = state.messages[0]
    if (firstMessage == null || isEmpty(firstMessage.initialSelections)) { return }
    const newFirstMessage = {
      ...firstMessage,
      initialSelections,
    }
    state.messages = [
      newFirstMessage,
      ...state.messages.slice(1),
    ]
  },

  [SET_GUEST_ID] (state, { guestId }) {
    state.guestId = guestId
  },
}
