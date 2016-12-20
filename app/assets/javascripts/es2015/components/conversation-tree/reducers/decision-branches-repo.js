import assign from "lodash/assign";

import * as t from "../action-types";

export default function decisionBranchesRepo(state = {}, action) {
  const { type } = action;

  switch(type) {
    case t.UPDATE_DECISION_BRANCHES_REPO:
      return assign({}, state);
    case t.DELETE_DECISION_BRANCHES_REPO:
      return assign({}, state);
    case t.ADD_DECISION_BRANCHES_REPO:
      return assign({}, state);
    default:
      return state;
  }
}
