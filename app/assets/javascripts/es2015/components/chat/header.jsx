import React, { Component, PropTypes } from "react";

function ChatHeader(props) {
  const { botName } = props;

  return (
    <header className="chat-header">
      <h1 className="chat-header__title">{botName}</h1>
    </header>
  );
}

ChatHeader.propTypes = {
  botName: PropTypes.string.isRequired,
};

export default ChatHeader;
