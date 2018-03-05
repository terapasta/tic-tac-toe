import Promise from 'promise'
import isEmpty from 'is-empty'
import { find, includes, uniq, flatten } from 'lodash'

import * as QuestionAnswerAPI from '../../../api/questionAnswer'
import * as DecisionBranchAPI from '../../../api/decisionBranch'
import * as AnswerLinkAPI from '../../../api/answerLink'
import * as SubQuestionAPI from '../../../api/subQuestion'

import {
  OPEN_NODE,
  CLOSE_NODE,
  ADD_QUESTION_ANSWER,
  DELETE_QUESTION_ANSWER,
  DELETE_ANSWER,
  ADD_DECISION_BRANCH_TO_QUESTION_ANSWER,
  ADD_DECISION_BRANCH_TO_DECISION_BRANCH,
  CREATE_DECISION_BRANCH_OF_QUESTION_ANSWER,
  CREATE_DECISION_BRANCH_OF_DECISION_BRANCH,
  UPDATE_DECISION_BRANCH_OF_QUESTION_ANSWER,
  UPDATE_DECISION_BRANCH_OF_DECISION_BRANCH,
  DELETE_DECISION_BRANCH,
  DELETE_ANSWER_OF_DECISION_BRANCH,
  SET_ANSWER_LINK,
  UNSET_ANSWER_LINK,
  ADD_SUB_QUESTION,
  UPDATE_SUB_QUESTION,
  DELETE_SUB_QUESTION,
  SET_FILTERED_QUESTIONS_TREE,
  SET_FILTERED_QUESTIONS_SELECTABLE_TREE,
  SET_SEARCHING_KEYWORD,
  SET_SELECTABLE_TREE_SEARCHING_KEYWORD,
  ADD_SEARCH_INDEX,
  TOGGLE_IS_ONLY_SHOW_HAS_DECISION_BRANCHES_NODE,
  MOVE_DECISION_BRANCH_TO_HIGHER_POSITION,
  MOVE_DECISION_BRANCH_TO_LOWER_POSITION
} from './mutationTypes'

import {
  findQuestionAnswerFromTree,
  findDecisionBranchFromTree,
  getFlatTreeFromDecisionBranchId,
  makeNodeIdsFromNode
} from '../helpers';

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
        const nodeId = `Question-${questionAnswer.id}`
        if (!isEmpty(questionAnswer.answer)) {
          const _nodeIds = [nodeId].concat([`Answer-${questionAnswer.id}`])
          commit(ADD_SEARCH_INDEX, { indexItem: { relatedNodeIds: _nodeIds, text: questionAnswer.answer } })
        }
        commit(ADD_SEARCH_INDEX, { indexItem: { relatedNodeIds: [nodeId], text: questionAnswer.question } })
        commit(ADD_QUESTION_ANSWER, { questionAnswer })
        commit(OPEN_NODE, { nodeId: nodeId })
        return questionAnswer
      })
      .catch(logError)
  },

  updateQuestionAnswer ({ commit, state }, { id, question, answer }) {
    const { botId } = state
    let promises = []
    promises.push(QuestionAnswerAPI.update(botId, id, question, answer))

    if (isEmpty(answer)) {
      const node = find(state.questionsTree, (node) => node.id === id)
      node.decisionBranches.forEach(db => {

        promises.push(DecisionBranchAPI.nestedDelete(botId, db.id))
      })
    }

    return Promise.all(promises)
      .then((ress) => {
        if (isEmpty(answer)) {
          commit(DELETE_ANSWER, { questionAnswerId: id })
        }
        return ress[0].data.questionAnswer
      })
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
          const { decisionBranch } = res.data
          commit(CREATE_DECISION_BRANCH_OF_QUESTION_ANSWER, {
            questionAnswerId,
            newDecisionBranch: decisionBranch
          })
          const targetNode = findQuestionAnswerFromTree(state.questionsTree, questionAnswerId)
          const relatedNodeIds = [
            `Question-${targetNode.id}`,
            `Answer-${targetNode.id}`,
            `DecisionBranch-${decisionBranch.id}`
          ]
          commit(ADD_SEARCH_INDEX, { indexItem: { relatedNodeIds, text: body } })
        }).catch(logError)

    } else if (!isEmpty(decisionBranchId)) {
      return DecisionBranchAPI.nestedCreate(botId, decisionBranchId, body)
        .then(res => {
          commit(CREATE_DECISION_BRANCH_OF_DECISION_BRANCH, {
            decisionBranchId,
            newDecisionBranch: res.data.decisionBranch
          })

          getFlatTreeFromDecisionBranchId(state.questionsTree, decisionBranchId).then(nodes => {
            const relatedNodeIds = flatten(nodes.map(makeNodeIdsFromNode))
            commit(ADD_SEARCH_INDEX, { indexItem: { relatedNodeIds, text: body } })
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
      let promises = []
      promises.push(DecisionBranchAPI.nestedUpdate(botId, decisionBranchId, body, answer))

      if (isEmpty(answer)) {
        findDecisionBranchFromTree(state.questionsTree, decisionBranchId, (targetNode) => {
          targetNode.childDecisionBranches.forEach(db => {
            promises.push(DecisionBranchAPI.nestedDelete(botId, db.id))
          })
        })
      }

      return Promise.all(promises)
        .then((ress) => {
          if (isEmpty(answer)) {
            commit(DELETE_ANSWER_OF_DECISION_BRANCH, {
              decisionBranchId
            })
          }
          commit(UPDATE_DECISION_BRANCH_OF_DECISION_BRANCH, {
            decisionBranchId, body, answer
          })
        }).catch(logError)
    }
  },

  deleteDecisionBranch ({ commit, state }, { questionAnswerId, decisionBranchId, targetDecisionBranchId }) {
    const { botId } = state
    return DecisionBranchAPI.nestedDelete(botId, targetDecisionBranchId)
      .then(res => {
        commit(DELETE_DECISION_BRANCH, {
          targetDecisionBranchId
        })
      }).catch(logError)
  },

  selectAnswerLink ({ commit, state }, { decisionBranchId, answerRecordType, answerRecordId }) {
    const { botToken } = state
    return AnswerLinkAPI.create({
      botToken,
      decisionBranchId,
      answerRecordType,
      answerRecordId
    }).then(() => {
      commit(SET_ANSWER_LINK, { decisionBranchId, answerRecordType, answerRecordId })
    }).catch(logError)
  },

  deselectAnswerLink ({ commit, state }, { decisionBranchId }) {
    const { botToken } = state
    return AnswerLinkAPI.destroy({
      botToken,
      decisionBranchId
    }).then(() => {
      commit(UNSET_ANSWER_LINK, { decisionBranchId })
    }).catch(logError)
  },

  createSubQuestion ({ commit, state }, { questionAnswerId, question }) {
    const { botId } = state
    return SubQuestionAPI.create(botId, questionAnswerId, question)
      .then(res => {
        const { subQuestion } = res.data
        commit(ADD_SUB_QUESTION, { questionAnswerId, subQuestion })
      }).catch(logError)
  },

  updateSubQuestion ({ commit, state }, { questionAnswerId, subQuestionId, question }) {
    const { botId } = state
    return SubQuestionAPI.update(botId, questionAnswerId, subQuestionId, question)
      .then(res => {
        const { subQuestion } = res.data
        commit(UPDATE_SUB_QUESTION, { questionAnswerId, subQuestion })
      }).catch(logError)
  },

  deleteSubQuestion ({ commit, state }, { questionAnswerId, subQuestionId }) {
    const { botId } = state
    return SubQuestionAPI.destroy(botId, questionAnswerId, subQuestionId)
      .then(res => {
        commit(DELETE_SUB_QUESTION, { questionAnswerId, subQuestionId })
      }).catch(logError)
  },

  searchTree ({ commit, state }, { keyword }) {
    const hitted = state.searchIndex.filter(it => includes(it.text, keyword))
    const nodeIdsList = hitted.map(it => it.relatedNodeIds)
    const nodeIds = uniq(flatten(nodeIdsList))
    const questionNodeIds = nodeIdsList.map(it => it.filter(it => /^Question-[0-9]+$/.test(it)))
    const uniqQuestionNodeIds = uniq(flatten(questionNodeIds))
    const filteredQuestionsTree = state.questionsTree.filter(it => includes(uniqQuestionNodeIds, `Question-${it.id}`))
    commit(SET_FILTERED_QUESTIONS_TREE, { filteredQuestionsTree })
    commit(SET_SEARCHING_KEYWORD, { searchingKeyword: keyword})
    nodeIds.forEach(it => commit(OPEN_NODE, { nodeId: it }))
  },

  searchSelectableTree ({ commit, state }, { keyword }) {
    const hitted = state.searchIndex.filter(it => includes(it.text, keyword))
    const nodeIdsList = hitted.map(it => it.relatedNodeIds)
    const questionNodeIds = nodeIdsList.map(it => it.filter(it => /^Question-[0-9]+$/.test(it)))
    const uniqQuestionNodeIds = uniq(flatten(questionNodeIds))
    const filteredQuestionsSelectableTree = state.questionsTree.filter(it => includes(uniqQuestionNodeIds, `Question-${it.id}`))
    commit(SET_FILTERED_QUESTIONS_SELECTABLE_TREE, {
      filteredQuestionsSelectableTree
    })
    commit(SET_SELECTABLE_TREE_SEARCHING_KEYWORD, { selectableTreeSearchingKeyword: keyword })
  },

  clearSearchTree ({ commit, state }) {
    const { questionsTree } = state
    commit(SET_FILTERED_QUESTIONS_TREE, { filteredQuestionsTree: questionsTree })
    commit(SET_SEARCHING_KEYWORD, { searchingKeyword: '' })
  },

  clearSearchSelectableTree ({ commit, state }) {
    const { questionsTree } = state
    commit(SET_FILTERED_QUESTIONS_SELECTABLE_TREE, { filteredQuestionsSelectableTree: questionsTree })
    commit(SET_SELECTABLE_TREE_SEARCHING_KEYWORD, { selectableTreeSearchingKeyword: '' })
  },

  toggleIsOnlyShowHasDecisionBranchesNode ({ commit }) {
    commit(TOGGLE_IS_ONLY_SHOW_HAS_DECISION_BRANCHES_NODE)
  },

  moveDecisionBranchToHigherPosition ({ commit, state }, { decisionBranchId }) {
    const { botId } = state
    DecisionBranchAPI.moveHigher(botId, decisionBranchId).then(() => {
      commit(MOVE_DECISION_BRANCH_TO_HIGHER_POSITION, { decisionBranchId })
    })
  },

  moveDecisionBranchToLowerPosition ({ commit, state }, { decisionBranchId }) {
    const { botId } = state
    DecisionBranchAPI.moveLower(botId, decisionBranchId).then(() => {
      commit(MOVE_DECISION_BRANCH_TO_LOWER_POSITION, { decisionBranchId })
    })
  },
}