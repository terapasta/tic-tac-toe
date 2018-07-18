import axios from 'axios'
import config from './config'

export function findAll (botId) {
  return axios.get(`/api/bots/${botId}/topic_tags.json`, config())
}

export function create (botId, data) {
  return axios.post(`/api/bots/${botId}/topic_tags.json`, data, config())
}

export function getRepo (botId) {
  return axios.get(`/api/bots/${botId}/topic_tags.json?data_format=repo`, config())
}
