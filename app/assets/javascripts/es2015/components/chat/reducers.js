import { combineReducers } from "redux";

import messages from "./reducers/messages";
import form from "./reducers/form";

function through(state = null) {
  return state;
}

const app = combineReducers({
  messages,
  form,
  token: through,
});

export default app;
