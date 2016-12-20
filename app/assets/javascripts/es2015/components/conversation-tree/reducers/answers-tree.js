import * as t from "../action-types";

export default function answersTree(state = [], action) {
  const { type/*, answerModel*/ } = action;

  switch(type) {
    case t.UPDATE_ANSWERS_TREE:
      return state.concat();
    case t.DELETE_ANSWERS_TREE:
      return state.concat();
    case t.ADD_ANSWERS_TREE:
      return state.concat();
    default:
      return state;
  }
}
