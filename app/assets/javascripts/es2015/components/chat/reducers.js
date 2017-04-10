import { combineReducers } from "redux";

import messages from "./reducers/messages";
import form from "./reducers/form";
import learning from "./reducers/learning";
import learnings from "./reducers/learnings";
import readMore from "./reducers/read-more";

function through(state = null) {
  return state;
}

const app = combineReducers({
  messages,
  form,
  learning,
  learnings,
  readMore,
  token: through,
  isManager: through,
});

export default app;
