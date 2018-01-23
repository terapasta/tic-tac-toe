import axios from "axios";
import config from "./config";

export function create(botId, questionAnswerId, question) {
  return axios.post(`/api/bots/${botId}/question_answers/${questionAnswerId}/sub_questions.json`, {
    sub_question: {
      question
    }
  }, config())
}

export function update(botId, questionAnswerId, subQuestionId, question) {
  return axios.put(`/api/bots/${botId}/question_answers/${questionAnswerId}/sub_questions/${subQuestionId}.json`, {
    sub_question: {
      question
    }
  }, config())
}

export function destroy(botId, questionAnswerId, subQuestionId) {
  return axios.delete(`/api/bots/${botId}/question_answers/${questionAnswerId}/sub_questions/${subQuestionId}.json`, config())
}