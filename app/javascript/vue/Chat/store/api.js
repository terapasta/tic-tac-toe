import axios from 'axios'
import makeQueryParams from '../../../helpers/makeQueryParams'

export function fetchMessages ({ botToken, guestKey, olderThanId, perPage }) {
  return axios.get(`/myope/${botToken}/messages`, { params: { guestKey, olderThanId, perPage } })
}

export function createMessage ({ botToken, guestKey, message, questionAnswerId }) {
  return axios.post(`/myope/${botToken}/messages`, { guestKey, message, questionAnswerId })
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

export function createGuestUser ({ name, email, guestKey }) {
  return axios.post('/myope/guest_users', { name, email, guestKey })
}

export function updateGuestUser ({ guestKey, name, email }) {
  return axios.put(`/myope/guest_users/${guestKey}`, { name, email })
}

export function createChoice ({ botToken, guestKey, choiceId }) {
  return axios.post(`/myope/${botToken}/choices`, {
    guestKey,
    choiceId,
  })
}

export function fetchQuestionAnswers ({ botToken, excludeIds }) {
  const queryParams = makeQueryParams({ excludeIds })
  return axios.get(`/myope/${botToken}/question_answers${queryParams}`)
}

export function fetchJwt () {
  return axios({ url: '/api/jwt', baseURL: window.location.origin })
}
