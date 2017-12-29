import includes from 'lodash/includes'
import indexOf from 'lodash/indexOf'
import pick from 'lodash/pick'
import findIndex from 'lodash/findIndex'

import {
  OPEN_NODE,
  CLOSE_NODE,
  ADD_QUESTION_ANSWER,
  DELETE_QUESTION_ANSWER,
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
  },

  [ADD_QUESTION_ANSWER] (state, { questionAnswer }) {
    state.questionsTree.unshift(pick(questionAnswer, ['id', 'decisionBranches']))
    state.questionsRepo[questionAnswer.id] = questionAnswer
  },

  [DELETE_QUESTION_ANSWER] (state, { id }) {
    const index = findIndex(state.questionsTree, (node) => node.id === id)
    state.questionsTree.splice(index, 1)
    delete state.questionsRepo[id]
  }
}