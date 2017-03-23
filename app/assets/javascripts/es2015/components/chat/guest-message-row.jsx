import React, { Component, PropTypes } from "react";

import ChatRow from "./row";
import ChatContainer from "./container";
import ChatGuestMessage from "./guest-message";

function ChatGuestMessageRow({ section: { question } }) {
  if (question == null) { return null; }

  return (
    <ChatRow>
      <ChatContainer>
        <ChatGuestMessage {...question} />
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
