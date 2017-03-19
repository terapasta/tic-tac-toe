import React, { Component, PropTypes } from "react";
import get from "lodash/get";
import flatten from "lodash/flatten";
import axios from "axios";
import Promise from "promise";
import isEmpty from "is-empty";

import CurrentDecisionBranch from "./conversation-item-form/current-decision-branch";
import DecisionBranches from "./conversation-item-form/decision-branches";
import NewDecisionBranch from "./conversation-item-form/new-decision-branch";
import QuestionForm from "./conversation-item-form/question-form";
import ReferenceQuestions from "./conversation-item-form/reference-questions";
import AnswerForm from "./conversation-item-form/answer-form";

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
      editingQuestionModel: PropTypes.object,
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
      question: null,
      trainingMessages: [],
    };
  }

  // TODO: reduxでtrainingMessagesを管理するように変更が必須
  componentWillReceiveProps(nextProps) {
    const {
      editingAnswerModel,
      editingQuestionModel,
    } = nextProps;

    this.setState({
      question: get(editingQuestionModel, "question", ""),
      answerBody: get(editingAnswerModel, "body", ""),
    });
  }

  render() {
    const {
      isProcessing,
      activeItem,
      editingQuestionModel,
      editingAnswerModel,
      editingDecisionBranchModel,
      editingDecisionBranchModels,
      referenceQuestionModels,
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
      question,
    } = this.state;

    return (
      <div>
        <ReferenceQuestions {...{ referenceQuestionModels }} />
        <CurrentDecisionBranch {...{ activeItem, editingDecisionBranchModel }} />
        <QuestionForm
          {...{
            editingQuestionModel,
            isProcessing,
            answerBody,
            question,
            onChangeQuestion: this.onChangeQuestion.bind(this),
            onChangeAnswerBody: this.onChangeAnswerBody.bind(this),
            onClickSaveQuestionButton: this.onClickSaveQuestionButton.bind(this),
            onClickDeleteQuestionButton: this.onClickDeleteQuestionButton.bind(this),
          }}
        />
        <AnswerForm
          {...{
            isProcessing,
            activeItem,
            editingAnswerModel,
            answerBody,
            onChange: this.onChangeAnswerBody.bind(this),
            onSave: this.onClickSaveAnswerButton.bind(this),
            onDelete: this.onClickDeleteAnswerButton.bind(this),
          }}
        />
        <div className="form-group">
          <DecisionBranches
            {...{
              isProcessing,
              decisionBranchModels: editingDecisionBranchModels,
              onSave: onSaveDecisionBranch,
              onEdit: onEditDecisionBranch,
              onDelete(decisionBranchModel) {
                onDeleteDecisionBranch(decisionBranchModel, editingAnswerModel.id);
              },
            }}
          />
          <NewDecisionBranch
            {...{
              activeItem,
              editingAnswerModel,
              isProcessing,
              isAdding: isAddingDecisionBranch,
              onSave: onSaveNewDecisionBranch,
              onAdding: onAddingDecisionBranch,
              onCancelAdding: onCancelAddingDecisionBranch,
            }}
          />
        </div>
      </div>
    );
  }

  onChangeQuestion(e) {
    this.setState({ question: e.target.value });
  }

  onChangeAnswerBody(e) {
    this.setState({ answerBody: e.target.value });
  }

  onClickSaveQuestionButton(e) {
    e.preventDefault();
    const { onSaveQuestion, editingQuestionModel, editingAnswerModel } = this.props;
    const { question, answerBody } = this.state;
    onSaveQuestion(editingQuestionModel, question, editingAnswerModel, answerBody);
  }

  onClickDeleteQuestionButton() {
    const { onDeleteQuestion, editingQuestionModel } = this.props;
    if (window.confirm("本当に削除してよろしいですか？この操作は取り消せません")) {
      onDeleteQuestion(editingQuestionModel);
    }
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
    const QuestionAnswersProimse = axios.get(`/bots/${botId}/answers/${answerId}/question_answers.json`).then((res) => res.data);
    return Promise.all([trainingMessagesPromise, QuestionAnswersProimse]);
  }
}
