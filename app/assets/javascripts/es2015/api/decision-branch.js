import axios from 'axios';
import config from './config';

export const create = (botId, questionAnswerId, body) => {
  return axios.post(`/api/bots/${botId}/question_answers/${questionAnswerId}/decision_branches.json`, {
    decision_branch: { body }
  }, config());
};

export const update = (botId, questionAnswerId, id, body) => {
  return axios.put(`/api/bots/${botId}/question_answers/${questionAnswerId}/decision_branches/${id}.json`, {
    decision_branch: { body }
  }, config());
};

export const destroy = (botId, questionAnswerId, id) => {
  return axios.delete(`/api/bots/${botId}/question_answers/${questionAnswerId}/decision_branches/${id}.json`, config());
};
