import axios from 'axios'
import config from './config'

export function good(token, guestKey, messageId) {
  return request(token, guestKey, messageId, "good")
}

export function bad(token, guestKey, messageId) {
  return request(token, guestKey, messageId, "bad")
}

export function nothing(token, guestKey, messageId) {
  return request(token, guestKey, messageId, "nothing")
}

function request(token, guestKey, messageId, resource) {
  const url = `/embed/${token}/chats/messages/${messageId}/rating/${resource}.json`
  return axios.put(url, {}, config({headers: {'X-Guest-Key': guestKey}}))
}
