import React, { Component, PropTypes } from "react";
import { findDOMNode } from "react-dom";
import TextArea from "react-textarea-autosize";
import classNames from "classnames";
import isEmpty from 'is-empty';
import debounce from 'lodash/debounce';

import PreventWheelScrollOfParent from '../prevent-wheel-scroll-of-parent';
import * as AnswerAPI from '../../api/answer';

class ChatBotMessageEditor extends Component {
  constructor(props) {
    super(props);
    this.state = {
      searchedAnswers: [],
    };

    this.searchAnswerIfNeeded = debounce(this.searchAnswerIfNeeded, 250);
  }

  render() {
    const {
      body,
      iconImageUrl,
      learning: {
        questionId,
        answerId,
        answerBody,
        isDisabled,
      },
      onChangeLearning,
    } = this.props;

    const {
      searchedAnswers,
    } = this.state;

    const iconStyle = {
      backgroundImage: `url(${iconImageUrl})`,
    };

    return (
      <div className="chat-message">
        <div className="chat-message__icon" style={iconStyle} />
        <div className="chat-message__balloon has-part-label" disabled={true}>
          {body}
        </div>
        <div className="chat-message__textarea has-part-label">
          <div className="chat-message__part-label">新しい回答</div>
          <TextArea
            className="form-control"
            name="chat-bot-message-body"
            rows={1}
            value={answerBody}
            onChange={(e) => {
              onChangeLearning({
                questionId,
                answerId,
                answerBody: e.target.value,
              });
              this.searchAnswerIfNeeded(e.target.value);
            }}
            disabled={isDisabled}
          />
          {!isEmpty(searchedAnswers) && (
            <PreventWheelScrollOfParent className="chat-message__suggestions">
              {searchedAnswers.map((a) => (
                <div className="panel panel-default stacked-close" key={a.id}>
                  <a href="#" className="panel-body" onClick={(e) => this.selectAnswer(a, e)}>
                    {a.body}
                  </a>
                </div>
              ))}
            </PreventWheelScrollOfParent>
          )}
        </div>
      </div>
    );
  }

  searchAnswerIfNeeded(text) {
    if (isEmpty(text)) { return this.setState({ searchedAnswers: [] }); }
    AnswerAPI.findAll(window.currentBot.id, { q: text }).then((res) => {
      const searchedAnswers = res.data.answers;
      this.setState({ searchedAnswers });
    }).catch(console.error);
  }

  selectAnswer(answer, e) {
    e.preventDefault();

    const {
      learning: {
        questionId,
        answerId,
      },
      onChangeLearning,
    } = this.props;

    onChangeLearning({
      questionId,
      answerId,
      answerBody: answer.body,
    });

    this.setState({ searchedAnswers: [] });
  }
}

ChatBotMessageEditor.propTypes = {
  body: PropTypes.string.isRequired,
  iconImageUrl: PropTypes.string.isRequired,
};

export default ChatBotMessageEditor;
