import React, { Component, PropTypes } from "react";
import values from "lodash/values";
import assign from "lodash/assign";

import ChatRow from "./row";
import ChatContainer from "./container";
import ChatBotMessage from "./bot-message";
import ChatBotMessageEditor from "./bot-message-editor";
import { Ratings } from "./constants";

function ChatBotMessageRow({
  section: { answer },
  isFirst,
  isActive,
  onChangeRatingTo,
}) {
  if (answer == null) { return null; }

  const _props = assign({ isFirst, onChangeRatingTo }, answer);

  return (
    <ChatRow>
      <ChatContainer>
        {!isActive && (
          <ChatBotMessage {..._props} />
        )}
        {isActive && (
          <ChatBotMessageEditor {..._props} />
        )}
      </ChatContainer>
    </ChatRow>
  );
}

ChatBotMessageRow.propTypes = {
  section: PropTypes.shape({
    answer: PropTypes.shape({
      body: PropTypes.string,
      rating: PropTypes.oneOf(values(Ratings)),
    }),
  }),
  isFirst: PropTypes.bool,
  isActive: PropTypes.bool,
  onChangeRatingTo: PropTypes.func.isRequired,
};

export default ChatBotMessageRow;
