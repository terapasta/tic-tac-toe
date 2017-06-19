import axios from "axios";
import config from "./config";

export function fetchAll(botId) {
  return axios.get(`/bots/${botId}/question_answers/selections.json`, config());
}
