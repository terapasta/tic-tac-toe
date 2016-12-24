import * as t from "../action-types";
import { findAnswerFromTree, findDecisionBranchFromTree } from "../helpers";

export default function answersTree(state = [], action) {
  const { type, answerModel, decisionBranchModel, answerId, decisionBranchId } = action;
  let newAnswerNode = {};
  let newDecisionBranchNode = {};

  switch(type) {
    case t.ADD_ANSWER_TO_ANSWERS_TREE:
      newAnswerNode = { id: answerModel.id, decisionBranches: [] };

      if (decisionBranchId == null) {
        return [newAnswerNode].concat(state);
      } else {
        findDecisionBranchFromTree(state, decisionBranchId, (decisionBranchNode) => {
          decisionBranchNode.answer = newAnswerNode;
        });
        return state.concat();
      }

    case t.ADD_DECISION_BRANCH_TO_ANSWERS_TREE:
      newDecisionBranchNode = { id: decisionBranchModel.id, answer: null };

      findAnswerFromTree(state, answerId, (answerNode) => {
        answerNode.decisionBranches.push(newDecisionBranchNode);
      });
      return state.concat();

    case t.DELETE_ANSWER_FROM_ANSWERS_TREE:
      if (decisionBranchId == null) {
        return state.filter((answerNode) => answerNode.id != answerModel.id);
      } else {
        findDecisionBranchFromTree(state, decisionBranchId, (decisionBranchNode) => {
          delete decisionBranchNode.answer;
        });
        return state.concat();
      }

    case t.DELETE_DECISION_BRANCH_FROM_ANSWERS_TREE:
      findAnswerFromTree(state, answerId, (answerNode) => {
        answerNode.decisionBranches = answerNode.decisionBranches.filter((decisionBranchNode) => {
          return decisionBranchNode.id != decisionBranchModel.id;
        });
      });
      return state.concat();

    default:
      return state;
  }
}
