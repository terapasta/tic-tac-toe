import React, { Component, PropTypes } from "react";
import classNames from "classnames";
import isEmpty from "is-empty";

function ChatSection(props) {
  const {
    children,
    isManager,
    isActive,
    onClick,
    section,
  } = props;

  const { decisionBranches, isDone } = section;
  if (!isEmpty(decisionBranches) && isDone) { console.log(section); return null; }

  const className = classNames({
    "chat-section": !isManager,
    "chat-section--bordered": isManager,
    "active": isActive,
  });
  const onClickWrapper = (e) => {
    e.preventDefault();
    onClick();
  };
  const tooltipText = isActive ?
    "キャンセルする場合はクリックしてください" :
    "回答が正しくない場合、クリックして別の回答を教えられます"

  return (
    <div className={className}>
      <div className="chat-section__switch-container">
        <a href="#"
          className="chat-section__switch"
          onClick={onClickWrapper}>
          <i className="material-icons">school</i>
          <div className="chat-section__tooltip">
            {tooltipText}
          </div>
        </a>
      </div>
      {children}
      {isActive && (
        <div className="chat-section__actions">
          <a className="btn btn-link btn-xs-sm" href="#">キャンセル</a>
          <a className="btn btn-primary btn-xs-sm" href="#">この内容で教える</a>
        </div>
      )}
    </div>
  );
}

ChatSection.propTypes = {
  isManager: PropTypes.bool.isRequired,
  isActive: PropTypes.bool.isRequired,
};

export default ChatSection;
