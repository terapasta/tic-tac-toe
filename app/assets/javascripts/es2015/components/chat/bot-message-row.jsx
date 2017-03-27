import React, { Component, PropTypes } from "react";
import values from "lodash/values";
import assign from "lodash/assign";

import ChatRow from "./row";
import ChatContainer from "./container";
import ChatBotMessage from "./bot-message";
import { Ratings } from "./message-rating-buttons";

function ChatBotMessageRow({
  section: { answer },
  isFirst,
  onChangeRatingTo,
}) {
  if (answer == null) { return null; }

  const _props = assign({ isFirst, onChangeRatingTo }, answer);

  return (
    <ChatRow>
      <ChatContainer>
        <ChatBotMessage {..._props} />
      </ChatContainer>
    </ChatRow>
  );
}

ChatBotMessageRow.propTypes = {
  answer: PropTypes.shape({
    body: PropTypes.string,
    rating: PropTypes.oneOf(values(Ratings)),
    onChangeRatingTo: PropTypes.func.isRequired,
  }),
};

export default ChatBotMessageRow;
