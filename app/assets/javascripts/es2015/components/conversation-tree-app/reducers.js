import { combineReducers } from "redux";

import openedNodes from './reducers/opened-nodes';

function through(state = null) {
  return state;
}

const app = combineReducers({
  botId: through,
  questionsTree: through,
  questionsRepo: through,
  decisionBranchesRepo: through,
  openedNodes,
});

export default app;
