import axios from "axios";

export function fetchMessages(token, page = 1) {
  return axios.get(`/embed/${token}/chats/messages.json`);
}
