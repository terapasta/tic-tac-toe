import assign from 'lodash/assign'
import { handleActions } from 'redux-actions'

import {
  changeMessageBody,
  clearMessageBody,
  disableForm,
  enableForm,
} from '../ActionCreators'

export default handleActions({
  [changeMessageBody]: (state, action) => {
    if (action.error) {
      return state
    }

    const { messageBody } = action.payload

    return assign({}, state, {
      messageBody,
    })
  },

  [clearMessageBody]: (state, action) => {
    return assign({}, state, { messageBody: "" })
  },

  [disableForm]: (state, action) => {
    return assign({}, state, { isDisabled: true })
  },

  [enableForm]: (state, action) => {
    return assign({}, state, { isDisabled: false })
  },
}, {
  messageBody: '',
  isDisabled: false,
})
