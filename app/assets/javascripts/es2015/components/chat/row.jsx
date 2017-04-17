import React, { Component, PropTypes } from "react";

function ChatRow(props) {
  const { children } = props;

  return (
    <div className="chat-row">
      {children}
    </div>
  );
}

export default ChatRow;
