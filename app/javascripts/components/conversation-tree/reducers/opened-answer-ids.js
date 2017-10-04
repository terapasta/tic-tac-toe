import filter from "lodash/filter";

import * as t from "../action-types";

export default function openedAnswerIds(state = [], action) {
  const { type, answerId } = action;

  switch(type) {
    case t.ADD_OPENED_ANSWER_IDS:
      return state.concat([answerId]);
    case t.REMOVE_OPENED_ANSWER_IDS:
      return filter(state.concat(), (id) => id != answerId);
    default:
      return state;
  }
}
