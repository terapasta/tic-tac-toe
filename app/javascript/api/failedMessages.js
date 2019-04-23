import axios from 'axios'
import config from './config'

export const create = (token, guestKey, message) => {
  return axios.post(`/embed/${token}/chats/chat_failed_messages`, {
    guest_key: guestKey,
    message
  }, config())
}
