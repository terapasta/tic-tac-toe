import React, { Component } from "react";

class EditingDecisionBranchItem extends Component {
  constructor(props) {
    super(props);
    this.state = {
      value: props.decisionBranchModel.body,
      enterPressed: false,
    };
  }

  render() {
    const { isDisabled } = this.props;
    const { value } = this.state;

    return (
      <li className="list-group-item clearfix">
        <div className="input-group">
          <input className="form-control" type="text"
            value={value}
            onChange={(e) => this.setState({ value: e.target.value })}
            disabled={isDisabled}
          />
          <span className="input-group-btn" onClick={this.onSave.bind(this)}>
            <button className="btn btn-default">保存</button>
          </span>
        </div>
      </li>
    );
  }

  onSave() {
    const { index, isDisabled, onSave } = this.props;
    const { value } = this.state;
    if (isDisabled) { return; }
    onSave(index, value);
  }
}
