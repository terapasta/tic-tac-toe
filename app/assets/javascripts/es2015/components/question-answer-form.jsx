import React, { Component, PropTypes } from "react";
import TextArea from "react-textarea-autosize";
import { RadioGroup, Radio } from "react-radio-group";
import isEmpty from "is-empty";
import axios from "axios";
import debounce from "lodash/debounce";
import get from "lodash/get";
import trim from "lodash/trim";

import Panel from "./panel";
import Question from "../models/question";

export const AnswerMode = {
  Input: "input",
  Select: "select",
};

export default class QuestionAnswerForm extends Component {
  static get componentName() {
    return "QuestionAnswerForm";
  }

  static get propTypes() {
    return {
      botId: PropTypes.number.isRequired,
      id: PropTypes.number,
    };
  }

  constructor(props) {
    super(props);
    this.state = {
      questionBody: "",
      answerHeadline: "",
      answerBody: "",
      answerId: null,
      answerMode: AnswerMode.Input,
      searchingAnswerQuery: "",
      searchingAnswerPage: 1,
      candidateAnswers: [],
      selectedAnswer: null,
      isProcessing: false,
    };
    this.debouncedSearchAnswers = debounce(this.searchAnswers, 250);
  }

  componentDidMount() {
    this.fetchQuestionAnswer();
  }

  render() {
    const {
      questionBody,
      answerHeadline,
      answerBody,
      answerId,
      answerMode,
      searchingAnswerQuery,
      candidateAnswers,
      selectedAnswer,
      isProcessing,
    } = this.state;

    return (
      <Panel title="Q&A">
        <div className="form-group">
          <label htmlFor="question-body">質問</label>
          <TextArea
            {...{
              id: "question-body",
              value: questionBody,
              className: "form-control",
              rows: 3,
              onChange: this.onChangeQuestionBody.bind(this),
              placeholder: "質問を入力してください（例：カードキー無くしてしまったのですが、どうすればいいですか）",
              disabled: isProcessing,
            }}
          />
        </div>
        <div className="form-group">
          <RadioGroup {...{
            id: "answer-mode",
            name: "answer-mode",
            selectedValue: answerMode,
            onChange: this.onChangeAnswerMode.bind(this),
          }}>
            <label>回答</label>
            <label className="checkbox-inline">
              <Radio value={AnswerMode.Input} disabled={isProcessing} />
              {" "}新しく回答を入力
            </label>
            <label className="checkbox-inline">
              <Radio value={AnswerMode.Select} disabled={isProcessing} />
              {" "}既存の回答を選択
            </label>
          </RadioGroup>
        </div>
        {answerMode === AnswerMode.Input && (
          <div>
            <div className="form-group">
              <input
                {...{
                  id: "answer-headline",
                  value: answerHeadline,
                  name: "question_answer[answer_attributes][headline]",
                  className: "form-control",
                  onChange: this.onChangeAnswerHeadline.bind(this),
                  placeholder: "回答の見出しを入力してください（例：紛失物について）",
                  disabled: isProcessing,
                }}
              />
            </div>
            <div className="form-group">
              <TextArea
                {...{
                  id: "answer-body",
                  value: answerBody,
                  name: "question_answer[answer_attributes][body]",
                  className: "form-control",
                  rows: 3,
                  onChange: this.onChangeAnswerBody.bind(this),
                  placeholder: "回答を入力してください（例：カードキーの再発行手続きを行ってください。申込書はこちら http://example.com/...）",
                  disabled: isProcessing,
                }}
              />
            </div>
          </div>
        )}
        {answerMode === AnswerMode.Select && (
          <div className="form-group">
            <input
              {...{
                type: "search",
                id: "answer-search",
                className: "form-control",
                placeholder: "既存の回答に含まれる文字列を入力してください",
                value: searchingAnswerQuery,
                onChange: this.onChangeSearchAnswer.bind(this),
                disabled: isProcessing,
              }}
            />
          {isProcessing && <div className="well">検索中...</div>}
          {!isProcessing && !isEmpty(candidateAnswers) && (
            <div className="well" id="candidate-answers">
              {candidateAnswers.map((a, i) => {
                return (
                  <Panel {...{
                    key: i,
                    isClickable: true,
                    onClickBody: this.onClickCandidateAnswer.bind(this, a),
                    id: `candidate-answer-${a.id}`,
                  }}>
                    {this.renderAnswer(a)}
                  </Panel>
                );
              })}
            </div>
          )}
          {!isEmpty(selectedAnswer) && (
            <div className="well">
              <label>
                選択した回答{" "}
                <a {...{
                  href: "#",
                  className: "btn btn-warning btn-sm",
                  onClick: this.onClickRejectAnswer.bind(this),
                  id: "reject-answer",
                }}>&times; 選択を解除</a>
              </label>
              <Panel>{this.renderAnswer(selectedAnswer)}</Panel>
            </div>
          )}
          </div>
        )}
        <div className="form-group">
          <input
            {...{
              type: "submit",
              className: "btn btn-primary",
              value: "登録",
              onClick: this.onClickSubmitButton.bind(this),
              disabled: isProcessing,
            }}
          />
        </div>
      </Panel>
    );
  }

  renderAnswer(a) {
    return (
      <span>
        <p>
          {!isEmpty(a.headline) && (
            <div style={{paddingBottom: "10px"}}>
              <small>見出し：{a.headline}</small>
              <br />
            </div>
          )}
          {a.body}
        </p>
        <div className="text-muted">
          <small>ID: {a.id} / 登録日時: {a.created_at}</small>
        </div>
      </span>
    );
  }

  fetchQuestionAnswer() {
    const { botId, id } = this.props;
    if (isEmpty(botId) || isEmpty(id)) { return; }

    Question.fetch(botId, id).then((questionModel) => {
      console.log(questionModel);
    });
  }

  searchAnswers() {
    if (this.state.isProcessing) { return; }
    this.setState({ isProcessing: true });

    const { botId } = this.props;
    const { searchingAnswerQuery, searchingAnswerPage } = this.state;
    const params = {
      "q[body_or_headline_cont]": trim(searchingAnswerQuery),
      page: searchingAnswerPage,
    };

    return axios.get(`/bots/${botId}/answers.json`, { params }).then((res) => {
      const newSearchingAnswerPage = res.data.length > 0 ?
        searchingAnswerPage + 1 : searchingAnswerPage;

      this.setState({
        isProcessing: false,
        candidateAnswers: res.data,
        searchingAnswerPage: newSearchingAnswerPage,
      });
    }).catch((err) => {
      console.error(err);
      this.setState({ isProcessing: false });
    });
  }

  saveQuestionAnswer(payload) {
    if (this.state.isProcessing) { return; }
    this.setState({ isProcessing: true });

    const { botId, id } = this.props;
    let promise;

    if (isEmpty(id)) {
      promise = Question.create(botId, payload)
    } else {
      promise = (new Question({ botId, id })).update(payload);
    }

    return promise
      .then((questionModel) => {
        console.log(questionModel);
        this.setState({ isProcessing: false });
      }).catch((err) => {
        console.error(err);
        this.setState({ isProcessing: false });
      });
  }

  onChangeQuestionBody(e) {
    this.setState({ questionBody: e.target.value });
  }

  onChangeAnswerMode(answerMode) {
    this.setState({ answerMode });
  }

  onChangeAnswerHeadline(e) {
    this.setState({ answerHeadline: e.target.value });
  }

  onChangeAnswerBody(e) {
    this.setState({ answerBody: e.target.value });
  }

  onChangeSearchAnswer(e) {
    const { value } = e.target;
    const val = trim(value);
    this.setState({ searchingAnswerQuery: value });
    if (!isEmpty(val)) {
      this.setState({ searchingAnswerPage: 1 });
      this.debouncedSearchAnswers();
    } else {
      this.setState({ candidateAnswers: [] });
    }
  }

  onClickCandidateAnswer(selectedAnswer, e) {
    e.preventDefault();
    this.setState({
      selectedAnswer,
      candidateAnswers: [],
      searchingAnswerQuery: "",
    });
  }

  onClickRejectAnswer(e) {
    e.preventDefault();
    this.setState({
      selectedAnswer: null,
    })
  }

  onClickSubmitButton() {
    const {
      answerMode,
      answerBody,
      answerHeadline,
      selectedAnswer,
      questionBody
    } = this.state;

    let errors = [];
    let payload = {
      question: questionBody,
    };

    if (isEmpty(questionBody)) {
      errors.push("質問を入力してください");
    }

    switch(answerMode) {
      case AnswerMode.Input:
        if (isEmpty(answerBody)) {
          errors.push("回答を入力してください");
        } else {
          payload.answer_attributes = {
            body: answerBody,
            headline: answerHeadline,
          };
        }
        break;
      case AnswerMode.Select:
        if (isEmpty(selectedAnswer)) {
          errors.push("回答を選択してください");
        } else {
          payload.answer_id = selectedAnswer.id;
        }
        break;
    }

    if (errors.length === 0) {
      this.saveQuestionAnswer(payload);
    } else {
      window.alert(errors.join(", "));
    }
  }
}
