import React, { Component, PropTypes } from "react";

function ChatContainer(props) {
  const { children } = props;

  return (
    <div className="chat-container chat-area">
      {children}
    </div>
  );
}

export default ChatContainer;
