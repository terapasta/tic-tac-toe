import { combineReducers } from "redux";

import messages from "./reducers/messages";
import form from "./reducers/form";
import learning from "./reducers/learning";
import learnings from "./reducers/learnings";
import readMore from "./reducers/read-more";
import initialQuestions from "./reducers/initial-questions";

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
  flashMessage: through,
  initialQuestions,
  useSimilarityClassification: through,
  showPath: through,
});

export default app;
