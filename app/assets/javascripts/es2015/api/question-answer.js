import axios from "axios";
import config from "./config";

export function find(botId, id) {
  return axios.get(`/api/bots/${botId}/question_answers/${id}.json`, config());
}
