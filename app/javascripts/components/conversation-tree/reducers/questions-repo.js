import assign from "lodash/assign";

import * as t from "../action-types";

export default function questionsRepo(state = {}, action) {
  const { type, questionModel } = action;

  switch(type) {
    case t.UPDATE_QUESTIONS_REPO:
      return assign({}, state, { [questionModel.id]: questionModel.attrs });
    case t.DELETE_QUESTIONS_REPO:
      delete state[questionModel.id];
      return assign({}, state);
    case t.ADD_QUESTIONS_REPO:
      return assign({}, state, { [questionModel.id]: questionModel.attrs });
    default:
      return state;
  }
}
