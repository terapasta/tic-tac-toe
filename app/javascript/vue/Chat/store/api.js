import axios from 'axios'

export function fetchMessages ({ botToken, guestKey, page, perPage }) {
  return axios.get(`/myope/${botToken}/messages`, { params: { guestKey, page, perPage } })
}

export function createMessage ({ botToken, guestKey, message }) {
  return axios.post(`/myope/${botToken}/messages`, { guestKey, message })
}

export function selectDecisionBranch ({ botToken, guestKey, decisionBranchId }) {
  return axios.post(`/myope/${botToken}/choices`, { guestKey, choiceId: decisionBranchId })
}

export function createRating ({ botToken, guestKey, messageId, ratingLevel }) {
  return axios.post(`/myope/${botToken}/messages/${messageId}/rating`, {
    guestKey,
    ratingLevel,
  })
}

export function createGuestUser ({ name, email }) {
  return axios.post('/myope/guest_users', { name, email })
}

export function updateGuestUser ({ guestId, name, email }) {
  return axios.put(`/myope/guest_users/${guestId}`, { name, email })
}
