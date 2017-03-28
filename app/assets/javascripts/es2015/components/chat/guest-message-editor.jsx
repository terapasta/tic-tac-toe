import React, { Component, PropTypes } from "react";
import TextArea from "react-textarea-autosize";

function ChatGuestMessageEditor(props) {
  // const {
  //   body
  // } = props;

  const iconStyle = {
    backgroundImage: `url(${window.Images["silhouette.png"]})`,
  };

  return (
    <div className="chat-message--my">
      <div className="chat-message__textarea">
        <div className="chat-message__part-label">質問</div>
        <TextArea
          className="form-control"
          rows={2}
        />
      </div>
      <div className="chat-message__icon" style={iconStyle} />
    </div>
  );
}

ChatGuestMessageEditor.propTypes = {
};

export default ChatGuestMessageEditor;
