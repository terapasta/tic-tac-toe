import React, { Component } from "react"
import PropTypes from 'prop-types'
import isEmpty from "is-empty"

import ChatRow from './Row'
import ChatContainer from './Container'
import ChatDecisionBranches from './DecisionBranches'

class ChatDecisionBranchesRow extends Component {
  render() {
    const {
      section: { decisionBranches, isDone },
      onChoose,
    } = this.props

    if (isEmpty(decisionBranches) || isDone) { return null }

    return (
      <ChatRow>
        <ChatContainer>
          <ChatDecisionBranches
            title="回答を選択してください"
            items={decisionBranches}
            selectAttribute="id"
            onChoose={onChoose}
          />
        </ChatContainer>
      </ChatRow>
    )
  }
}

ChatDecisionBranchesRow.propTypes = {
  decisionBranches: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.number,
    body: PropTypes.string,
  })),
}

export default ChatDecisionBranchesRow