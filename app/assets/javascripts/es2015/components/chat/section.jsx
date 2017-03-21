import React, { Component, PropTypes } from "react";
import classNames from "classnames";

function ChatSection(props) {
  const {
    children,
    isManager,
    isActive,
    onClick,
  } = props;

  const className = classNames({
    "chat-section": !isManager,
    "chat-section--bordered": isManager,
    "active": isActive,
  });
  const onClickWrapper = (e) => {
    e.preventDefault();
    onClick();
  };

  return (
    <div className={className}>
      <div className="chat-section__switch-container">
        <a href="#"
          className="chat-section__switch"
          onClick={onClickWrapper}>
          <i className="material-icons">school</i>
        </a>
        <div className="chat-section__tooltip">この回答が正しくない場合は、別の回答を教えられます</div>
      </div>
      {children}
    </div>
  );
}

ChatSection.propTypes = {
  isManager: PropTypes.bool.isRequired,
  isActive: PropTypes.bool.isRequired,
};

export default ChatSection;
