import find from "lodash/find";
import findIndex from "lodash/findIndex";
import assign from "lodash/assign";
import compact from "lodash/compact";
import { handleActions } from "redux-actions";

import {
  newLearning,
  updateLearning,
} from "../action-creators";

export default handleActions({
  [newLearning]: (state, action) => {
    const { questionId, answerId, questionBody } = action.payload;
    const isExists = find(state, { questionId, answerId });
    if (isExists) { return state; }

    return state.concat([{
      questionId,
      answerId,
      questionBody,
      answerBody: "",
    }]);
  },

  [updateLearning]: (state, action) => {
    const { questionId, answerId, questionBody, answerBody } = action.payload;
    const index = findIndex(state, { questionId, answerId });
    const target = state[index];
    if (!target) { return state; }
    let diff = {};
    if (questionBody != null) { diff.questionBody = questionBody; }
    if (answerBody != null) { diff.answerBody = answerBody; }
    const newItem = assign({}, target, diff);

    return [
      ...state.slice(0, index),
      newItem,
      ...state.slice(index + 1),
    ];
  },
}, []);
