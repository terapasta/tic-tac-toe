import axios from 'axios'
import config from './config'

export const fetch = (guestKey) => {
  return axios.get(`/api/guest_users/${guestKey}`, {
    params: config(),
  })
}

export const create = ({ name, email }) => {
  return axios.post('/api/guest_users', {
    guest_user: { name, email }
  }, config())
}

export const update = (guestKey, { name, email }) => {
  return axios.put(`/api/guest_users/${guestKey}`, {
    guest_user: { name, email }
  }, config())
}

export const destroy = (guestKey) => {
  return axios.delete(`/api/guest_users/${guestKey}`, config())
}
