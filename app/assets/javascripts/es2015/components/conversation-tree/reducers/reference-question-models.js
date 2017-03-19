import * as t from "../action-types";

export default function referenceQuestionModels(state = [], action) {
  const { type, questionModels } = action;

  switch(type) {
    case t.SET_REFERENCE_QUESTION_MODELS:
      return questionModels.concat();

    case t.CLEAR_REFERENCE_QUESTION_MODELS:
      return [];

    default:
      return state;
  }
}
