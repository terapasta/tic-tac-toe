import axios from 'axios'
import config from './config'

export function create(token, messageId, body) {
  const url = `/embed/${token}/chats/messages/${messageId}/bad_reasons`
  return axios.post(url, { bad_reason: { body } }, config())
}