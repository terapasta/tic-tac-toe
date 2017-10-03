import React, { Component, PropTypes } from "react";
import values from "lodash/values";
import assign from "lodash/assign";
import find from "lodash/find";
import get from "lodash/get";

import ChatRow from "./row";
import ChatContainer from "./container";
import ChatBotMessage from "./bot-message";
import ChatBotMessageEditor from "./bot-message-editor";
import ChatInitialQuestion from "./initial-question";
import { Ratings } from "./constants";

export default class ChatBotMessageRow extends Component {
  static get propTypes() {
    return {
      section: PropTypes.shape({
        answer: PropTypes.shape({
          body: PropTypes.string,
          rating: PropTypes.oneOf(values(Ratings)),
        }),
      }),
      isManager: PropTypes.bool,
      isFirst: PropTypes.bool,
      isActive: PropTypes.bool,
      learnings: PropTypes.arrayOf(PropTypes.shape({
        questionId: PropTypes.number.isRequired,
        answerId: PropTypes.number.isRequired,
        questionBody: PropTypes.string,
        answerBody: PropTypes.string,
      })),
      initialQuestions: PropTypes.array.isRequired,
      onChangeRatingTo: PropTypes.func.isRequired,
      onChangeLearning: PropTypes.func.isRequired,
      onChangeInitialQuestions: PropTypes.func.isRequired,
    };
  }

  render() {
    const {
      section: { question, answer },
      isManager,
      isFirst,
      isActive,
      learnings,
      initialQuestions,
      onChangeRatingTo,
      onChangeLearning,
      onChangeInitialQuestions,
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
        <ChatInitialQuestion
          isManager={isManager}
          isFirst={isFirst}
          initialQuestions={initialQuestions}
          onChange={onChangeInitialQuestions}
        />
      </ChatRow>
    );
  }
}