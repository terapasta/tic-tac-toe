import React, { Component, PropTypes } from "react";
import isEmpty from "is-empty";

import ChatRow from "./row";
import ChatContainer from "./container";
import ChatDecisionBranches from "./decision-branches";

function ChatDecisionBranchesRow({
  section: { decisionBranches, isDone },
  onChoose,
}) {
  if (isEmpty(decisionBranches) || isDone) { return null; }

  return (
    <ChatRow>
      <ChatContainer>
        <ChatDecisionBranches
          title="回答を選択してください"
          items={decisionBranches}
          selectAttribute="id"
          onChoose={onChoose}
        />
      </ChatContainer>
    </ChatRow>
  );
}

ChatDecisionBranchesRow.propTypes = {
  decisionBranches: PropTypes.arrayOf(PropTypes.shape({
    id: PropTypes.number,
    body: PropTypes.string,
  })),
};

export default ChatDecisionBranchesRow;
