import React, { Component, PropTypes } from "react";
import classNames from "classnames";
import isEmpty from "is-empty";

function ChatSection(props) {
  const {
    children,
    isManager,
    isFirst,
    isActive,
    isDisabled,
    onClick,
    section,
    index,
  } = props;

  const { decisionBranches, isDone } = section;
  const isDecisionBranch = !isEmpty(decisionBranches);
  if (isDecisionBranch && isDone) { console.log(section); return null; }

  const className = classNames({
    "chat-section": !isManager,
    "chat-section--bordered": isManager,
    "active": isActive,
  });
  const onClickWrapper = (e) => {
    e.preventDefault();
    onClick(index);
  };

  return (
    <div className={className}>
      <div className="chat-section__switch-container">
        {!isFirst && !isDecisionBranch && (
          <a href="#"
            className="chat-section__switch"
            onClick={onClickWrapper}>
            <i className="material-icons">school</i>
            {!isActive && (
              <div className="chat-section__tooltip">
                回答が正しくない場合、クリックして別の回答を教えられます
              </div>
            )}
          </a>
        )}
      </div>
      {children}
      {isActive && (
        <div className="chat-section__actions">
          <a className="btn btn-link btn-xs-sm" href="#" onClick={onClickWrapper}>キャンセル</a>
          <a className="btn btn-primary btn-xs-sm" href="#">この内容で教える</a>
        </div>
      )}
      {isDisabled && (
        <div className="chat-section__disable-cover" />
      )}
    </div>
  );
}

ChatSection.propTypes = {
  isManager: PropTypes.bool.isRequired,
  isFirst: PropTypes.bool.isRequired,
  isActive: PropTypes.bool,
  isDisabled: PropTypes.bool,
  section: PropTypes.object.isRequired,
};

export default ChatSection;
