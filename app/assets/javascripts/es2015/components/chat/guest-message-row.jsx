import React, { Component, PropTypes } from "react";
import find from "lodash/find";

import ChatRow from "./row";
import ChatContainer from "./container";
import ChatGuestMessage from "./guest-message";
import ChatGuestMessageEditor from "./guest-message-editor";

function ChatGuestMessageRow({
  section: { question, answer },
  isActive,
  learnings,
  onChangeLearning,
}) {
  if (question == null) { return null; }

  const learning = find(learnings, {
    questionId: question.id,
    answerId: answer.id,
  });

  return (
    <ChatRow>
      <ChatContainer>
        {!isActive && (
          <ChatGuestMessage {...question} />
        )}
        {isActive && (
          <ChatGuestMessageEditor {...{ learning, onChangeLearning }} />
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
  learnings: PropTypes.arrayOf(PropTypes.shape({
    questionId: PropTypes.number.isRequired,
    answerId: PropTypes.number.isRequired,
    questionBody: PropTypes.string,
    answerBody: PropTypes.string,
  })),
  onChangeLearning: PropTypes.func.isRequired,
};

export default ChatGuestMessageRow;
