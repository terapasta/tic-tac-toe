import React, { Component } from 'react'

import ChatRow from './Row'
import ChatContainer from './Container'

class ChatReadMore extends Component {
  render() {
    const { onClick, isAppered, isDisabled } = this.props;

    if (!isAppered) { return null }

    return (
      <div className="chat-section">
        <div className="chat-section__switch-container" />
        <ChatRow>
          <ChatContainer>
            <div style={{textAlign: "center"}}>
              <a href="#" className="btn btn-default" onClick={onClick} disabled={isDisabled}>
                もっと読み込む
              </a>
            </div>
          </ChatContainer>
        </ChatRow>
      </div>
    )
  }
}

ChatReadMore.propTypes = {}

export default ChatReadMore
