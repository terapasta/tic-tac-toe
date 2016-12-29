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
      openedAnswerIDs: PropTypes.array.isRequired,
      openedDecisionBranchIDs: PropTypes.array.isRequired,
    };
  }

  constructor(props) {
    super(props);
    this.state = {
      isAdding: false,
    };
  }

  render() {
    const {
      answersTree,
      answersRepo,
      decisionBranchesRepo,
      activeItem,
      openedAnswerIDs,
      openedDecisionBranchIDs,
    } = this.props;

    const {
      isAdding,
    } = this.state;

    return (
      <ol className="tree">
        {answersTree.map((answerNode, index) => {
          return <AnswerNode
            key={index}
            answerNode={answerNode}
            answersRepo={answersRepo}
            decisionBranchesRepo={decisionBranchesRepo}
            openedAnswerIDs={openedAnswerIDs}
            openedDecisionBranchIDs={openedDecisionBranchIDs}
            activeItem={activeItem}
            onClickAnswer={this.onClickItem.bind(this)}
            onClickDecisionBranch={this.onClickDecisionBranch.bind(this)}
          />;
        })}
        <AddNode
          isAdding={isAdding}
          onClick={this.onClickAdd.bind(this)}
        />
      </ol>
    );
  }

  onClickItem(answerID) {
    const { onSelectItem } = this.props;
    const activeItem = { type: "answer", id: answerID };

    this.setState({
      isAdding: false,
    });

    if (isFunction(onSelectItem)) {
      onSelectItem(activeItem);
    }
  }

  onClickDecisionBranch(decisionBrancheID) {
    const { onSelectItem } = this.props;
    const activeItem = { type: "decisionBranch", id: decisionBrancheID };

    this.setState({
      isAdding: false,
    });

    if (isFunction(onSelectItem)) {
      onSelectItem(activeItem);
    }
  }

  onClickAdd() {
    const { onCreatingAnswer } = this.props;
    this.setState({
      isAdding: true,
    });

    if (isFunction(onCreatingAnswer)) {
      onCreatingAnswer();
    }
  }
}
