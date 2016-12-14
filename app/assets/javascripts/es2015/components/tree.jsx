import React, { Component, PropTypes } from "react";
import includes from "lodash/includes";

import AnswerNode from "./tree/answer-node";
import AddNode from "./tree/add-node";

export default class Tree extends Component {
  static get componentName() {
    return "Tree";
  }

  static get propTypes() {
    return {
      answers: PropTypes.array.isRequired,
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
    const { answers } = this.props;
    const {
      openedAnswerIDs,
      openedDecisionBranchIDs,
      activeItem,
      isAdding,
    } = this.state;

    return (
      <ol className="tree">
        {answers.map((answer, index) => {
          return <AnswerNode
            key={index}
            answer={answer}
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
    const { openedAnswerIDs } = this.state;
    this.setState({
      activeItem: { type: "answer", id: answerID },
      isAdding: false,
      openedAnswerIDs: toggleID(openedAnswerIDs, answerID),
    });
  }

  onClickDecisionBranch(decisionBrancheID) {
    const { openedDecisionBranchIDs } = this.state;
    this.setState({
      activeItem: { type: "decisionBranch", id: decisionBrancheID },
      isAdding: false,
      openedDecisionBranchIDs: toggleID(openedDecisionBranchIDs, decisionBrancheID),
    });
  }

  onClickAdd() {
    this.setState({
      activeItem: { type: null, id: null },
      isAdding: true,
    });
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
