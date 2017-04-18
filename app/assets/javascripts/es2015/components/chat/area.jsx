import React, { Component, PropTypes } from "react";

function ChatArea(props) {
  const { children } = props;

  return (
    <div className="chat-area">
      {children}
    </div>
  );
}

export default ChatArea;
