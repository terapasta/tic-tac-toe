import {
  OPEN_NODE,
  CLOSE_NODE
} from './mutationTypes'

export default {
  openNode ({ commit }, { nodeId }) {
    commit(OPEN_NODE, { nodeId })
  },

  closeNode ({ commit }, { nodeId }) {
    commit(CLOSE_NODE, { nodeId })
  }
}