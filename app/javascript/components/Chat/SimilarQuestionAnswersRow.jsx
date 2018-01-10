import React, { Component } from 'react'
import PropTypes from 'prop-types'
import isEmpty from 'is-empty'

import ChatRow from './Row'
import ChatContainer from './Container'
import ChatDecisionBranches from './DecisionBranches'

class ChatSimilarQuestionAnswersRow extends Component {
  render() {
    const {
      section: { similarQuestionAnswers, isDone },
      onChoose
    } = this.props

    if (isEmpty(similarQuestionAnswers) || isDone) { return null }
    const items = similarQuestionAnswers.map((q) => ({
      body: q.question,
    }))

    return (
      <ChatRow>
        <ChatContainer>
          <ChatDecisionBranches
            title="こちらの質問ではないですか？"
            items={items}
            selectAttribute="body"
            onChoose={onChoose}
          />
        </ChatContainer>
      </ChatRow>
    )
  }
}

ChatSimilarQuestionAnswersRow.propTypes = {
  similarQuestionAnswers: PropTypes.arrayOf(PropTypes.shape({
    body: PropTypes.string,
  }))
}

export default ChatSimilarQuestionAnswersRow
