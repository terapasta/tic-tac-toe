import axios from 'axios'
import config from './config'
import { assign } from 'lodash'

export const create = (botId, questionAnswerId, body) => {
  return axios.post(`/api/bots/${botId}/question_answers/${questionAnswerId}/decision_branches.json`, {
    decision_branch: { body }
  }, config())
}

export const update = (botId, questionAnswerId, id, body, answer = null) => {
  const path = `/api/bots/${botId}/question_answers/${questionAnswerId}/decision_branches/${id}.json`
  const params = { body }
  if (answer != null) { params.answer = answer }

  return axios.put(path, { decision_branch: params }, config())
}

export const destroy = (botId, questionAnswerId, id) => {
  return axios.delete(`/api/bots/${botId}/question_answers/${questionAnswerId}/decision_branches/${id}.json`, config())
}

export const nestedCreate = (botId, parentDecisionBranchId, body) => {
  return axios.post(`/api/bots/${botId}/decision_branches.json`, {
    decision_branch: {
      body,
      parent_decision_branch_id: parentDecisionBranchId,
    }
  }, config())
}

export const nestedUpdate = (botId, id, body, answer = null) => {
  const params = { body }
  if (answer != null) { params.answer = answer }

  return axios.put(`/api/bots/${botId}/decision_branches/${id}.json`, {
    decision_branch: params
  }, config())
}

export const nestedDelete = (botId, id) => {
  return axios.delete(`/api/bots/${botId}/decision_branches/${id}.json`, config())
}

export const deleteChildren = (botId, id) => {
  return axios.delete(`/api/bots/${botId}/decision_branches/${id}/child_decision_branches.json`, config())
}

export const moveHigher = (botId, id) => (
  axios.put(`/api/bots/${botId}/decision_branches/${id}/position/higher`, {}, config())
)
export const moveLower = (botId, id) => (
  axios.put(`/api/bots/${botId}/decision_branches/${id}/position/lower`, {}, config())
)

export const bulkDelete = (botId, decisionBranchIds) => (
  axios.delete(`/api/bots/${botId}/decision_branches/bulk`, assign({}, config(), {
    params: { decision_branch_ids: decisionBranchIds }
  }))
)