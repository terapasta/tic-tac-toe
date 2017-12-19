import includes from 'lodash/includes'
import bindAll from 'lodash/bindAll'
import { handleActions } from 'redux-actions'

import {
  openNode,
  closeNode,
  toggleNode,
} from '../actionCreators'

const initialState = []

const handlers = {
  open(state, action) {
    return state.concat([action.payload.nodeKey])
  },

  close(state, action) {
    return state.filter((id) => id !== action.payload.nodeKey)
  },

  toggle(state, action) {
    if (includes(state, action.payload.nodeKey)) {
      return this.close(state, action)
    } else {
      return this.open(state, action)
    }
  }
}

bindAll(handlers, ['open', 'close', 'toggle'])

export default handleActions({
  [openNode]: handlers.open,
  [closeNode]: handlers.close,
  [toggleNode]: handlers.toggle
}, initialState)
