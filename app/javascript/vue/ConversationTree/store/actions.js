import Promise from 'promise'

import * as QuestionAnswerAPI from '../../../api/questionAnswer'

import {
  OPEN_NODE,
  CLOSE_NODE,
  ADD_QUESTION_ANSWER,
  DELETE_QUESTION_ANSWER,
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
  }
}