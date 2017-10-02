import { combineReducers } from "redux";

import openedNodes from './reducers/opened-nodes';
import activeItem from './reducers/active-item';
import questionsTree from './reducers/questions-tree';
import questionsRepo from './reducers/questions-repo';
import decisionBranchesRepo from './reducers/decision-branches-repo';

function through(state = null) {
  return state;
}

const app = combineReducers({
  botId: through,
  questionsTree,
  questionsRepo,
  decisionBranchesRepo,
  openedNodes,
  activeItem,
});

export default app;
