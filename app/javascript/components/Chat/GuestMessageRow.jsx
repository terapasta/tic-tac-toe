import React, { Component } from 'react'
import PropTypes from 'prop-types'
import find from 'lodash/find'
import get from 'lodash/get'

import ChatRow from './Row'
import ChatContainer from './Container'
import ChatGuestMessage from './GuestMessage'
import ChatGuestMessageEditor from './GuestMessageEditor'

class ChatGuestMessageRow extends Component {
  render() {
    const {
      section: { question, answer },
      isActive,
      learnings,
      onChangeLearning,
    } = this.props

    if (question == null) { return null }

    const learning = find(learnings, {
      questionId: get(question, "id"),
      answerId: get(answer, "id"),
    })

    return (
      <ChatRow>
        <ChatContainer>
          {!isActive && (
            <ChatGuestMessage {...question} />
          )}
          {isActive && (
            <ChatGuestMessageEditor {...{ learning, onChangeLearning }} />
          )}
        </ChatContainer>
      </ChatRow>
    )
  }
}

ChatGuestMessageRow.propTypes = {
  section: PropTypes.shape({
    question: PropTypes.shape({
      body: PropTypes.string,
    }),
  }),
  isActive: PropTypes.bool,
  learnings: PropTypes.arrayOf(PropTypes.shape({
    questionId: PropTypes.number.isRequired,
    answerId: PropTypes.number.isRequired,
    questionBody: PropTypes.string,
    answerBody: PropTypes.string,
  })),
  onChangeLearning: PropTypes.func.isRequired,
}

export default ChatGuestMessageRow
