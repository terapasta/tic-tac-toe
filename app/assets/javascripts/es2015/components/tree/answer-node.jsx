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
      answer: PropTypes.shape({
        id:               PropTypes.number,
        headline:         PropTypes.string,
        body:             PropTypes.string,
        decisionBranches: PropTypes.array,
      }).isRequired,
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
      openedAnswerIDs,
      activeItem,
      onClickAnswer,
    } = this.props;

    const {
      id,
      headline,
      body,
      decisionBranches,
    } = this.props.answer;

    const hasDecisionBranches = !isEmpty(decisionBranches);
    const isOpened = includes(openedAnswerIDs, id);
    const itemClassName = classNames({
      "tree__item": hasDecisionBranches,
      "tree__item--no-children": !hasDecisionBranches,
      "tree__item--opened": isOpened,
      "active": activeItem.type === "answer" && activeItem.id === id,
    });

    return (
      <li className="tree__node">
        <div className={itemClassName} id={`answer-${id}`}
          onClick={() => onClickAnswer(id)}>
          {!isEmpty(headline) && (
            <div className="tree__item-headline">{headline}</div>
          )}
          <div className="tree__item-body">
            {body}
          </div>
        </div>
        {this.renderDecisionBranches(decisionBranches)}
      </li>
    );
  }

  renderDecisionBranches(decisionBranches) {
    if (isEmpty(decisionBranches)) { return null; }
    const {
      openedAnswerIDs,
      openedDecisionBranchIDs,
      activeItem,
      onClickAnswer,
      onClickDecisionBranch,
    } = this.props;
    const isOpenedAnswer = includes(openedAnswerIDs, this.props.answer.id);
    const style = { display: isOpenedAnswer ? "block" : null };

    return (
      <ol className="tree" style={style}>
        {decisionBranches.map((db, index) => {
          const { id, body, answer } = db;
          const isOpened = includes(openedDecisionBranchIDs, id);
          const hasAnswer = answer != null;
          const itemClassName = classNames({
            "tree__item": hasAnswer,
            "tree__item--no-children": !hasAnswer,
            "tree__item--opened": isOpened,
            "active": activeItem.type === "decisionBranch" && activeItem.id === id,
          });
          const style = { display: isOpened ? "block" : null };

          return (
            <li className="tree__node" key={index}>
              <div className={itemClassName} id={`decision-brandh-${id}`}
                onClick={() => onClickDecisionBranch(id)}>
                <div className="tree__item-body">{body}</div>
              </div>
              {hasAnswer && (
                <ol className="tree" style={style}>
                  <AnswerNode answer={answer}
                    onClickAnswer={onClickAnswer}
                    onClickDecisionBranch={onClickDecisionBranch}
                    openedAnswerIDs={openedAnswerIDs}
                    openedDecisionBranchIDs={openedDecisionBranchIDs}
                    activeItem={activeItem}
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
