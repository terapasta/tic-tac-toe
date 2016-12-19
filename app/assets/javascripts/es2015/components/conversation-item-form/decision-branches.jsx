import React, { Component, PropTypes } from "react";

import DecisionBranchItem from "./decision-branch-item";
import EditingDecisionBranchItem from "./editing-decision-branch-item";

export default class DecisionBranches extends Component {
  static get componentName() {
    return "DecisionBranches";
  }

  static get propTypes() {
    return {
      decisionBranchModels: PropTypes.array,
    };
  }

  constructor(props) {
    super(props);
    this.state = {
      editingIndex: null,
      isProcessing: false,
    };
  }

  render() {
    const { decisionBranchModels } = this.props;
    const { editingIndex, isProcessing } = this.state;

    return (
      <ul className="list-group margin-bottom-8">
        {decisionBranchModels.map((decisionBranchModel, index) => {
          if (editingIndex === index) {
            return <EditingDecisionBranchItem
              decisionBranchModel={decisionBranchModel}
              key={index}
              index={index}
              onSave={this.onSave.bind(this)}
              isDisabled={isProcessing}
            />;
          } else {
            return <DecisionBranchItem
              decisionBranchModel={decisionBranchModel}
              key={index}
              onEdit={this.onEdit.bind(this, index)}
            />;
          }
        })}
      </ul>
    );
  }

  onEdit(index) {
    this.setState({ editingIndex: index });
  }

  onSave(index, value) {
    const { decisionBranchModels, onUpdate } = this.props;
    this.setState({ isProcessing: true });

    decisionBranchModels[index].update({ body: value })
      .then((decisionBranchModel) => {
        this.setState({
          isProcessing: false,
          editingIndex: null,
        });
        onUpdate(decisionBranchModel, index);
      });
  }
}
