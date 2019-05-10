import * as t from "../action-types";

export default function isAddingAnswer(state = false, action) {
  const { type } = action;

  switch(type) {
    case t.ON_ADDING_ANSWER:
      return true;
    case t.OFF_ADDING_ANSWER:
      return false;
    default:
      return state;
  }
}
