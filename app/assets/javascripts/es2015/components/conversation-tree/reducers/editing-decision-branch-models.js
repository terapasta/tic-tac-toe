import * as t from "../action-types";

export default function editingDecisionBranchModels(state = [], action) {
  const { type, decisionBranchModels, index } = action;
  let newState;

  switch(type) {
    case t.SET_EDITING_DECISION_BRANCH_MODELS:
      return decisionBranchModels;
    case t.CLEAR_EDITING_DECISION_BRANCH_MODELS:
      return [];
    case t.ACTIVATE_EDITING_DECISION_BRANCH_MODEL:
      newState = state.map((d) => d.clone());
      newState[index].isActive = true;
      return newState;
    default:
      return state;
  }
}
