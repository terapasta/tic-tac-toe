import * as t from "../action-types";

export default function isAddingDecisionBranch(state = false, action) {
  const { type } = action;

  switch(type) {
    case t.ON_ADDING_DECISION_BRANCH:
      return true;
    case t.OFF_ADDING_DECISION_BRANCH:
      return false;
    default:
      return state;
  }
}
