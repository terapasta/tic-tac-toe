import compact from "lodash/compact";
import flatten from "lodash/flatten";

export function findAnswerFromTree(answersTree, answerId, foundCallback) {
  answersTree.forEach((answerNode) => {
    if (answerNode.id === answerId) {
      foundCallback(answerNode);
    } else {
      const answers = compact(answerNode.decisionBranches.map((db) => db.answer));
      findAnswerFromTree(answers, answerId, foundCallback);
    }
  });
}

export function findDecisionBranchFromTree(answersTree, decisionBranchId, foundCallback) {
  const handler = (decisionBranchNodes) => {
    decisionBranchNodes.forEach((decisionBranchNode) => {
      if (decisionBranchNode.id === decisionBranchId) {
        foundCallback(decisionBranchNode);
      } else if (decisionBranchNode.answer != null) {
        handler(decisionBranchNode.answer.decisionBranches);
      }
    });
  };
  const decisionBranchNodes = flatten(answersTree.map((a) => a.decisionBranches));
  handler(decisionBranchNodes);
}
