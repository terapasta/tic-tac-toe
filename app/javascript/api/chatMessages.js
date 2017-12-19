import axios from "axios"
import config from "./config"

export function fetchMessages(token, page = 1) {
  return axios.get(`/embed/${token}/chats/messages.json`, {
    params: { page }
  });
}

export function postMessage(token, messageBody) {
  return axios.post(`/embed/${token}/chats/messages.json`, {
    message: {
      body: messageBody,
    }
  }, config());
}

export function chooseDecisionBranch(token, decisionBranchId) {
  return axios.post(`/embed/${token}/chats/choices/${decisionBranchId}.json`, config());
}

export function updateMessage(token, messageId, payload) {
  const path = `/embed/${token}/chats/messages/${messageId}.json`;
  return axios.put(path, assign({ message: payload }, config()));
}
