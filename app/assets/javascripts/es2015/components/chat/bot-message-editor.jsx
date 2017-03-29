import React, { Component, PropTypes } from "react";
import TextArea from "react-textarea-autosize";
import classNames from "classnames";

function ChatBotMessageEditor({
  body,
  iconImageUrl,
  learning: { questionId, answerId, answerBody },
  onChangeLearning,
}) {

  const iconStyle = {
    backgroundImage: `url(${iconImageUrl})`,
  };

  return (
    <div className="chat-message">
      <div className="chat-message__icon" style={iconStyle} />
      <div className="chat-message__balloon has-part-label" disabled={true}>
        <div className="chat-message__part-label">
          <a href="#">回答</a>
        </div>
        {body}
      </div>
      <div className="chat-message__textarea has-part-label">
        <div className="chat-message__part-label">新しい回答</div>
        <TextArea
          className="form-control"
          rows={1}
          value={answerBody}
          onChange={(e) => {
            onChangeLearning({
              questionId,
              answerId,
              answerBody: e.target.value,
            });
          }}
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
