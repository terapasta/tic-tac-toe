import React, { Component, PropTypes } from "react";

class ChatArea extends Component {
  render() {
    const { children } = this.props;

    return (
      <div className="chat-area">
        {children}
      </div>
    );
  }
}

export default ChatArea;
