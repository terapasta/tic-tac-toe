import filter from "lodash/filter";

import * as t from "../action-types";

export default function openedAnswerIds(state = [], action) {
  const { type, questionId } = action;

  switch(type) {
    case t.ADD_OPENED_QUESTION_IDS:
      return state.concat([questionId]);
    case t.REMOVE_OPENED_QUESTION_IDS:
      return filter(state.concat(), (id) => id != questionId);
    default:
      return state;
  }
}
