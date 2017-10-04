import axios from "axios";
import assign from "lodash/assign";

import config from "./config";

export function findAll(botId, params = {}) {
  return axios.get(`/api/bots/${botId}/answers`, assign(config(), { params }));
}
