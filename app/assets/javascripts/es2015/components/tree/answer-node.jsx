import React from "react";
import classNames from "classnames";
import isEmpty from "is-empty";
import includes from "lodash/includes";
import assign from "lodash/assign";
import isEqual from "lodash/isEqual";

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
      answerNode,
      answersRepo,
      openedAnswerIDs,
      activeItem,
      onClickAnswer,
    } = this.props;

    const answer = answersRepo[answerNode.id];
    if (answer == null) { return null; } // Answerが削除された場合
    const { headline, body } = answer;

    const decisionBranchNodes = answerNode.decisionBranches;
    const hasDecisionBranches = !isEmpty(decisionBranchNodes);
    const isOpened = includes(openedAnswerIDs, answerNode.id);
    const itemClassName = classNames({
      "tree__item": hasDecisionBranches,
      "tree__item--no-children": !hasDecisionBranches,
      "tree__item--opened": isOpened,
      "active": isEqual(activeItem, { dataType: "answer", id: answerNode.id }),
    });

    return (
      <li className="tree__node">
        <div className={itemClassName} id={`answer-${answerNode.id}`}
          onClick={() => onClickAnswer("answer", answerNode.id)}>
          {!isEmpty(headline) && (
            <div className="tree__item-headline">{headline}</div>
          )}
          <div className="tree__item-body">
            <i className="material-icons" title="質問">chat_bubble_outline</i>
            {body}
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
