import axios from "axios"
import config from "./config"

export function fetchMessages(token, guestKey, page = 1) {
  return axios.get(`/embed/${token}/chats/messages.json`, {
    params: { page },
    headers: { 'X-Guest-Key': guestKey },
  });
}

export function postMessage(token, guestKey, messageBody) {
  return axios.post(`/embed/${token}/chats/messages.json`, {
    message: {
      body: messageBody,
    },
  },
  config({headers: { 'X-Guest-Key': guestKey }}));
}

export function chooseDecisionBranch(token, decisionBranchId) {
  return axios.post(`/embed/${token}/chats/choices/${decisionBranchId}.json`,
    config({headers: { 'X-Guest-Key': guestKey }}));
}

export function updateMessage(token, messageId, payload) {
  const path = `/embed/${token}/chats/messages/${messageId}.json`;
  return axios.put(path, assign({
    message: payload,
  }, config({headers: { 'X-Guest-Key': guestKey }})));
}
