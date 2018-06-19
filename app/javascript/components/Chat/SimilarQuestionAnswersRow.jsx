import React, { Component } from 'react'
import PropTypes from 'prop-types'
import isEmpty from 'is-empty'

import ChatRow from './Row'
import ChatContainer from './Container'
import ChatDecisionBranches from './DecisionBranches'

class ChatSimilarQuestionAnswersRow extends Component {
  render() {
    const {
      section: { similarQuestionAnswers, isDone, hasInitialQuestions },
      onChoose,
      onInitialQuestionPositionChange,
      isManager
    } = this.props

    if (isEmpty(similarQuestionAnswers) || isDone) { return null }
    const items = similarQuestionAnswers.map((q) => ({
      id: q.id,
      body: q.question
    }))

    return (
      <ChatRow>
        <ChatContainer>
          <ChatDecisionBranches
            title="こちらの質問ではないですか？"
            items={items}
            selectAttribute="body"
            onChoose={onChoose}
            isSortable={!!hasInitialQuestions}
            onInitialQuestionPositionChange={onInitialQuestionPositionChange}
            isManager={isManager}
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
