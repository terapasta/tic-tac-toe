import React from "react";
import classNames from "classnames";
import isEmpty from "is-empty";
import includes from "lodash/includes";
import assign from "lodash/assign";
import isEqual from "lodash/isEqual";
import get from "lodash/get";

import BaseNode from "./base-node";
import DecisionBranchNodes from "./decision-branch-nodes";

export default class AnswerNode extends BaseNode {
  static get componentName() {
    return "TreeNode";
  }

  static get propTypes() {
    return assign({}, super.propTypes, {});
  }

  render() {
    const {
      questionNode,
      answersRepo,
      questionsRepo,
      openedAnswerIDs,
      activeItem,
      onClickAnswer,
    } = this.props;

    const answer = get(questionsRepo[questionNode.id], "answer");
    if (answer == null) { return null; } // Answerが削除された場合

    const decisionBranchNodes = questionNode.decisionBranches;
    const hasDecisionBranches = !isEmpty(decisionBranchNodes);
    const isOpened = includes(openedAnswerIDs, questionNode.id);
    const itemClassName = classNames({
      "tree__item": hasDecisionBranches,
      "tree__item--no-children": !hasDecisionBranches,
      "tree__item--opened": isOpened,
      "active": isEqual(activeItem, { dataType: "answer", id: questionNode.id }),
    });

    return (
      <li className="tree__node">
        <div className={itemClassName} id={`answer-${questionNode.id}`}
          onClick={() => onClickAnswer("answer", questionNode.id)}>
          <div className="tree__item-body">
            <i className="material-icons" title="質問">chat_bubble_outline</i>
            {answer}
          </div>
        </div>
        <DecisionBranchNodes
          {...this.props}
          {...{ decisionBranchNodes }}
        />
      </li>
    );
  }
}
