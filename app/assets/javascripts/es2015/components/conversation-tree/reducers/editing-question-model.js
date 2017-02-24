import * as t from "../action-types";

export default function editingQuestionModel(state = null, action) {
  const { type, questionModel } = action;

  switch(type) {
    case t.SET_EDITING_QUESTION_MODEL:
      return questionModel;
    case t.CLEAR_EDITING_QUESTION_MODEL:
      return null;
    default:
      return state;
  }
}
