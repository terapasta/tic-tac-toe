import assign from "lodash/assign";

import * as t from "../action-types";

export default function decisionBranchesRepo(state = {}, action) {
  const { type, decisionBranchModel } = action;

  switch(type) {
    case t.UPDATE_DECISION_BRANCHES_REPO:
      return assign({}, state, { [decisionBranchModel.id]: decisionBranchModel.attrs });
    case t.DELETE_DECISION_BRANCHES_REPO:
      delete state[decisionBranchModel.id];
      return assign({}, state);
    case t.ADD_DECISION_BRANCHES_REPO:
      return assign({}, state, { [decisionBranchModel.id]: decisionBranchModel.attrs });
    default:
      return state;
  }
}
