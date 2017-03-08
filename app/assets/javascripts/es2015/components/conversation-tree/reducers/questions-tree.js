import * as t from "../action-types";
import cloneDeep from "lodash/cloneDeep";
import assign from "lodash/assign";

import {
  findAnswerFromTree,
  findQuestionFromTree,
  deleteAnswerFromTree,
  deleteDecisionBranchFromTree,
} from "../helpers";

export default function questionsTree(state = [], action) {
  const {
    type,
    questionModel,
    answerNode,
    decisionBranchId,
    decisionBranchModel,
    answerModel,
    answerId,
  } = action;
  let newQuestionNode;
  let newQuestionsTree = cloneDeep(state);

  switch(type) {
    case t.ADD_QUESTION_TO_QUESTIONS_TREE:
      newQuestionNode = { id: questionModel.id };
      return [newQuestionNode].concat(state);

    case t.UPDATE_QUESTION_ANSWER_IN_QUESTIONS_TREE:
      findQuestionFromTree(newQuestionsTree, questionModel.id, (questionNode) => {
        questionNode.answer = assign({
          decisionBranches: [],
        }, answerNode);
      });
      return newQuestionsTree;

    case t.DELETE_ANSWER_FROM_QUESTIONS_TREE:
      deleteAnswerFromTree(newQuestionsTree, answerModel.id);
      return newQuestionsTree;

    case t.DELETE_QUESTION_FROM_QUESTIONS_TREE:
      return state.filter((questionNode) => questionNode.id != questionModel.id);

    case t.ADD_DECISION_BRANCH_TO_QUESTIONS_TREE:
      findAnswerFromTree(newQuestionsTree, answerId, (answerNode) => {
        answerNode.decisionBranches = answerNode.decisionBranches || [];
        answerNode.decisionBranches.push(decisionBranchModel);
      });
      return newQuestionsTree;

    case t.DELETE_DECISION_BRANCH_FROM_QUESTIONS_TREE:
      deleteDecisionBranchFromTree(newQuestionsTree, decisionBranchModel.id, answerId);
      return newQuestionsTree;

    default:
      return state;
  }
}
