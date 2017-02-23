import React from "react";
import classNames from "classnames";
import get from "lodash/get";
import filter from "lodash/filter";
import isEqual from "lodash/isEqual";
import includes from "lodash/includes";
import isEmpty from "is-empty";

import BaseNode from "./base-node";
import AnswerNode from "./answer-node";

export default class QuestionNode extends BaseNode {
  render() {
    const {
      questionNode,
      questionsRepo,
      answersRepo,
      decisionBranchesRepo,
      openedQuestionIds,
      openedAnswerIDs,
      openedDecisionBranchIDs,
      activeItem,
      onClickQuestion,
      onClickAnswer,
      onClickDecisionBranch,
    } = this.props;

    const {
      id,
      answer,
    } = questionNode;

    const {
      question,
    } = questionsRepo[questionNode.id];

    const isOpened = includes(openedQuestionIds, questionNode.id);
    const style = { display: (isOpened ? "block" : "none") };
    const itemClassName = classNames({
      "tree__item": answer != null,
      "tree__item--no-children": answer == null,
      "tree__item--opened": isOpened,
      "active": isEqual(activeItem, { dataType: "question", id: questionNode.id }),
    });

    return (
      <li className="tree__node">
        <div className={itemClassName} id={`question-${id}`}
          onClick={() => onClickQuestion("question", id)}>
          <div className="tree__item-body">
            <i className="material-icons" title="質問">comment</i>
            {question}
          </div>
        </div>
        {answer && (
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
