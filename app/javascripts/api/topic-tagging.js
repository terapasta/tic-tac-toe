import axios from "axios";
import config from "./config";

export function findAll(botId, qaId) {
  const path = `/api/bots/${botId}/question_answers/${qaId}/topic_taggings.json`;
  return axios.get(path, config());
}

export function create(botId, qaId, data) {
  const path = `/api/bots/${botId}/question_answers/${qaId}/topic_taggings.json`;
  return axios.post(path, data, config());
}

export function destroy(botId, qaId, id) {
  const path = `/api/bots/${botId}/question_answers/${qaId}/topic_taggings/${id}.json`;
  return axios.delete(path, config());
}
