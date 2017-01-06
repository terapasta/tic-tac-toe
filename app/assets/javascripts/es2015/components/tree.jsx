import React, { Component, PropTypes } from "react";
import includes from "lodash/includes";
import isFunction from "lodash/isFunction";

import AnswerNode from "./tree/answer-node";
import AddNode from "./tree/add-node";

export default class Tree extends Component {
  static get componentName() {
    return "Tree";
  }

  static get propTypes() {
    return {
      answersTree: PropTypes.array.isRequired,
      answersRepo: PropTypes.object.isRequired,
      decisionBranchesRepo: PropTypes.object.isRequired,
      onSelectItem: PropTypes.func.isRequired,
      onCreatingAnswer: PropTypes.func.isRequired,
      activeItem: PropTypes.object.isRequired,
      isAddingAnswer: PropTypes.bool.isRequired,
      openedAnswerIds: PropTypes.array.isRequired,
      openedDecisionBranchIds: PropTypes.array.isRequired,
    };
  }

  render() {
    const {
      answersTree,
      answersRepo,
      decisionBranchesRepo,
      activeItem,
      isAddingAnswer,
      openedAnswerIds,
      openedDecisionBranchIds,
      onSelectItem,
      onCreatingAnswer,
    } = this.props;

    return (
      <ol className="tree">
        {answersTree.map((answerNode, index) => {
          return <AnswerNode
            key={index}
            answerNode={answerNode}
            answersRepo={answersRepo}
            decisionBranchesRepo={decisionBranchesRepo}
            openedAnswerIDs={openedAnswerIds}
            openedDecisionBranchIDs={openedDecisionBranchIds}
            activeItem={activeItem}
            onClickAnswer={onSelectItem}
            onClickDecisionBranch={onSelectItem}
          />;
        })}
        <AddNode
          isAdding={isAddingAnswer}
          onClick={onCreatingAnswer}
        />
      </ol>
    );
  }
}
