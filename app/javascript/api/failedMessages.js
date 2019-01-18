import axios from 'axios'
import config from './config'

export const create = (botToken, guestKey, message) => {
  return axios.post(`/api/bots/${botToken}/chat_failed_messages`, {
    guest_key: guestKey,
    message
  }, config())
}
