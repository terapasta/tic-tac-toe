import React, { Component, PropTypes } from "react";

import ChatRow from "./row";
import ChatContainer from "./container";
import ChatGuestMessage from "./guest-message";

function ChatGuestMessageRow({ section: { question } }) {
  if (question == null) { return null; }
  const { body } = question;

  return (
    <ChatRow>
      <ChatContainer>
        <ChatGuestMessage {...{ body }} />
      </ChatContainer>
    </ChatRow>
  );
}

ChatGuestMessageRow.propTypes = {
  question: PropTypes.shape({
    body: PropTypes.string,
  }),
};

export default ChatGuestMessageRow;
