import assign from "lodash/assign";

import * as t from "../action-types";

export default function answersRepo(state = {}, action) {
  const { type/*, answersRepo*/ } = action;

  switch(type) {
    case t.UPDATE_ANSWERS_REPO:
      return assign({}, state);
    case t.DELETE_ANSWERS_REPO:
      return assign({}, state);
    case t.ADD_ANSWERS_REPO:
      return assign({}, state);
    default:
      return state;
  }
}
