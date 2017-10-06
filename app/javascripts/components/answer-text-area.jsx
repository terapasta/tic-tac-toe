import React, { Component, PropTypes } from "react";
import debounce from "lodash/debounce";
import isEmpty from "is-empty";
import styled from 'styled-components';
import uuid from 'uuid/v4';

import * as QuestionAnswerAPI from "../api/question-answer";
import Panel from "./panel";

const SuggestWrapper = styled.div.attrs({
  className: 'card'
})`
  overflow-y: auto;
  position: absolute;
  top: calc(100% - 1px);
  left: 0;
  right: 0;
  z-index: 10;
  max-height: 200px;
  box-shadow: 0 2px 5px rgba(0,0,0,.2);
  border-radius: 0 0 0.25rem 0.25rem;
`;

const SuggestItem = styled.div`
  cursor: pointer;
  display: block;
  padding: 16px;
  border-top: 1px solid #ccc;

  &:hover {
    background-color: #efefef;
  }
`;

export default class AnswerTextArea extends Component {
  static get componentName() {
    return "AnswerTextArea";
  }

  static get propTypes() {
    return {
      baseName: PropTypes.string.isRequired,
      defaultValue: PropTypes.string,
      botId: PropTypes.number.isRequired,
    };
  }

  constructor(props) {
    super(props);
    this.state = {
      text: props.defaultValue || "",
      answers: [],
    };

    this.onChangeTextArea = this.onChangeTextArea.bind(this);
    this.debouncedSearchAnswers = debounce(this.searchAnswers.bind(this), 250);
  }

  render() {
    const { baseName, botId } = this.props;
    const { text, answers } = this.state;

    return (
      <div className="form-group" style={{ position: 'relative' }}>
        <label>回答</label>
        <textArea className="form-control"
          rows={5}
          onChange={this.onChangeTextArea}
          value={text}
          name={`${baseName}[answer]`}
        />
        {!isEmpty(text) && <input type="hidden" name={`${baseName}[bot_id]`} value={botId} />}
        {!isEmpty(answers) && (
          <SuggestWrapper>
            <label className="m-3">回答の候補</label>
            {answers.map((answer) => {
              return (
                <SuggestItem key={uuid()} onClick={this.onClickAnswer.bind(this, answer)}>{answer}</SuggestItem>
              );
            })}
          </SuggestWrapper>
        )}
      </div>
    );
  }

  onChangeTextArea(e) {
    const { value } = e.target;
    this.setState({ text: value });
    if (!isEmpty(value)) {
      this.debouncedSearchAnswers(value);
    } else {
      this.setState({ answers: [] });
    }
  }

  onClickAnswer(text) {
    this.setState({ text, answers: [] });
  }

  searchAnswers(text) {
    const { botId } = this.props;
    QuestionAnswerAPI.findAll(botId, { q: text }).then((res) => {
      this.setState({ answers: res.data.questionAnswers.map(qa => qa.answer) });
    }).catch((err) => {
      console.error(err);
    });
  }
}
