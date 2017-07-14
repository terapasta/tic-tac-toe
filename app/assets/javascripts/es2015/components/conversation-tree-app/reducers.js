import { combineReducers } from "redux";

import openedNodes from './reducers/opened-nodes';
import activeItem from './reducers/active-item';

function through(state = null) {
  return state;
}

const app = combineReducers({
  botId: through,
  questionsTree: through,
  questionsRepo: through,
  decisionBranchesRepo: through,
  openedNodes,
  activeItem,
});

export default app;
