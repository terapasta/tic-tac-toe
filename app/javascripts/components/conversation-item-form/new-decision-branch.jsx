import React, { Component, PropTypes } from "react";
import get from "lodash/get";

export default class NewDecisionBranch extends Component {
  static get componentName() {
    return "NewDecisionBranch";
  }

  static get propTypes() {
    return {
      isProcessing: PropTypes.bool.isRequired,
      isAdding: PropTypes.bool.isRequired,
      onSave: PropTypes.func.isRequired,
      onAdding: PropTypes.func.isRequired,
      onCancelAdding: PropTypes.func.isRequired,
    };
  }

  constructor(props) {
    super(props);
    this.state = {
      value: "",
    };
  }

  render() {
    const {
      activeItem,
      editingAnswerModel,
      isAdding,
      isProcessing,
      onSave,
      onAdding,
      onCancelAdding,
    } = this.props;

    const {
      value,
    } = this.state;

    if (get(activeItem, "dataType") != "answer" ||
        get(editingAnswerModel, "id") == null ) {
      return null;
    }

    return (
      <div>
        {!isAdding && (
          <div className="nav nav-pills nav-stacked">
            <li className="hover-gray">
              <span className="btn btn-link" onClick={onAdding} id="add-decision-branch-button">
                ＋選択肢を追加する
              </span>
            </li>
          </div>
        )}
        {isAdding && (
          <div>
            <input className="form-control" placeholder="新しい選択肢を入力" value={value} onChange={this.onChangeValue.bind(this)} disabled={isProcessing} name="decision-branch-body" />
            <div className="clearfix padding-top-8">
              <div className="pull-left">
                <span className="btn btn-link" onClick={onCancelAdding} disabled={isProcessing}>
                  キャンセル
                </span>
              </div>
              <div className="pull-right">
                <span className="btn btn-primary" disabled={isProcessing} onClick={() => {
                    onSave(value);
                    this.setState({ value: "" });
                  }}>
                  追加
                </span>
              </div>
            </div>
          </div>
        )}
      </div>
    );
  }

  onChangeValue(e) {
    const { value } = e.target;
    this.setState({ value });
  }
}
