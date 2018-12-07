import assign from "lodash/assign";
import authenticityToken from "../helpers/authenticityToken";
import { getGuestKey } from '../helpers/guestKeyHandler';

export default function config(options = {}) {
  return assign({
    headers: {
      "X-CSRF-Token": authenticityToken(),
      "X-Guest-Key": getGuestKey(),
    }
  }, options);
}
