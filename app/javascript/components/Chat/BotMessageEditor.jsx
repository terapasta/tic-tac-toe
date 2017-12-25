import React, { Component } from 'react'
import PropTypes from 'prop-types'
import TextArea from 'react-textarea-autosize'
import isEmpty from 'is-empty'
import debounce from 'lodash/debounce'
import styled from 'styled-components'
import uuid from 'uuid/v4'

import PreventWheelScrollOfParent from '../PreventWheelScrollOfParent'
import * as QuestionAnswerAPI from '../../api/questionAnswer'

const SuggestItem = styled.div`
  cursor: pointer;
  padding: 8px;
  border-bottom: 1px solid #ccc;

  &:hover {
    background-color: #efefef;
  }

  &:last-child {
    border-bottom: 0;
  }
`

class ChatBotMessageEditor extends Component {
  constructor(props) {
    super(props)
    this._mounted = false
    this.state = {
      searchedAnswers: [],
    }

    this.searchAnswerIfNeeded = debounce(this.searchAnswerIfNeeded, 250)
  }

  componentDidMount() {
    this._mounted = true
  }

  componentWillUnmount() {
    this._mounted = false
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
    } = this.props

    const {
      searchedAnswers,
    } = this.state

    const iconStyle = {
      backgroundImage: `url(${iconImageUrl})`,
    }

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
                <div className="panel panel-default stacked-close" key={uuid()}>
                  <SuggestItem onClick={(e) => this.selectAnswer(a, e)}>
                    {a}
                  </SuggestItem>
                </div>
              ))}
            </PreventWheelScrollOfParent>
          )}
        </div>
      </div>
    )
  }

  searchAnswerIfNeeded(text) {
    if (isEmpty(text)) { return this.setState({ searchedAnswers: [] }) }
    QuestionAnswerAPI.findAll(window.currentBot.id, { q: text }).then((res) => {
      if (!this._mounted) { return }
      const searchedAnswers = res.data.questionAnswers.map(qa => qa.answer)
      this.setState({ searchedAnswers })
    }).catch(console.error)
  }

  selectAnswer(answer, e) {
    e.preventDefault()

    const {
      learning: {
        questionId,
        answerId,
      },
      onChangeLearning,
    } = this.props

    onChangeLearning({
      questionId,
      answerId,
      answerBody: answer,
    })

    this.setState({ searchedAnswers: [] })
  }
}

ChatBotMessageEditor.propTypes = {
  body: PropTypes.string.isRequired,
  iconImageUrl: PropTypes.string.isRequired,
}

export default ChatBotMessageEditor
