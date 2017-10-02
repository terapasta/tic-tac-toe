import get from "lodash/get";
import compact from "lodash/compact";
import flatten from "lodash/flatten";
import find from "lodash/find";

export function findAnswerFromTree(questionsTree, answerId, foundCallback) {
  const answerNodes = questionsTree.map((q) => q.answer);
  const search = (answerNodes) => {
    answerNodes.forEach((answerNode) => {
      if (answerNode == null) { return; }
      if (answerNode.id === answerId) {
        foundCallback(answerNode);
      } else {
        const answers = compact(answerNode.decisionBranches.map((db) => db.answer));
        search(answers, answerId, foundCallback);
      }
    });
  };
  search(answerNodes);
}

export function deleteAnswerFromTree(questionsTree, answerId) {
  const deleter = (parents) => {
    parents.forEach((parent, index) => {
      if (get(parent, "answer.id") === answerId) {
        delete parents[index].answer;
      }
    });
    compact(parents.map((p) => p.answer)).forEach((a) => {
      deleter(a.decisionBranches);
    });
  };
  deleter(questionsTree);
}

export function findDecisionBranchFromTree(questionsTree, decisionBranchId, foundCallback) {
  const handler = (decisionBranchNodes) => {
    decisionBranchNodes.forEach((decisionBranchNode) => {
      if (decisionBranchNode.id === decisionBranchId) {
        foundCallback(decisionBranchNode);
      } else if (decisionBranchNode.answer != null) {
        handler(decisionBranchNode.answer.decisionBranches);
      }
    });
  };
  const answersTree = compact(questionsTree.map((q) => q.answer));
  const decisionBranchNodes = flatten(answersTree.map((a) => a.decisionBranches));
  handler(decisionBranchNodes);
}

export function findQuestionFromTree(questionsTree, questionId, foundCallback) {
  const target = find(questionsTree, (q) => q.id == questionId);
  if (target != null) {
    foundCallback(target);
  }
}

export function deleteDecisionBranchFromTree(questionsTree, decisionBranchId) {
  const deleter = (answerNodes) => {
    answerNodes.forEach((answerNode, index) => {
      answerNode.decisionBranches.forEach((decisionBranch, index) => {
        if (decisionBranch.id == decisionBranchId) {
          answerNode.decisionBranches.splice(index, 1);
        }
      });
      deleter(compact(answerNode.decisionBranches.map((db) => db.answer)));
    });
  };
  deleter(compact(questionsTree.map((q) => q.answer)));
}
