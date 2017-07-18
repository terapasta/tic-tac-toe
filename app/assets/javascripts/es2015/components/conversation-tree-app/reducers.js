import { combineReducers } from "redux";

import openedNodes from './reducers/opened-nodes';
import activeItem from './reducers/active-item';
import questionsTree from './reducers/questions-tree';
import questionsRepo from './reducers/questions-repo';

function through(state = null) {
  return state;
}

const app = combineReducers({
  botId: through,
  questionsTree,
  questionsRepo,
  decisionBranchesRepo: through,
  openedNodes,
  activeItem,
});

export default app;
