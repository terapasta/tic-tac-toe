import React, { Component, PropTypes } from "react";
import find from "lodash/find";
import get from "lodash/get";
import classNames from "classnames";
import isEmpty from "is-empty";

export default class ChatSection extends Component {
  static get propTypes() {
    return {
      isManager: PropTypes.bool.isRequired,
      isFirst: PropTypes.bool.isRequired,
      isActive: PropTypes.bool,
      isDisabled: PropTypes.bool,
      section: PropTypes.object.isRequired,
      index: PropTypes.number.isRequired,
      onClick: PropTypes.func.isRequired,
      onSaveLearning: PropTypes.func.isRequired,
    };
  }

  get learning() {
    const { learnings } = this.props;
    const { questionId, answerId } = this;
    return find(learnings, { questionId, answerId }) || {};
  }

  get questionId() {
    return get(this.props, "section.question.id");
  }

  get answerId() {
    return get(this.props, "section.answer.id");
  }

  render() {
    const {
      children,
      isManager,
      isFirst,
      isActive,
      isDisabled,
      onClick,
      section,
      index,
      onSaveLearning,
    } = this.props;

    const { decisionBranches, isDone, question, answer } = section;
    const isDecisionBranch = !isEmpty(decisionBranches);
    if (isDecisionBranch && isDone) { return null; }

    const className = classNames({
      "chat-section": !isManager,
      "chat-section--bordered": isManager,
      "active": isActive,
    });

    return (
      <div className={className}>
        <div className="chat-section__switch-container">
          {!isFirst && !isDecisionBranch && (
            <a href="#"
              className="chat-section__switch"
              onClick={this.onClick.bind(this)}
              disabled={get(this.learning, "isDisabled")}>
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
              onClick={this.onClick.bind(this)}
              disabled={this.learning.isDisabled}>キャンセル</a>
            <a className="btn btn-primary btn-xs-sm"
              href="#"
              onClick={this.onSaveLearning.bind(this)}
              disabled={this.learning.isDisabled}>この内容で教える</a>
          </div>
        )}
        {isDisabled && (
          <div className="chat-section__disable-cover" />
        )}
      </div>
    );
  }

  onClick(e) {
    e.preventDefault();
    const { onClick, index } = this.props;
    if (get(this.learning, "isDisabled")) { return; }
    onClick(index);
  }

  onSaveLearning(e) {
    e.preventDefault();
    const { onSaveLearning } = this.props;
    const { questionId, answerId } = this;
    if (get(this.learning, "isDisabled")) { return; }
    this.props.onSaveLearning({
      questionId,
      answerId,
    });
  }
}
