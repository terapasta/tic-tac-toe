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
    };
  }

  constructor(props) {
    super(props);
    this.state = {
      openedAnswerIDs: [],
      openedDecisionBranchIDs: [],
      activeItem: { type: null, id: null },
      isAdding: false,
    };
  }

  render() {
    const {
      answersTree,
      answersRepo,
      decisionBranchesRepo,
    } = this.props;

    const {
      openedAnswerIDs,
      openedDecisionBranchIDs,
      activeItem,
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
    const { openedAnswerIDs } = this.state;
    const activeItem = { type: "answer", id: answerID };

    this.setState({
      activeItem,
      isAdding: false,
      openedAnswerIDs: toggleID(openedAnswerIDs, answerID),
    });

    if (isFunction(onSelectItem)) {
      onSelectItem(activeItem);
    }
  }

  onClickDecisionBranch(decisionBrancheID) {
    const { onSelectItem } = this.props;
    const { openedDecisionBranchIDs } = this.state;
    const activeItem = { type: "decisionBranch", id: decisionBrancheID };

    this.setState({
      activeItem,
      isAdding: false,
      openedDecisionBranchIDs: toggleID(openedDecisionBranchIDs, decisionBrancheID),
    });

    if (isFunction(onSelectItem)) {
      onSelectItem(activeItem);
    }
  }

  onClickAdd() {
    const { onCreatingAnswer } = this.props;
    this.setState({
      activeItem: { type: null, id: null },
      isAdding: true,
    });

    if (isFunction(onCreatingAnswer)) {
      onCreatingAnswer();
    }
  }
}

function toggleID(IDs, targetID) {
  let newIDs;
  if (includes(IDs, targetID)) {
    newIDs = IDs.filter((id) => id != targetID);
  } else {
    newIDs = IDs.concat([targetID]);
  }
  return newIDs;
}
