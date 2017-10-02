import React, { Component, PropTypes } from "react";

import DecisionBranchItem from "./decision-branch-item";
import EditingDecisionBranchItem from "./editing-decision-branch-item";

export default class DecisionBranches extends Component {
  static get componentName() {
    return "DecisionBranches";
  }

  static get propTypes() {
    return {
      isProcessing: PropTypes.bool.isRequired,
      decisionBranchModels: PropTypes.array,
      onSave: PropTypes.func.isRequired,
      onEdit: PropTypes.func.isRequired,
      onDelete: PropTypes.func.isRequired,
    };
  }

  render() {
    const { isProcessing, decisionBranchModels, onSave, onDelete, onEdit } = this.props;

    return (
      <ul className="list-group margin-bottom-8">
        {decisionBranchModels.map((decisionBranchModel, index) => {
          if (decisionBranchModel.isActive) {
            return <EditingDecisionBranchItem
              decisionBranchModel={decisionBranchModel}
              key={index}
              index={index}
              onSave={onSave}
              onDelete={onDelete}
              isDisabled={isProcessing}
            />;
          } else {
            return <DecisionBranchItem
              decisionBranchModel={decisionBranchModel}
              key={index}
              onEdit={this.bindOnEdit(index)}
            />;
          }
        })}
      </ul>
    );
  }

  // NOTE testの時にstubにできるようにこうしておく
  bindOnEdit(index) {
    return () => { this.props.onEdit(index); };
  }
}
