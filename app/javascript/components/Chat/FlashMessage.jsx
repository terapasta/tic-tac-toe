import React, { Component } from 'react'
import nl2br from 'react-nl2br'
import isEmpty from 'is-empty'

import ChatRow from './Row'
import ChatContainer from './Container'

export default class ChatFlashMessage extends Component {
  render() {
    const { flashMessage } = this.props

    if (isEmpty(flashMessage)) { return null }

    return (
      <div className="chat-section">
        <ChatRow>
          <ChatContainer>
            <p className="alert alert-warning">{nl2br(flashMessage)}</p>
          </ChatContainer>
        </ChatRow>
      </div>
    )
  }
}
