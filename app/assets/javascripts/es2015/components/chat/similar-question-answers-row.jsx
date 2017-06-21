import React, { Component, PropTypes } from "react";
import isEmpty from "is-empty";

import ChatRow from "./row";
import ChatContainer from "./container";
import ChatDecisionBranches from "./decision-branches";

class ChatSimilarQuestionAnswersRow extends Component {
  render() {
    const {
      section: { similarQuestionAnswers, isDone },
      onChoose,
    } = this.props;

    if (isEmpty(similarQuestionAnswers) || isDone) { return null; }
    const items = similarQuestionAnswers.map((q) => ({
      body: q.question,
    }));

    return (
      <ChatRow>
        <ChatContainer>
          <ChatDecisionBranches
            title="こちらの質問ではないですか？"
            items={items}
            selectAttribute="body"
            onChoose={onChoose}
          />
        </ChatContainer>
      </ChatRow>
    );
  }
}

ChatSimilarQuestionAnswersRow.propTypes = {
  similarQuestionAnswers: PropTypes.arrayOf(PropTypes.shape({
    body: PropTypes.string,
  })),
};

export default ChatSimilarQuestionAnswersRow;
