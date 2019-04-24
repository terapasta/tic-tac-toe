import * as t from "../action-types";

export default function editingDecisionBranchModel(state = null, action) {
  const { type, decisionBranchModel } = action;

  switch(type) {
    case t.SET_EDITING_DECISION_BRANCH_MODEL:
      return decisionBranchModel;
    case t.CLEAR_EDITING_DECISION_BRANCH_MODEL:
      return null;
    default:
      return state;
  }
}
