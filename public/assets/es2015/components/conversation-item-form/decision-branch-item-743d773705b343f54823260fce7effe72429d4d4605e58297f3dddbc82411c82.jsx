import React from "react";

export default function DecisionBranchItem(props) {
  const { decisionBranchModel, onEdit } = props;
  return (
    <li className="list-group-item clearfix">
      <span>{decisionBranchModel.body}</span>
      <span className="btn btn-link" onClick={onEdit}>
        <i className="fa fa-pencil"></i>
      </span>
    </li>
  );
}
