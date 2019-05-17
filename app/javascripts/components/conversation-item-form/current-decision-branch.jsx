import React, { Component, PropTypes } from "react";
import get from "lodash/get";

import DecisionBranchModel from "../../models/decision-branch";

class CurrentDecisionBranch extends Component {
  render() {
    const {
      activeItem,
      editingDecisionBranchModel,
    } = this.props;

    const dataType = get(activeItem, "dataType");

    if (dataType != "decisionBranch" || editingDecisionBranchModel == null) {
      return null;
    }

    return (
      <div className="form-group">
        <label>現在の選択肢</label>
        <input className="form-control" disabled={true} type="text" value={editingDecisionBranchModel.body} />
      </div>
    );
  }
}

CurrentDecisionBranch.propTypes = {
  activeItem: PropTypes.shape({
    dataType: PropTypes.string,
    type: PropTypes.oneOf(["answer", "decisionBranch", "question"]),
  }),
  editingDecisionBranchModel: PropTypes.instanceOf(DecisionBranchModel),
};

export default CurrentDecisionBranch;
