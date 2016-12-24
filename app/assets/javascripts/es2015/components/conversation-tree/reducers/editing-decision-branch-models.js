import findIndex from "lodash/findIndex";

import * as t from "../action-types";

export default function editingDecisionBranchModels(state = [], action) {
  const { type, decisionBranchModels, decisionBranchModel, index } = action;
  let targetIndex, newState;

  switch(type) {
    case t.SET_EDITING_DECISION_BRANCH_MODELS:
      return decisionBranchModels;

    case t.UPDATE_EDITING_DECISION_BRANCH_MODELS:
      targetIndex = findIndex(state, (d) => d.id === decisionBranchModel.id);
      newState = state.concat();
      newState[targetIndex] = decisionBranchModel;
      return newState;

    case t.CLEAR_EDITING_DECISION_BRANCH_MODELS:
      return [];

    case t.ACTIVATE_EDITING_DECISION_BRANCH_MODEL:
      newState = state.concat();
      newState[index].isActive = true;
      return newState;

    case t.INACTIVATE_EDITING_DECISION_BRANCH_MODELS:
      newState = state.concat();
      return newState.map((d) => {
        d.isActive = false;
        return d;
      });
    default:
      return state;
  }
}
