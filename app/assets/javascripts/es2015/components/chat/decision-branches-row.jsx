import React, { Component, PropTypes } from "react";
import isEmpty from "is-empty";

import ChatRow from "./row";
import ChatContainer from "./container";
import ChatDecisionBranches from "./decision-branches";

function ChatDecisionBranchesRow({ section: { decisionBranches } }) {
  if (isEmpty(decisionBranches)) { return null; }

  return (
    <ChatRow>
      <ChatContainer>
        <ChatDecisionBranches
          title="sample"
          items={decisionBranches}
          onSelect={() => {}}
        />
      </ChatContainer>
    </ChatRow>
  );
}

ChatDecisionBranchesRow.propTypes = {
  decisionBranches: PropTypes.arrayOf(PropTypes.shape({
    body: PropTypes.string,
  })),
};

export default ChatDecisionBranchesRow;
