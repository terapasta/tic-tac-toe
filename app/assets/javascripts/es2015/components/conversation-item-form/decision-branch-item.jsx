import React, { Component } from "react";

export default class DecisionBranchItem extends Component {
  render() {
    const { decisionBranchModel, onEdit } = this.props;
    return (
      <li className="list-group-item clearfix" id={`decision-branch-item-${decisionBranchModel.id}`}>
        <span>{decisionBranchModel.body}</span>
        <span className="btn btn-link" onClick={onEdit}>
          <i className="fa fa-pencil"></i>
        </span>
      </li>
    );
  }
}
