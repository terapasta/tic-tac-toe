import * as t from "../action-types";

export default function questionsTree(state = [], action) {
  const { type, questionModel } = action;
  let newQuestionNode;

  switch(type) {
    case t.ADD_QUESTION_TO_QUESTIONS_TREE:
      newQuestionNode = { id: questionModel.id };
      return [newQuestionNode].concat(state);

    case t.DELETE_QUESTION_FROM_QUESTIONS_TREE:
      return state.filter((questionNode) => questionNode.id != questionModel.id);

    default:
      return state;
  }
}
