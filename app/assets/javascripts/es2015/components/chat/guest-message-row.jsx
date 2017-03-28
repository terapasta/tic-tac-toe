import React, { Component, PropTypes } from "react";

import ChatRow from "./row";
import ChatContainer from "./container";
import ChatGuestMessage from "./guest-message";
import ChatGuestMessageEditor from "./guest-message-editor";

function ChatGuestMessageRow({
  section: { question },
  isActive,
}) {
  if (question == null) { return null; }

  return (
    <ChatRow>
      <ChatContainer>
        {!isActive && (
          <ChatGuestMessage {...question} />
        )}
        {isActive && (
          <ChatGuestMessageEditor {...question} />
        )}
      </ChatContainer>
    </ChatRow>
  );
}

ChatGuestMessageRow.propTypes = {
  section: PropTypes.shape({
    question: PropTypes.shape({
      body: PropTypes.string,
    }),
  }),
  isActive: PropTypes.bool,
};

export default ChatGuestMessageRow;
