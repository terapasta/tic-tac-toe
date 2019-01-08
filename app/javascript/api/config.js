import assign from "lodash/assign";
import authenticityToken from "../helpers/authenticityToken";

export default function config(options = {}) {
  return assign({
    headers: {
      "X-CSRF-Token": authenticityToken(),
    }
  }, options);
}
