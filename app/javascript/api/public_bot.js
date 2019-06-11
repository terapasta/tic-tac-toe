import axios from "axios";
// import config from "./config";

export function find(token, options = {}) {
  let url = `/api/public_bots/${token}`
  if (options.origin) {
    url = options.origin + url;
  }
  return axios.get(url);
}
