import includes from 'lodash/includes'
import indexOf from 'lodash/indexOf'

import {
  OPEN_NODE,
  CLOSE_NODE
} from './mutationTypes'

export default {
  [OPEN_NODE] (state, { nodeId }) {
    if (includes(state.openedNodes, nodeId)) { return }
    state.openedNodes.push(nodeId)
  },

  [CLOSE_NODE] (state, { nodeId }) {
    const index = indexOf(state.openedNodes, nodeId)
    if (index === -1) { return }
    state.openedNodes.splice(index, 1)
  }
}