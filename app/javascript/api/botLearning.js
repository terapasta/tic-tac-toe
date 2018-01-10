import axios from 'axios'
import config from './config'

export function start(botId) {
  const path = `/bots/${botId}/learning`;
  return axios.put(path, {}, config());
}

export function status(botId) {
  const path = `/bots/${botId}/learning.json`;
  return axios.get(path);
}
