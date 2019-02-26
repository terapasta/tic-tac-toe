import React, { Component, PropTypes } from "react";

class ChatContainer extends Component {
  render() {
    const { children } = this.props;

    return (
      <div className="chat-container">
        {children}
      </div>
    );
  }
}

export default ChatContainer;
