import React, { Component, PropTypes } from "react";
import TextArea from "react-textarea-autosize";
import get from "lodash/get";
import flatten from "lodash/flatten";
import axios from "axios";
import Promise from "promise";
import isEmpty from "is-empty";

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
      trainingMessages: [],
    };
  }

  // TODO: reduxでtrainingMessagesを管理するように変更が必須
  componentWillReceiveProps(nextProps) {
    const { editingAnswerModel, botId } = nextProps;
    if (editingAnswerModel != null) {
      this.setState({ answerBody: editingAnswerModel.body });

      if (editingAnswerModel.id == null) {
        this.setState({ trainingMessages: [] });
      }

      const answerId = get(this.props, "editingAnswerModel.id");
      if (botId != null && editingAnswerModel.id != answerId) {
        this.fetchTrainingMessages(botId, editingAnswerModel.id)
          .then((messagesList) => {
            const trainingMessages = flatten(messagesList.map((ms) => ms.map((m) => m.body || m.question)));
            this.setState({ trainingMessages });
          })
          .catch(console.error);
      }
    } else {
      this.setState({ trainingMessages: [] });
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
      get(activeItem, "dataType") === "answer" && get(editingAnswerModel, "id") != null;

    return (
      <div>
        {this.renderTrainingMessages()}
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
                {" "}
                <span className="btn btn-danger" onClick={this.onClickDeleteAnswerButton.bind(this)}>削除</span>
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

  renderTrainingMessages() {
    const { trainingMessages } = this.state;
    if (isEmpty(trainingMessages)) { return null; }

    return (
      <div>
        <strong>対応する質問</strong>
        <ul>
          {trainingMessages.map((tm, index) => <li key={index}>{tm}</li>)}
        </ul>
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

  fetchTrainingMessages(botId, answerId) {
    const trainingMessagesPromise = axios.get(`/bots/${botId}/answers/${answerId}/training_messages.json`).then((res) => res.data);
    const importedTrainingMessagesProimse = axios.get(`/bots/${botId}/answers/${answerId}/imported_training_messages.json`).then((res) => res.data);
    return Promise.all([trainingMessagesPromise, importedTrainingMessagesProimse]);
  }
}
