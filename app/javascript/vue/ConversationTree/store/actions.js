import Promise from 'promise'
import isEmpty from 'is-empty'
import toastr from 'toastr'

import * as QuestionAnswerAPI from '../../../api/questionAnswer'
import * as DecisionBranchAPI from '../../../api/decisionBranch'

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

const logError = err => {
  console.log(err)
  return Promise.reject(err)
}

export default {
  openNode ({ commit }, { nodeId }) {
    commit(OPEN_NODE, { nodeId })
  },

  closeNode ({ commit }, { nodeId }) {
    commit(CLOSE_NODE, { nodeId })
  },

  createQuestionAnswer ({ commit, state }, { question, answer }) {
    const { botId } = state
    return QuestionAnswerAPI.create(botId, question, answer)
      .then(res => {
        const { questionAnswer } = res.data
        commit(ADD_QUESTION_ANSWER, { questionAnswer })
        return questionAnswer
      })
      .catch(logError)
  },

  updateQuestionAnswer ({ commit, state }, { id, question, answer }) {
    const { botId } = state
    return QuestionAnswerAPI.update(botId, id, question, answer)
      .then(res => res.data.questionAnswer)
      .catch(logError)
  },

  deleteQuestionAnswer ({ commit, state }, { id }) {
    const { botId } = state
    return QuestionAnswerAPI.destroy(botId, id)
      .then(() => commit(DELETE_QUESTION_ANSWER, { id }))
      .catch(logError)
  },

  addDecisionBranch ({ commit }, { questionAnswerId, decisionBranchId }) {
    if (!isEmpty(questionAnswerId)) {
      commit(ADD_DECISION_BRANCH_TO_QUESTION_ANSWER, { questionAnswerId })
    } else if (!isEmpty(decisionBranchId)) {
      commit(ADD_DECISION_BRANCH_TO_DECISION_BRANCH, { decisionBranchId })
    }
  },

  createDecisionBranch ({ commit, state }, { questionAnswerId, decisionBranchId, body }) {
    const { botId } = state
    if (!isEmpty(questionAnswerId)) {
      return DecisionBranchAPI.create(botId, questionAnswerId, body)
        .then(res => {
          commit(CREATE_DECISION_BRANCH_OF_QUESTION_ANSWER, {
            questionAnswerId,
            newDecisionBranch: res.data.decisionBranch
          })
        }).catch(logError)
    } else if (!isEmpty(decisionBranchId)) {
      return DecisionBranchAPI.nestedCreate(botId, decisionBranchId, body)
        .then(res => {
          commit(CREATE_DECISION_BRANCH_OF_DECISION_BRANCH, {
            decisionBranchId,
            newDecisionBranch: res.data.decisionBranch
          })
        }).catch(logError)
    }
  },

  updateDecisionBranch ({ commit, state }, {
    questionAnswerId,
    decisionBranchId,
    body,
    answer
  }) {
    const { botId } = state
    if (!isEmpty(questionAnswerId)) {
      return DecisionBranchAPI.update(botId, questionAnswerId, decisionBranchId, body, answer)
        .then(res => {
          commit(UPDATE_DECISION_BRANCH_OF_QUESTION_ANSWER, {
            questionAnswerId, decisionBranchId, body, answer
          })
        }).catch(logError)
    } else if (!isEmpty(decisionBranchId)) {
      return DecisionBranchAPI.nestedUpdate(botId, decisionBranchId, body, answer)
        .then((res) => {
          commit(UPDATE_DECISION_BRANCH_OF_DECISION_BRANCH, {
            decisionBranchId, body, answer
          })
        }).catch(logError)
    }
  },

  deleteDecisionBranch ({ commit, state }, { questionAnswerId, decisionBranchId, targetDecisionBranchId }) {
    const { botId } = state
    if (!isEmpty(questionAnswerId)) {
      return DecisionBranchAPI.destroy(botId, questionAnswerId, targetDecisionBranchId)
        .then(res => {
          commit(DELETE_DECISION_BRANCH_OF_QUESTION_ANSWER, {
            questionAnswerId, targetDecisionBranchId
          })
        }).catch(logError)
    } else if (!isEmpty(decisionBranchId)) {
      return DecisionBranchAPI.nestedDelete(botId, decisionBranchId)
        .then(res => {
          commit(DELETE_DECISION_BRANCH_OF_DECISION_BRANCH, {
            decisionBranchId, targetDecisionBranchId
          })
        }).catch(logError)
    }
  }
}