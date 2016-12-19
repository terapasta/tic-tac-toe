import React, { Component, PropTypes } from "react";

export default class NewDecisionBranch extends Component {
  static get componentName() {
    return "NewDecisionBranch";
  }

  static get propTypes() {
    return {
    };
  }

  constructor(props) {
    super(props);
    this.state = {
      isAdding: false,
      isProcessing: false,
      value: "",
    };
  }

  render() {
    const {
      isAdding,
      isProcessing,
      value,
    } = this.state;

    return (
      <div>
        {!isAdding && (
          <div className="nav nav-pills nav-stacked">
            <li className="hover-gray">
              <a href="#" onClick={this.onClickAddingButton.bind(this)}>
                ＋選択肢を追加する
              </a>
            </li>
          </div>
        )}
        {isAdding && (
          <div>
            <input className="form-control" placeholder="新しい選択肢を入力" value={value} onChange={this.onChangeValue.bind(this)} />
            <div className="clearfix padding-top-8">
              <div className="pull-left">
                <a className="btn btn-link" href="#" onClick={this.onClickCancelButton.bind(this)}>
                  キャンセル
                </a>
              </div>
              <div className="pull-right">
                <a className="btn btn-primary" href="#" disabled={isProcessing}>
                  追加
                </a>
              </div>
            </div>
          </div>
        )}
      </div>
    );
  }

  onClickAddingButton(e) {
    e.preventDefault();
    this.setState({ isAdding: true });
  }

  onClickCancelButton(e) {
    e.preventDefault();
    this.setState({ isAdding: false });
  }

  onChangeValue(e) {
    const { value } = e.target;
    this.setState({ value });
  }
}
