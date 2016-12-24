import React, { Component } from "react";

export default class EditingDecisionBranchItem extends Component {
  constructor(props) {
    super(props);
    this.state = {
      value: props.decisionBranchModel.body,
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
          <span className="input-group-btn">
            <button className="btn btn-default" onClick={this.onSave.bind(this)}>保存</button>
            <button className="btn btn-link" onClick={this.onDelete.bind(this)}>削除</button>
          </span>
        </div>
      </li>
    );
  }

  onSave() {
    const { decisionBranchModel, isDisabled, onSave } = this.props;
    const { value } = this.state;
    if (isDisabled) { return; }
    onSave(decisionBranchModel, value);
  }

  onDelete() {
    const { onDelete, decisionBranchModel } = this.props;
    if (window.confirm("本当に削除してよろしいですか？この操作は取り消せません")) {
      onDelete(decisionBranchModel);
    }
  }
}
