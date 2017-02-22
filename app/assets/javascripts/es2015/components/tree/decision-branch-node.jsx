import React, { PropTypes } from "react";
import classNames from "classnames";
import isEmpty from "is-empty";
import includes from "lodash/includes";
import assign from "lodash/assign";

import BaseNode from "./base-node";
import AnswerNode from "./answer-node";

export default class DecisionBranchNode extends BaseNode {
  static get propTypes() {
    return assign({}, super.propTypes, {
      decisionBranchNode: PropTypes.object.isRequired,
    });
  }

  render() {
    const {
      decisionBranchNode,
      answersRepo,
      decisionBranchesRepo,
      openedDecisionBranchIDs,
      openedAnswerIDs,
      activeItem,
      onClickAnswer,
      onClickDecisionBranch,
    } = this.props;

    const { id, answer } = decisionBranchNode;
    const { body } = decisionBranchesRepo[id];
    const isOpened = includes(openedDecisionBranchIDs, id);
    const hasAnswer = answer != null;
    const itemClassName = classNames({
      "tree__item": hasAnswer,
      "tree__item--no-children": !hasAnswer,
      "tree__item--opened": isOpened,
      "active": activeItem.dataType === "decisionBranch" && activeItem.id === id,
    });
    const style = { display: isOpened ? "block" : null };

    return (
      <li className="tree__node">
        <div className={itemClassName} id={`decision-branch-${id}`}
          onClick={() => onClickDecisionBranch("decisionBranch", id)}>
          <div className="tree__item-body">
            <i className="material-icons upside-down" title="選択肢">call_split</i>
            {body}
          </div>
        </div>
        {hasAnswer && (
          <ol className="tree" style={style}>
            <AnswerNode
              {...{
                answerNode: answer,
                answersRepo,
                decisionBranchesRepo,
                openedAnswerIDs,
                openedDecisionBranchIDs,
                activeItem,
                onClickAnswer,
                onClickDecisionBranch,
              }}
            />
          </ol>
        )}
      </li>
    );
  }
}
