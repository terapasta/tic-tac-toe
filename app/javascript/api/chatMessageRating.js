import axios from 'axios'
import config from './config'

export function good(token, messageId) {
  return request(token, messageId, "good")
}

export function bad(token, messageId) {
  return request(token, messageId, "bad")
}

export function nothing(token, messageId) {
  return request(token, messageId, "nothing")
}

function request(token, messageId, resource) {
  const url = `/embed/${token}/chats/messages/${messageId}/rating/${resource}.json`
  return axios.put(url, {}, config())
}
