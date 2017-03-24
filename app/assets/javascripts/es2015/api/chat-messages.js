import axios from "axios";
import config from "./config"

export function fetchMessages(token, page = 1) {
  return axios.get(`/embed/${token}/chats/messages.json`);
}

export function postMessage(token, messageBody) {
  return axios.post(`/embed/${token}/chats/messages.json`, {
    message: {
      body: messageBody,
    }
  }, config());
}
