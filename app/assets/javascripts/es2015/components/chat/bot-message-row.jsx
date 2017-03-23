import React, { Component, PropTypes } from "react";
import values from "lodash/values";

import ChatRow from "./row";
import ChatContainer from "./container";
import ChatBotMessage from "./bot-message";
import { Ratings } from "./message-rating-buttons";

function ChatBotMessageRow({ section: { answer }, isFirst }) {
  if (answer == null) { return null; }
  const { body, rating } = answer;

  return (
    <ChatRow>
      <ChatContainer>
        <ChatBotMessage {...{
          body,
          rating,
          isFirst,
        }} />
      </ChatContainer>
    </ChatRow>
  );
}

ChatBotMessageRow.propTypes = {
  answer: PropTypes.shape({
    body: PropTypes.string,
    rating: PropTypes.oneOf(values(Ratings)),
  }),
};

export default ChatBotMessageRow;
