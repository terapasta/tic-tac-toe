import React, { Component, PropTypes } from "react";
import TextArea from "react-textarea-autosize";
import { RadioGroup, Radio } from "react-radio-group";
import isEmpty from "is-empty";
import axios from "axios";
import debounce from "lodash/debounce";
import get from "lodash/get";
import trim from "lodash/trim";
import includes from "lodash/includes";

import Panel from "./panel";
import Question from "../models/question";
import jump from "../modules/jump";

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
      topicTags: PropTypes.array.isRequired,
    };
  }

  constructor(props) {
    super(props);
    this.state = {
      questionBody: "",
      answerBody: "",
      answerId: null,
      answerMode: AnswerMode.Input,
      searchingAnswerQuery: "",
      searchingAnswerPage: 1,
      hasNextPage: true,
      candidateAnswers: [],
      selectedAnswer: null,
      isProcessing: false,
      persistedAnswerId: null,
      errors: [],
      selectedTopicTags: [],
    };
    this.debouncedSearchAnswers = debounce(this.searchAnswers, 250);
  }

  componentDidMount() {
    const {
      questionBody
    } = this.props;

    this.setState({ questionBody: questionBody });
    this.fetchQuestionAnswer();
  }

  render() {
    const {
      id,
      topicTags,
    } = this.props;

    const {
      questionBody,
      answerBody,
      answerId,
      answerMode,
      searchingAnswerQuery,
      searchingAnswerPage,
      hasNextPage,
      candidateAnswers,
      selectedAnswer,
      isProcessing,
      errors,
      selectedTopicTags,
    } = this.state;

    const title = `Q&A${isEmpty(id) ? "新規登録" : "編集"}`;
    const hasPersistedAnswer = !isEmpty(id) && !isEmpty(answerBody);
    const inputAnswerLabel = hasPersistedAnswer ?
      "回答を編集" : "新しく回答を入力";

    return (
      <Panel title={title}>
        {!isEmpty(errors) && (
          <div className="alert alert-danger">
            <ul>
              {errors.map((e, i) => (
                <li key={i}>{e}</li>
              ))}
            </ul>
          </div>
        )}
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
              {" "}{inputAnswerLabel}
            </label>
            <label className="checkbox-inline">
              <Radio value={AnswerMode.Select} disabled={isProcessing} />
              {" "}既存の回答を選択
            </label>
          </RadioGroup>
        </div>
        {answerMode === AnswerMode.Input && (
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
          {!isEmpty(candidateAnswers) && (
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
              {hasNextPage && (
                <div className="form-group">
                  <a href="#" id="load-more" className="btn btn-default" disabled={isProcessing} onClick={this.onClickLoadMore.bind(this)}>
                    {isProcessing ? "読み込み中..." : "更に読み込む"}
                  </a>
                </div>
              )}
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
          <label>Q&amp;Aトピックタグ</label>
          {isEmpty(topicTags) && (
            <p>Q&amp;Aトピックタグはありません</p>
          )}
          {topicTags.map((t, i) => (
            <div key={i}>
              <label>
                <input type="checkbox"
                  value={t[0]}
                  disabled={isProcessing}
                  onChange={this.onChangeTopicTag.bind(this, t)}
                  checked={includes(selectedTopicTags.map((t) => t[0]), t[0])}/>
                {" "}
                {t[1]}
              </label>
            </div>
          ))}
          {selectedTopicTags.map((t, i) => (
            <input type="hidden" key={i} name={`question_answer[topic_taggings_attributes][${i}][topic_tag_id]`} value={t[0]} />
          ))}
        </div>
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
        <p>{a.body}</p>
        <div className="text-muted">
          <small>ID: {a.id} / 登録日時: {a.created_at}</small>
        </div>
      </span>
    );
  }

  fetchQuestionAnswer() {
    const { botId, id } = this.props;
    if (isEmpty(botId) || isEmpty(id)) { return; }
    if (this.state.isProcessing) { return; }
    this.setState({ isProcessing: true });

    return Question.fetch(botId, id).then((questionModel) => {
      this.setState({ questionBody: questionModel.question });

      return questionModel.fetchAnswer().then(() => {
        const { body, id } = questionModel.answer;
        const selectedTopicTags = questionModel.topicTags.map((t) => [t.id, t.name]);
        this.setState({
          answerBody: body,
          persistedAnswerId: id,
          isProcessing: false,
          selectedTopicTags,
        });
      });
    }).catch((err) => {
      console.error(err);
      this.setState({ isProcessing: false });
    });
  }

  searchAnswers() {
    const { botId } = this.props;
    const { searchingAnswerQuery, searchingAnswerPage } = this.state;
    const params = {
      "q[body_cont]": trim(searchingAnswerQuery),
      page: searchingAnswerPage,
    };

    return axios.get(`/bots/${botId}/answers.json`, { params }).then((res) => {
      const newSearchingAnswerPage = res.data.length > 0 ?
        searchingAnswerPage + 1 : searchingAnswerPage;
      const hasNextPage = res.data.length > 0;
      const newCandidateAnswers = searchingAnswerPage === 1 ? res.data : this.state.candidateAnswers.concat(res.data);

      this.setState({
        candidateAnswers: newCandidateAnswers,
        searchingAnswerPage: newSearchingAnswerPage,
        hasNextPage,
      });
    }).catch((err) => {
      console.error(err);
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
        jump.to(questionModel.editPath);
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
      id
    } = this.props;

    const {
      answerMode,
      answerBody,
      selectedAnswer,
      questionBody,
      persistedAnswerId,
      selectedTopicTags,
    } = this.state;

    let errors = [];
    let payload = {
      question: questionBody,
      topic_taggings_attributes: selectedTopicTags.map((t) => ({
        topic_tag_id: t[0],
      })),
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
          };
          if (!isEmpty(persistedAnswerId)) {
            payload.answer_attributes.id = persistedAnswerId;
          }
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

    this.setState({ errors });

    if (errors.length === 0) {
      this.saveQuestionAnswer(payload);
    }
  }

  onClickLoadMore(e) {
    e.preventDefault();
    this.searchAnswers();
  }

  onChangeTopicTag(topicTag, e) {
    const { selectedTopicTags } = this.state;
    let newSelectedTopicTags;

    if (e.target.checked) {
      newSelectedTopicTags = selectedTopicTags.concat([topicTag]);
    } else {
      newSelectedTopicTags = selectedTopicTags.filter((t) => t[0] != topicTag[0]);
    }
    this.setState({ selectedTopicTags: newSelectedTopicTags });
  }
}
