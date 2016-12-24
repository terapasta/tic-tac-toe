import React, { Component, PropTypes } from "react";
import TextArea from "react-textarea-autosize";
import get from "lodash/get";

import DecisionBranches from "./conversation-item-form/decision-branches";
import NewDecisionBranch from "./conversation-item-form/new-decision-branch";

export default class ConversationItemForm extends Component {
  static get componentName() {
    return "ConversationItemForm";
  }

  static get propTypes() {
    return {
      isProcessing: PropTypes.bool.isRequired,
      activeItem: PropTypes.shape({
        id: PropTypes.number,
        type: PropTypes.oneOf(["answer", "decisionBranch"]),
      }),
      editingAnswerModel: PropTypes.object,
      editingDecisionBranchModel: PropTypes.object,
      editingDecisionBranchModels: PropTypes.array,
      isAddingDecisionBranch: PropTypes.bool.isRequired,
      onSaveAnswer: PropTypes.func.isRequired,
      onDeleteAnswer: PropTypes.func.isRequired,
      onSaveDecisionBranch: PropTypes.func.isRequired,
      onEditDecisionBranch: PropTypes.func.isRequired,
      onAddingDecisionBranch: PropTypes.func.isRequired,
      onSaveNewDecisionBranch: PropTypes.func.isRequired,
    };
  }

  constructor(props) {
    super(props);
    this.state = {
      answerBody: null,
    };
  }

  componentWillReceiveProps(nextProps) {
    const { editingAnswerModel } = nextProps;
    if (editingAnswerModel != null) {
      this.setState({ answerBody: editingAnswerModel.body });
    }
  }

  render() {
    const {
      isProcessing,
      activeItem,
      editingAnswerModel,
      editingDecisionBranchModel,
      editingDecisionBranchModels,
      isAddingDecisionBranch,
      onSaveDecisionBranch,
      onEditDecisionBranch,
      onDeleteDecisionBranch,
      onAddingDecisionBranch,
      onCancelAddingDecisionBranch,
      onSaveNewDecisionBranch,
    } = this.props;

    const {
      answerBody,
    } = this.state;

    const isAppearCurrentDecisionBranch =
      get(activeItem, "dataType") === "decisionBranch" &&
      editingDecisionBranchModel != null;
    const isAppearNewDecisionBranch =
      get(activeItem, "dataType") === "answer";

    return (
      <div>
        {isAppearCurrentDecisionBranch && (
          <div className="form-group">
            <label>現在の選択肢</label>
            <input className="form-control" disabled={true} type="text" value={editingDecisionBranchModel.body} />
          </div>
        )}
        {(editingAnswerModel != null) && (
          <div className="form-group">
            <label>回答</label>
            <TextArea className="form-control"
              rows={3}
              value={answerBody || ""}
              onChange={this.onChangeAnswerBody.bind(this)}
              disabled={isProcessing} />
            <div className="help-block clearfix">
              <div className="pull-right">
                <a className="btn btn-primary" href="#"
                  onClick={this.onClickSaveAnswerButton.bind(this)}
                  disabled={isProcessing}>保存</a>
                <span className="btn btn-link" onClick={this.onClickDeleteAnswerButton.bind(this)}>削除</span>
              </div>
            </div>
          </div>
        )}
        <div className="form-group">
          <DecisionBranches
            isProcessing={isProcessing}
            decisionBranchModels={editingDecisionBranchModels}
            onSave={onSaveDecisionBranch}
            onEdit={onEditDecisionBranch}
            onDelete={(decisionBranchModel) => {
              onDeleteDecisionBranch(decisionBranchModel, editingAnswerModel.id);
            }}
          />
          {isAppearNewDecisionBranch && (
            <NewDecisionBranch
              isProcessing={isProcessing}
              isAdding={isAddingDecisionBranch}
              onSave={onSaveNewDecisionBranch}
              onAdding={onAddingDecisionBranch}
              onCancelAdding={onCancelAddingDecisionBranch}
            />
          )}
        </div>
      </div>
    );
  }

  onChangeAnswerBody(e) {
    this.setState({ answerBody: e.target.value });
  }

  onClickSaveAnswerButton(e) {
    e.preventDefault();
    const { onSaveAnswer, editingAnswerModel, editingDecisionBranchModel } = this.props;
    const { answerBody } = this.state;
    onSaveAnswer(editingAnswerModel, answerBody, get(editingDecisionBranchModel, "id"));
  }

  onClickDeleteAnswerButton() {
    const { onDeleteAnswer, editingAnswerModel, editingDecisionBranchModel } = this.props;
    if (window.confirm("本当に削除してよろしいですか？この操作は取り消せません")) {
      onDeleteAnswer(editingAnswerModel, get(editingDecisionBranchModel, "id"));
    }
  }
}
