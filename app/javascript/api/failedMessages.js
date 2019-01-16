import axios from 'axios'
import config from './config'

export const create = (botToken, message) => {
  return axios.post(`/api/bots/${botToken}/chat_failed_messages`, {
    message
  }, config())
}
