import axios from "axios";
import config from "./config";

export function find(botId, id) {
  return axios.get(`/api/bots/${botId}/question_answers/${id}.json`, config());
}

export function create(botId, question, answer) {
  return axios.post(`/api/bots/${botId}/question_answers.json`, {
    question_answer: {
      question,
      answer,
    }
  }, config());
}

export function update(botId, id, question, answer) {
  return axios.put(`/api/bots/${botId}/question_answers/${id}.json`, {
    question_answer: {
      question,
      answer,
    }
  }, config());
}

export function destroy(botId, id) {
  return axios.delete(`/api/bots/${botId}/question_answers/${id}.json`, config());
}

export function deleteChildDecisionBranches(botId, id) {
  return axios.delete(`/api/bots/${botId}/question_answers/${id}/child_decision_branches.json`, config());
}
