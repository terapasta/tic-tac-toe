import assign from "lodash/assign";
import authenticityToken from "../modules/authenticity-token";

export default function config(options = {}) {
  return assign({
    headers: {
      "X-CSRF-Token": authenticityToken(),
    }
  }, options);
}
