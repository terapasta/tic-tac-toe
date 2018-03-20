import axios from 'axios'
import config from './config'

export function fetchAll(botId) {
  return axios.get(`/bots/${botId}/question_answers/selections.json`, config())
}

export function update(botId, selectedQuestionAnswerIds)  {
  return axios.put(`/bots/${botId}/question_answers/selections.json`, {
    selected_question_answer_ids: selectedQuestionAnswerIds
  }, config())
}
