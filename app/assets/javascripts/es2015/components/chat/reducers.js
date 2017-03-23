import { combineReducers } from "redux";

import messages from "./reducers/messages";

function through(state = null) {
  return state;
}

const app = combineReducers({
  messages,
  token: through,
});

export default app;
