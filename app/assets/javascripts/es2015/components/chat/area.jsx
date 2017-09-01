import React, { Component, PropTypes } from "react";

class ChatArea extends Component {
  render() {
    const { children, innerRef } = this.props;

    return (
      <div className="chat-area" ref={innerRef}>
        {children}
      </div>
    );
  }
}

export default ChatArea;
