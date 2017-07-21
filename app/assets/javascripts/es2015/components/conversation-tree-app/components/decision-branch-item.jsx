import React, { Component, PropTypes } from 'react';

import { decisionBranchType } from '../types';

class DecisionBranchItem extends Component {
  render() {
    const { decisionBranch, onClick } = this.props;

    return (
      <li
        className="list-group-item clearfix"
        key={decisionBranch.id}
        id={`decision-branch-item-${decisionBranch.id}`}
      >
        <span>{decisionBranch.body}</span>
        <span
          className="btn btn-link"
          onClick={onClick}
        >
          <i className="fa fa-pencil"></i>
        </span>
      </li>
    );
  }
}

DecisionBranchItem.propTypes = {
  decisionBranch: decisionBranchType,
  onClick: PropTypes.func.isRequired,
};

export default DecisionBranchItem;
