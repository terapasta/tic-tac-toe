import axios from 'axios'
import config from './config'

export function attachFileToQuestionAnswer(botId, questionAnswerId, file) {
  const formData = new FormData()
  formData.append('answer_file[file]', file)
  const path = `/api/bots/${botId}/question_answers/${questionAnswerId}/answer_files`
  return axios.post(path, formData, config())
}

export function removeQuestionAnswerFile(botId, questionAnswerId, answerFileId) {
  const path = `/api/bots/${botId}/question_answers/${questionAnswerId}/answer_files/${answerFileId}`
  return axios.delete(path, config())
}