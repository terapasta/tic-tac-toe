import * as t from "../action-types";

export default function isProcessing(state = false, action) {
  const { type } = action;

  switch(type) {
    case t.ON_PROCESSING:
      return true;
    case t.OFF_PROCESSING:
      return false;
    default:
      return state;
  }
}
