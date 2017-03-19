import React, { Component, PropTypes } from "react";
import includes from "lodash/includes";
import isFunction from "lodash/isFunction";

import AnswerNode from "./tree/answer-node";
import AddNode from "./tree/add-node";
import QuestionNode from "./tree/question-node";

export default class Tree extends Component {
  static get componentName() {
    return "Tree";
  }

  static get propTypes() {
    return {
      questionsTree: PropTypes.array.isRequired,
      questionsRepo: PropTypes.object.isRequired,
      answersTree: PropTypes.array.isRequired,
      answersRepo: PropTypes.object.isRequired,
      decisionBranchesRepo: PropTypes.object.isRequired,
      onSelectItem: PropTypes.func.isRequired,
      onCreatingQuestion: PropTypes.func.isRequired,
      activeItem: PropTypes.object.isRequired,
      isAddingAnswer: PropTypes.bool.isRequired,
      openedQuestionIds: PropTypes.array.isRequired,
      openedAnswerIds: PropTypes.array.isRequired,
      openedDecisionBranchIds: PropTypes.array.isRequired,
    };
  }

  render() {
    const {
      questionsTree,
      questionsRepo,
      answersTree,
      answersRepo,
      decisionBranchesRepo,
      activeItem,
      isAddingAnswer,
      openedQuestionIds,
      openedAnswerIds,
      openedDecisionBranchIds,
      onSelectItem,
      onCreatingQuestion,
    } = this.props;

    return (
      <ol className="tree">
        {questionsTree.map((questionNode, index) => {
          return <QuestionNode
            {...{
              key: index,
              answerNode: {},
              questionNode,
              questionsRepo,
              answersRepo,
              decisionBranchesRepo,
              openedQuestionIds,
              openedAnswerIDs: openedAnswerIds,
              openedDecisionBranchIDs: openedDecisionBranchIds,
              activeItem,
              onClickQuestion: onSelectItem,
              onClickAnswer: onSelectItem,
              onClickDecisionBranch: onSelectItem,
            }}
          />;
        })}
        <AddNode
          isAdding={isAddingAnswer}
          onClick={onCreatingQuestion}
        />
      </ol>
    );
  }
}
