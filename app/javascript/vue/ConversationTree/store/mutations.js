import includes from 'lodash/includes'
import indexOf from 'lodash/indexOf'
import pick from 'lodash/pick'
import findIndex from 'lodash/findIndex'
import isEmpty from 'is-empty'

import {
  OPEN_NODE,
  CLOSE_NODE,
  ADD_QUESTION_ANSWER,
  DELETE_QUESTION_ANSWER,
  ADD_DECISION_BRANCH_TO_QUESTION_ANSWER,
  ADD_DECISION_BRANCH_TO_DECISION_BRANCH,
  CREATE_DECISION_BRANCH_OF_QUESTION_ANSWER,
  CREATE_DECISION_BRANCH_OF_DECISION_BRANCH,
  UPDATE_DECISION_BRANCH_OF_QUESTION_ANSWER,
  UPDATE_DECISION_BRANCH_OF_DECISION_BRANCH,
  DELETE_DECISION_BRANCH_OF_QUESTION_ANSWER,
  DELETE_DECISION_BRANCH_OF_DECISION_BRANCH
} from './mutationTypes'

import {
  findDecisionBranchFromTree,
  findQuestionAnswerFromTree,
  makeNewDecisionBranch,
  deleteDecisionBranch,
  addArrayItem,
  setDecisionBranch
} from '../helpers'

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
  },

  [ADD_DECISION_BRANCH_TO_QUESTION_ANSWER] (state, { questionAnswerId }) {
    const targetNode = findQuestionAnswerFromTree(state.questionsTree, questionAnswerId)
    addArrayItem(targetNode, 'decisionBranches', makeNewDecisionBranch())
  },

  [ADD_DECISION_BRANCH_TO_DECISION_BRANCH] (state, { decisionBranchId }) {
    findDecisionBranchFromTree(state.questionsTree, decisionBranchId, (targetNode) => {
      addArrayItem(targetNode, 'childDecisionBranches', makeNewDecisionBranch())
    })
  },

  [CREATE_DECISION_BRANCH_OF_QUESTION_ANSWER] (state, { questionAnswerId, newDecisionBranch }) {
    const targetNode = findQuestionAnswerFromTree(state.questionsTree, questionAnswerId)
    if (isEmpty(targetNode)) { return }
    setDecisionBranch(targetNode, 'decisionBranches', newDecisionBranch)
    state.decisionBranchesRepo[newDecisionBranch.id] = newDecisionBranch
  },

  [CREATE_DECISION_BRANCH_OF_DECISION_BRANCH] (state, { decisionBranchId, newDecisionBranch }) {
    findDecisionBranchFromTree(state.questionsTree, decisionBranchId, (targetNode) => {
      if (isEmpty(targetNode)) { return }
      setDecisionBranch(targetNode, 'childDecisionBranches', newDecisionBranch)
    })
    state.decisionBranchesRepo[newDecisionBranch.id] = newDecisionBranch
  },

  [UPDATE_DECISION_BRANCH_OF_QUESTION_ANSWER] (state, { questionAnswerId, decisionBranchId, body, answer }) {
    const targetNode = findQuestionAnswerFromTree(state.questionsTree, questionAnswerId)
    if (isEmpty(targetNode)) { return }
    setDecisionBranch(targetNode, 'decisionBranches', {
      id: decisionBranchId,
      body,
      answer
    })
  },

  [UPDATE_DECISION_BRANCH_OF_DECISION_BRANCH] (state, { parentDecisionBranchId, decisionBranchId, body, answer }) {
    findDecisionBranchFromTree(state.questionsTree, parentDecisionBranchId, (targetNode) => {
      if (isEmpty(targetNode)) { return }
      setDecisionBranch(targetNode, 'childDecisionBranches', {
        id: decisionBranchId,
        body,
        answer
      })
    })
  },

  [DELETE_DECISION_BRANCH_OF_QUESTION_ANSWER] (state, { questionAnswerId, targetDecisionBranchId }) {
    const targetNode = findQuestionAnswerFromTree(state.questionsTree, questionAnswerId)
    if (isEmpty(targetNode)) { return }
    deleteDecisionBranch(targetNode.decisionBranches, targetDecisionBranchId)
  },

  [DELETE_DECISION_BRANCH_OF_DECISION_BRANCH] (state, { decisionBranchId, targetDecisionBranchId }) {
    findDecisionBranchFromTree(state.questionsTree, decisionBranchId, (targetNode) => {
      if (isEmpty(targetNode)) { return }
      deleteDecisionBranch(targetNode.decisionBranches, targetDecisionBranchId)
    })
  }
}