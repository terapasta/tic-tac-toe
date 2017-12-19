import React, { Component } from 'react'

class ChatRow extends Component {
  render() {
    const { children } = this.props

    return (
      <div className="chat-row">
        {children}
      </div>
    )
  }
}

export default ChatRow
