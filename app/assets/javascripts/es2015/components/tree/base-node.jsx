import React, { Component, PropTypes } from "react";

export default class BaseNode extends Component {
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
}
