import * as t from "../action-types";

export default function editingAnswerModel(state = null, action) {
  const { type, answerModel } = action;

  switch(type) {
    case t.SET_EDITING_ANSWER_MODEL:
      return answerModel.clone();
    case t.CLEAR_EDITING_ANSWER_MODEL:
      return null;
    default:
      return state;
  }
}
