import React, { Component, PropTypes } from "react";
import find from "lodash/find";
import get from "lodash/get";
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
    learnings,
    index,
    onSaveLearning,
  } = props;

  const { decisionBranches, isDone, question, answer } = section;
  const questionId = get(question, "id");
  const answerId = get(answer, "id");
  const learning = find(learnings, { questionId, answerId });
  const isDecisionBranch = !isEmpty(decisionBranches);
  if (isDecisionBranch && isDone) { return null; }

  const className = classNames({
    "chat-section": !isManager,
    "chat-section--bordered": isManager,
    "active": isActive,
  });

  const onClickWrapper = (e) => {
    e.preventDefault();
    if (get(learning, "isDisabled")) { return; }
    onClick(index);
  };

  const onSaveLearningWrapper = (e) => {
    e.preventDefault();
    if (learning.isDisabled) { return; }
    onSaveLearning({
      questionId,
      answerId,
    });
  };

  return (
    <div className={className}>
      <div className="chat-section__switch-container">
        {!isFirst && !isDecisionBranch && (
          <a href="#"
            className="chat-section__switch"
            onClick={onClickWrapper}
            disabled={get(learning, "isDisabled")}>
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
          <a className="btn btn-link btn-xs-sm"
            href="#"
            onClick={onClickWrapper}
            disabled={learning.isDisabled}>キャンセル</a>
          <a className="btn btn-primary btn-xs-sm"
            href="#"
            onClick={onSaveLearningWrapper}
            disabled={learning.isDisabled}>この内容で教える</a>
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
  onSaveLearning: PropTypes.func.isRequired,
};

export default ChatSection;
