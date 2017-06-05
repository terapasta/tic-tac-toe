import React, { Component, PropTypes } from "react";
import TextArea from "react-textarea-autosize";
import classNames from "classnames";

function ChatBotMessageEditor({
  body,
  iconImageUrl,
  learning: {
    questionId,
    answerId,
    answerBody,
    isDisabled,
  },
  onChangeLearning,
}) {

  const iconStyle = {
    backgroundImage: `url(${iconImageUrl})`,
  };

  return (
    <div className="chat-message">
      <div className="chat-message__icon" style={iconStyle} />
      <div className="chat-message__balloon has-part-label" disabled={true}>
        {body}
      </div>
      <div className="chat-message__textarea has-part-label">
        <div className="chat-message__part-label">新しい回答</div>
        <TextArea
          className="form-control"
          name="chat-bot-message-body"
          rows={1}
          value={answerBody}
          onChange={(e) => {
            onChangeLearning({
              questionId,
              answerId,
              answerBody: e.target.value,
            });
          }}
          disabled={isDisabled}
        />
      </div>
    </div>
  );
}

ChatBotMessageEditor.propTypes = {
  body: PropTypes.string.isRequired,
  iconImageUrl: PropTypes.string.isRequired,
};

export default ChatBotMessageEditor;
