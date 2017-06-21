import React, { Component, PropTypes } from "react";
import values from "lodash/values";
import assign from "lodash/assign";
import find from "lodash/find";
import get from "lodash/get";

import ChatRow from "./row";
import ChatContainer from "./container";
import ChatBotMessage from "./bot-message";
import ChatBotMessageEditor from "./bot-message-editor";
import { Ratings } from "./constants";

class ChatBotMessageRow extends Component {
  render() {
    const {
      section: { question, answer },
      isFirst,
      isActive,
      learnings,
      onChangeRatingTo,
      onChangeLearning,
    } = this.props;

    if (answer == null) { return null; }

    const learning = find(learnings, {
      questionId: get(question, "id"),
      answerId: get(answer, "id"),
    });
    const _props = assign({ isFirst, onChangeRatingTo }, answer);

    return (
      <ChatRow>
        <ChatContainer>
          {!isActive && (
            <ChatBotMessage {..._props} />
          )}
          {isActive && (
            <ChatBotMessageEditor {...assign({
              learning,
              onChangeLearning
            }, _props)} />
          )}
        </ChatContainer>
      </ChatRow>
    );
  }
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
  learnings: PropTypes.arrayOf(PropTypes.shape({
    questionId: PropTypes.number.isRequired,
    answerId: PropTypes.number.isRequired,
    questionBody: PropTypes.string,
    answerBody: PropTypes.string,
  })),
  onChangeRatingTo: PropTypes.func.isRequired,
  onChangeLearning: PropTypes.func.isRequired,
};

export default ChatBotMessageRow;
