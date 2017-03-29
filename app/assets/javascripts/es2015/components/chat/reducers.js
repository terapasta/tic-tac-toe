import { combineReducers } from "redux";

import messages from "./reducers/messages";
import form from "./reducers/form";
import learnings from "./reducers/learnings";

function through(state = null) {
  return state;
}

const app = combineReducers({
  messages,
  form,
  learnings,
  token: through,
  isManager: through,
});

export default app;
