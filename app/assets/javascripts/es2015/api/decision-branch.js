import axios from 'axios';
import config from './config';

export const create = (botId, questionAnswerId, body) => {
  return axios.post(`/api/bots/${botId}/question_answers/${questionAnswerId}/decision_branches.json`, {
    decision_branch: { body }
  }, config());
};

export const update = (botId, questionAnswerId, id, body, answer = null) => {
  const path = `/api/bots/${botId}/question_answers/${questionAnswerId}/decision_branches/${id}.json`;
  const params = { body };
  if (answer) { params.answer = answer; }

  return axios.put(path, { decision_branch: params }, config());
};

export const destroy = (botId, questionAnswerId, id) => {
  return axios.delete(`/api/bots/${botId}/question_answers/${questionAnswerId}/decision_branches/${id}.json`, config());
};

export const nestedCreate = (botId, parentDecisionBranchId, body) => {
  return axios.post(`/api/bots/${botId}/decision_branches.json`, {
    decision_branch: {
      body,
      parent_decision_branch_id: parentDecisionBranchId,
    }
  }, config());
}

export const nestedUpdate = (botId, id, body, answer = null) => {
  const params = { body };
  if (answer) { params.answer = answer; }

  return axios.put(`/api/bots/${botId}/decision_branches/${id}.json`, {
    decision_branch: params
  }, config());
}
