import assign from "lodash/assign";

import * as t from "../action-types";

export default function answersRepo(state = {}, action) {
  const { type, answerModel } = action;

  switch(type) {
    case t.UPDATE_ANSWERS_REPO:
      return assign({}, state, { [answerModel.id]: answerModel.attrs });
    case t.DELETE_ANSWERS_REPO:
      delete state[answerModel.id];
      return assign({}, state);
    case t.ADD_ANSWERS_REPO:
      return assign({}, state, { [answerModel.id]: answerModel.attrs });
    default:
      return state;
  }
}
