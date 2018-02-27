import includes from 'lodash/includes'
import indexOf from 'lodash/indexOf'
import pick from 'lodash/pick'
import findIndex from 'lodash/findIndex'
import sortBy from 'lodash/sortBy'
import assign from 'lodash/assign'
import filter from 'lodash/filter'
import isEmpty from 'is-empty'

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
  DELETE_DECISION_BRANCH_OF_QUESTION_ANSWER,
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
  MOVE_DECISION_BRANCH_TO_LOWER_POSITION,
  ADD_ANSWER_FILE_TO_QUESTION_ANSWER,
  REMOVE_ANSWER_FILE_FROM_QUESTION_ANSWER
} from './mutationTypes'

import {
  findDecisionBranchFromTree,
  findDecisionBranchFromTreeWithChildId,
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
    const newNode = pick(questionAnswer, ['id', 'decisionBranches'])
    state.questionsTree = [
      newNode,
      ...state.questionsTree
    ]
    state.filteredQuestionsTree = [
      newNode,
      ...state.filteredQuestionsTree
    ]
    state.questionsRepo[questionAnswer.id] = questionAnswer
  },

  [DELETE_QUESTION_ANSWER] (state, { id }) {
    const index = findIndex(state.questionsTree, (node) => node.id === id)
    state.questionsTree.splice(index, 1)
    delete state.questionsRepo[id]
  },

  [DELETE_ANSWER] (state, { questionAnswerId }) {
    const index = findIndex(state.questionsTree, (node) => node.id === questionAnswerId)
    state.questionsTree[index].decisionBranches = []
    state.questionsRepo[questionAnswerId].answer = ""
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
    newDecisionBranch.parentQuestionAnswerId = questionAnswerId
    setDecisionBranch(targetNode, 'decisionBranches', newDecisionBranch)
    state.decisionBranchesRepo[newDecisionBranch.id] = newDecisionBranch
  },

  [CREATE_DECISION_BRANCH_OF_DECISION_BRANCH] (state, { decisionBranchId, newDecisionBranch }) {
    findDecisionBranchFromTree(state.questionsTree, decisionBranchId, (targetNode) => {
      if (isEmpty(targetNode)) { return }
      newDecisionBranch.parentDecisionBranchId = decisionBranchId
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
    findDecisionBranchFromTreeWithChildId(state.questionsTree, targetDecisionBranchId, (targetNode) => {
      console.log(targetNode)
    })
    // const targetNode = findQuestionAnswerFromTree(state.questionsTree, questionAnswerId)
    // console.log(targetNode)
    // if (isEmpty(targetNode)) { return }
    // deleteDecisionBranch(targetNode.decisionBranches, targetDecisionBranchId)
    // delete state.decisionBranchesRepo[targetDecisionBranchId]
  },

  [DELETE_DECISION_BRANCH] (state, { targetDecisionBranchId }) {
    findDecisionBranchFromTreeWithChildId(state.questionsTree, targetDecisionBranchId, (targetNode) => {
      if (isEmpty(targetNode)) { return }
      const { decisionBranches, childDecisionBranches } = targetNode
      if (!isEmpty(decisionBranches)) {
        deleteDecisionBranch(decisionBranches, targetDecisionBranchId)
      } else if (!isEmpty(childDecisionBranches)) {
        deleteDecisionBranch(childDecisionBranches, targetDecisionBranchId)
      }
    })
  },

  [DELETE_ANSWER_OF_DECISION_BRANCH] (state, { decisionBranchId }) {
    findDecisionBranchFromTree(state.questionsTree, decisionBranchId, (targetNode) => {
      targetNode.childDecisionBranches = []
    })
    state.decisionBranchesRepo[decisionBranchId].answer = ""
  },

  [SET_ANSWER_LINK] (state, { decisionBranchId, answerRecordType, answerRecordId }) {
    const answerLink = { answerRecordType, answerRecordId }
    state.decisionBranchesRepo[decisionBranchId].answerLink = answerLink
  },

  [UNSET_ANSWER_LINK] (state, { decisionBranchId }) {
    state.decisionBranchesRepo[decisionBranchId].answerLink = null
  },

  [ADD_SUB_QUESTION] (state, { questionAnswerId, subQuestion }) {
    const qa = state.questionsRepo[questionAnswerId]
    qa.subQuestions = qa.subQuestions || []
    qa.subQuestions.push(subQuestion)
  },

  [UPDATE_SUB_QUESTION] (state, { questionAnswerId, subQuestion }) {
    const qa = state.questionsRepo[questionAnswerId]
    const index = findIndex(qa.subQuestions, (it) => it.id === subQuestion.id)
    if (index < 0) { return }
    qa.subQuestions.splice(index, 1, subQuestion)
  },

  [DELETE_SUB_QUESTION] (state, { questionAnswerId, subQuestionId }) {
    const qa = state.questionsRepo[questionAnswerId]
    const index = findIndex(qa.subQuestions, (it) => it.id === subQuestionId)
    if (index < 0) { return }
    qa.subQuestions.splice(index, 1)
  },

  [SET_FILTERED_QUESTIONS_TREE] (state, { filteredQuestionsTree }) {
    state.filteredQuestionsTree = filteredQuestionsTree
  },

  [SET_FILTERED_QUESTIONS_SELECTABLE_TREE] (state, { filteredQuestionsSelectableTree }) {
    state.filteredQuestionsSelectableTree = filteredQuestionsSelectableTree
  },

  [SET_SEARCHING_KEYWORD] (state, { searchingKeyword }) {
    state.searchingKeyword = searchingKeyword
  },

  [SET_SELECTABLE_TREE_SEARCHING_KEYWORD] (state, { selectableTreeSearchingKeyword }) {
    state.selectableTreeSearchingKeyword = selectableTreeSearchingKeyword
  },

  [ADD_SEARCH_INDEX] (state, { indexItem }) {
    state.searchIndex = state.searchIndex.concat([indexItem])
  },

  [TOGGLE_IS_ONLY_SHOW_HAS_DECISION_BRANCHES_NODE] (state) {
    state.isOnlyShowHasDecisionBranchesNode = !state.isOnlyShowHasDecisionBranchesNode

    if (state.isOnlyShowHasDecisionBranchesNode) {
      state.filteredQuestionsTree = state.questionsTree.filter(it => (
        !isEmpty(it.decisionBranches)
      ))
    } else {
      state.filteredQuestionsTree = state.questionsTree.concat()
    }
  },

  [MOVE_DECISION_BRANCH_TO_HIGHER_POSITION] (state, { decisionBranchId }) {
    const { decisionBranchesRepo, questionsTree } = state
    const db = decisionBranchesRepo[decisionBranchId]
    const moveToHigher = (dbIds) => {
      const decisionBranches = filter(decisionBranchesRepo, (it) => includes(dbIds, it.id))
      const sorted = sortBy(decisionBranches, ['position'])
      const targetIndex = findIndex(sorted, { id: decisionBranchId })
      if (targetIndex === -1 || targetIndex === 0) { return }
      const target = sorted[targetIndex]
      const prev = sorted[targetIndex - 1]
      target.position -= 1
      prev.position += 1
      state.decisionBranchesRepo = assign(state.decisionBranchesRepo, {
        [target.id]: target,
        [prev.id]: prev
      })
    }
    if (db.questionAnswerId) {
      const qaNode = findQuestionAnswerFromTree(questionsTree, db.questionAnswerId)
      const dbIds = qaNode.decisionBranches.map(it => it.id)
      moveToHigher(dbIds)

    } else if (db.parentDecisionBranchId) {
      findDecisionBranchFromTree(questionsTree, db.parentDecisionBranchId, (dbNode) => {
        const dbIds = dbNode.childDecisionBranches.map(it => it.id)
        moveToHigher(dbIds)
      })
    }
  },

  [MOVE_DECISION_BRANCH_TO_LOWER_POSITION] (state, { decisionBranchId }) {
    const { decisionBranchesRepo, questionsTree } = state
    const db = decisionBranchesRepo[decisionBranchId]
    const moveToLower = (dbIds) => {
      const decisionBranches = filter(decisionBranchesRepo, (it) => includes(dbIds, it.id))
      const sorted = sortBy(decisionBranches, ['position'])
      const targetIndex = findIndex(sorted, { id: decisionBranchId })
      if (targetIndex === sorted.length - 1) { return }
      const target = sorted[targetIndex]
      const next = sorted[targetIndex + 1]
      target.position += 1
      next.position -= 1
      state.decisionBranchesRepo = assign(state.decisionBranchesRepo, {
        [target.id]: target,
        [next.id]: next
      })
    }
    if (db.questionAnswerId) {
      const qaNode = findQuestionAnswerFromTree(questionsTree, db.questionAnswerId)
      const dbIds = qaNode.decisionBranches.map(it => it.id)
      moveToLower(dbIds)

    } else if (db.parentDecisionBranchId) {
      findDecisionBranchFromTree(questionsTree, db.parentDecisionBranchId, (dbNode) => {
        const dbIds = dbNode.childDecisionBranches.map(it => it.id)
        moveToLower(dbIds)
      })
    }
  },

  [ADD_ANSWER_FILE_TO_QUESTION_ANSWER] (state, { questionAnswerId, answerFile }) {
    const { questionsRepo } = state
    const qa = questionsRepo[questionAnswerId]
    qa.answerFiles = qa.answerFiles.concat([answerFile])
  },

  [REMOVE_ANSWER_FILE_FROM_QUESTION_ANSWER] (state, { questionAnswerId, answerFileId }) {
    const { questionsRepo } = state
    const qa = questionsRepo[questionAnswerId]
    qa.answerFiles = qa.answerFiles.filter(it => it.id !== answerFileId)
  }
}
