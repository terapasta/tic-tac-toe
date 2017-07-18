import React, { Component, PropTypes } from 'react';
import TextArea from 'react-textarea-autosize';

import {
  activeItemType,
  decisionBranchesRepoType,
} from '../types';

class DecisionBranchForm extends Component {
  render() {
    const { activeItem, decisionBranchesRepo } = this.props;
    const decisionBranch = decisionBranchesRepo[activeItem.node.id];

    return (
      <div>
        <div className="form-group">
          <label>現在の選択肢</label>
          <input
            type="text"
            className="form-control"
            disabled
            defaultValue={decisionBranch.body}
          />
        </div>
        <div className="form-group">
          <label><i className="material-icons" title="質問">chat_bubble_outline</i> 回答</label>
          <TextArea
            className="form-control"
            defaultValue={decisionBranch.answer}
            rows={3}
          />
        </div>
      </div>
    );
  }
}

DecisionBranchForm.propTypes = {
  activeItem: activeItemType.isRequired,
  decisionBranchesRepo: decisionBranchesRepoType.isRequired,
};

export default DecisionBranchForm;
