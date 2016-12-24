import { combineReducers } from "redux";

import answersTree from "./reducers/answers-tree";
import answersRepo from "./reducers/answers-repo";
import decisionBranchesRepo from "./reducers/decision-branches-repo";
import openedAnswerIds from "./reducers/opened-answer-ids";
import openedDecisionBranchIds from "./reducers/opened-decision-branch-ids";
import isAddingAnswer from "./reducers/is-adding-answer";
import isAddingDecisionBranch from "./reducers/is-adding-decision-branch";
import isProcessing from "./reducers/is-processing";
import activeItem from "./reducers/active-item";
import editingAnswerModel from "./reducers/editing-answer-model";
import editingDecisionBranchModel from "./reducers/editing-decision-branch-model";
import editingDecisionBranchModels from "./reducers/editing-decision-branch-models";

function through(state = null) {
  return state;
}

const app = combineReducers({
  answersTree,
  answersRepo,
  decisionBranchesRepo,
  openedAnswerIds,
  openedDecisionBranchIds,
  isAddingAnswer,
  isAddingDecisionBranch,
  isProcessing,
  activeItem,
  editingAnswerModel,
  editingDecisionBranchModel,
  editingDecisionBranchModels,
  botId: through,
});

export default app;
