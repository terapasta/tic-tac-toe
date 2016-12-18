import React, { Component, PropTypes } from "react";
import TextArea from "react-textarea-autosize";
import get from "lodash/get";
import isEqual from "lodash/isEqual";

import DecisionBranches from "./conversation-item-form/decision-branches";
import NewDecisionBranch from "./conversation-item-form/new-decision-branch";

import Answer from "../models/answer";
import DecisionBranch from "../models/decision-branch";

export default class ConversationItemForm extends Component {
  static get componentName() {
    return "ConversationItemForm";
  }

  static get propTypes() {
    return {
      botId: PropTypes.number.isRequired,
      activeItem: PropTypes.shape({
        id: PropTypes.number.isRequired,
        type: PropTypes.oneOf(["answer", "decisionBranch"]).isRequired,
      }),
      onUpdateDecisionBranch: PropTypes.func.isRequired,
      onUpdateAnswer: PropTypes.func.isRequired,
      isCreatingAnswer: PropTypes.bool.isRequired,
      onCreateAnswer: PropTypes.func.isRequired,
      onCreateDecisionBranch: PropTypes.func.isRequired,
    };
  }

  constructor(props) {
    super(props);
    this.state = {
      answerModel: null,
      answerBody: null,
      decisionBranchModels: [],
    };
  }

  componentWillReceiveProps(nextProps) {
    const { botId, activeItem } = nextProps;
    if (botId == null || activeItem == null) { return; }
    if (isEqual(this.props.activeItem, activeItem)) { return; }
    this.setState({ answerModel: null, decisionBranchModels: [], answerBody: null });

    switch (activeItem.type) {
      case "answer":
        Answer.fetch(botId, activeItem.id).then((answerModel) => {
          this.setState({ answerModel, answerBody: answerModel.body });
          answerModel.fetchDecisionBranches().then(() => {
            const { decisionBranchModels } = answerModel;
            this.setState({ decisionBranchModels });
          });
        });
        break;
      case "decisionBranch":
        DecisionBranch.fetch(botId, activeItem.id).then((decisionBranchModel) => {
          this.setState({ decisionBranchModel });
          decisionBranchModel.fetchNextAnswer().then(() => {
            const { nextAnswerModel } = decisionBranchModel;
            this.setState({ answerModel: nextAnswerModel, answerBody: nextAnswerModel.body });
          });
        });
        break;
    }
  }

  render() {
    const {
      activeItem,
      isCreatingAnswer,
    } = this.props;

    const {
      answerModel,
      answerBody,
      decisionBranchModels,
      decisionBranchModel,
    } = this.state;

    const isAppearCurrentDecisionBranch =
      get(activeItem, "type") === "decisionBranch" &&
      decisionBranchModel != null;
    const isAppearNewDecisionBranch =
      get(activeItem, "type") === "answer";

    return (
      <div>
        {isAppearCurrentDecisionBranch && (
          <div className="form-group">
            <label>現在の選択肢</label>
            <input className="form-control" disabled={true} type="text" value={decisionBranchModel.body} />
          </div>
        )}
        {(answerModel != null || isCreatingAnswer) && (
          <div className="form-group">
            <label>回答</label>
            <TextArea className="form-control" rows={3} value={answerBody || ""} onChange={this.onChangeAnswerBody.bind(this)} />
            <div className="help-block clearfix">
              <div className="pull-right">
                <a className="btn btn-primary" href="#" onClick={this.onClickSaveAnswerButton.bind(this)}>保存</a>
              </div>
            </div>
          </div>
        )}
        <div className="form-group">
          <DecisionBranches
            decisionBranchModels={decisionBranchModels}
            onUpdate={this.onUpdateDecisionBranch.bind(this)}
          />
          {isAppearNewDecisionBranch && (
            <NewDecisionBranch
              onSave={this.onSaveDecisionBranch.bind(this)}
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
    const { onUpdateAnswer, onCreateAnswer, botId } = this.props;
    const { answerModel, answerBody } = this.state;
    if (answerModel == null) {
      Answer.create(botId, { body: answerBody }).then((newAnswerModel) => {
        this.setState({ answerModel: newAnswerModel, answerBody: newAnswerModel.body });
        onCreateAnswer(newAnswerModel);
      }).catch(console.error);
    } else {
      answerModel.update({ body: answerBody }).then((newAnswerModel) => {
        this.setState({ answerModel: newAnswerModel, answerBody: newAnswerModel.body });
        onUpdateAnswer(newAnswerModel);
      }).catch(console.error);
    }
  }

  onUpdateDecisionBranch(decisionBranchModel, index) {
    const { onUpdateDecisionBranch } = this.props;
    const { decisionBranchModels } = this.state;
    decisionBranchModels[index] = decisionBranchModel;
    this.setState({ decisionBranchModels });
    onUpdateDecisionBranch(decisionBranchModel);
  }

  onSaveDecisionBranch(body) {
    const { onCreateDecisionBranch, botId } = this.props;
    const { decisionBranchModels, answerModel } = this.state;
    DecisionBranch.create(botId, {
      answer_id: answerModel.id,
      body,
    }).then((newDecisionBranchModel) => {
      decisionBranchModels.push(newDecisionBranchModel);
      this.setState({
        decisionBranchModels,
      });
      onCreateDecisionBranch(answerModel.id, newDecisionBranchModel);
    }).catch(console.error);
  }
}
