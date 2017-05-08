import React from "react";
import nl2br from "react-nl2br";
import isEmpty from "is-empty";

import ChatRow from "./row";
import ChatContainer from "./container";

export default function ChatFlashMessage(props) {
  const { flashMessage } = props;

  if (isEmpty(flashMessage)) { return null; }

  return (
    <div className="chat-section">
      <ChatRow>
        <ChatContainer>
          <p className="alert alert-warning">{nl2br(flashMessage)}</p>
        </ChatContainer>
      </ChatRow>
    </div>
  );
}
