import React, { Component } from 'react'
import PropTypes from 'prop-types'

import { decisionBranchType } from '../types'

class DecisionBranchItem extends Component {
  render() {
    const { decisionBranch, onClick } = this.props

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
          <i className="material-icons mi-xs">edit</i>
        </span>
      </li>
    );
  }
}

DecisionBranchItem.propTypes = {
  decisionBranch: decisionBranchType,
  onClick: PropTypes.func.isRequired,
}

export default DecisionBranchItem
