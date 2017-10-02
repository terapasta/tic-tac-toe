import filter from "lodash/filter";

import * as t from "../action-types";

export default function openedDecisionBranchIds(state = [], action) {
  const { type, decisionBranchId } = action;

  switch(type) {
    case t.ADD_OPENED_DECISION_BRANCH_IDS:
      return state.concat([decisionBranchId]);
    case t.REMOVE_OPENED_DECISION_BRANCH_IDS:
      return filter(state.concat(), (id) => id != decisionBranchId);
    default:
      return state;
  }
}
