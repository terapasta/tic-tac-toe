import React, { Component, PropTypes } from "react";
import classNames from "classnames";
import isEmpty from "is-empty";
import includes from "lodash/includes";

export default class AnswerNode extends Component {
  static get componentName() {
    return "TreeNode";
  }

  static get propTypes() {
    return {
      answerNode:              PropTypes.object.isRequired,
      answersRepo:             PropTypes.object.isRequired,
      decisionBranchesRepo:    PropTypes.object.isRequired,
      openedAnswerIDs:         PropTypes.array.isRequired,
      openedDecisionBranchIDs: PropTypes.array.isRequired,
      activeItem:              PropTypes.shape({
        type: PropTypes.string,
        id:   PropTypes.number,
      }).isRequired,
      onClickAnswer:           PropTypes.func.isRequired,
      onClickDecisionBranch:   PropTypes.func.isRequired,
    };
  }

  constructor(props) {
    super(props);
    this.state = {
    };
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
    const decisionBrancheNodes = answerNode.decisionBranches;

    const {
      headline,
      body,
    } = answer;

    const hasDecisionBranches = !isEmpty(decisionBrancheNodes);
    const isOpened = includes(openedAnswerIDs, answerNode.id);
    const itemClassName = classNames({
      "tree__item": hasDecisionBranches,
      "tree__item--no-children": !hasDecisionBranches,
      "tree__item--opened": isOpened,
      "active": activeItem.dataType === "answer" && activeItem.id === answerNode.id,
    });

    return (
      <li className="tree__node">
        <div className={itemClassName} id={`answer-${answerNode.id}`}
          onClick={() => onClickAnswer("answer", answerNode.id)}>
          {!isEmpty(headline) && (
            <div className="tree__item-headline">{headline}</div>
          )}
          <div className="tree__item-body">
            {body}
          </div>
        </div>
        {this.renderDecisionBranches(decisionBrancheNodes)}
      </li>
    );
  }

  renderDecisionBranches(decisionBrancheNodes) {
    if (isEmpty(decisionBrancheNodes)) { return null; }
    const {
      answerNode,
      answersRepo,
      decisionBranchesRepo,
      openedAnswerIDs,
      openedDecisionBranchIDs,
      activeItem,
      onClickAnswer,
      onClickDecisionBranch,
    } = this.props;
    const isOpenedAnswer = includes(openedAnswerIDs, answerNode.id);
    const style = { display: isOpenedAnswer ? "block" : null };

    return (
      <ol className="tree" style={style}>
        {decisionBrancheNodes.map((decisionBranchNode, index) => {
          const { id } = decisionBranchNode;
          const answerNode = decisionBranchNode.answer;
          const db = decisionBranchesRepo[id];
          const { body } = db;
          const isOpened = includes(openedDecisionBranchIDs, id);
          const hasAnswer = answerNode != null;
          const itemClassName = classNames({
            "tree__item": hasAnswer,
            "tree__item--no-children": !hasAnswer,
            "tree__item--opened": isOpened,
            "active": activeItem.dataType === "decisionBranch" && activeItem.id === id,
          });
          const style = { display: isOpened ? "block" : null };

          return (
            <li className="tree__node" key={index}>
              <div className={itemClassName} id={`decision-branch-${id}`}
                onClick={() => onClickDecisionBranch("decisionBranch", id)}>
                <div className="tree__item-body">{body}</div>
              </div>
              {hasAnswer && (
                <ol className="tree" style={style}>
                  <AnswerNode
                    answerNode={answerNode}
                    answersRepo={answersRepo}
                    decisionBranchesRepo={decisionBranchesRepo}
                    openedAnswerIDs={openedAnswerIDs}
                    openedDecisionBranchIDs={openedDecisionBranchIDs}
                    activeItem={activeItem}
                    onClickAnswer={onClickAnswer}
                    onClickDecisionBranch={onClickDecisionBranch}
                  />
                </ol>
              )}
            </li>
          );
        })}
      </ol>
    );
  }
}
