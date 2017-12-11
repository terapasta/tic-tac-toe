import React, { Component, PropTypes } from "react";
import { findDOMNode } from "react-dom";
import find from "lodash/find";
import get from "lodash/get";
import isArray from "lodash/isArray";
import classNames from "classnames";
import isEmpty from "is-empty";
import getOffset from "../../modules/get-offset";
import queryParams from "../../modules/query-params";

const HeaderHeight = 47;

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
      onSaveLearning: PropTypes.func.isRequired
    };
  }

  constructor(props) {
    super(props)
    this.state = {
      isNoHeader: queryParams().noheader === 'true'
    }
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

  componentDidUpdate(prevProps) {
    this.scrollToRootIfChangedToActive(prevProps);
  }

  scrollToRootIfChangedToActive(prevProps) {
    const { scrollableElement } = this.props;
    const isChangedToActive = !prevProps.isActive && this.props.isActive;
    const isChangedToShowingUpSQA = !prevProps.section.isShowSimilarQuestionAnswers && this.props.section.isShowSimilarQuestionAnswers;

    if (isChangedToActive || isChangedToShowingUpSQA) {
      const { top } = getOffset(this.root);
      const scrollTargetY = top - HeaderHeight + scrollableElement.scrollTop;
      if (typeof scrollableElement.scrollTo === 'function') {
        scrollableElement.scrollTo(0, scrollTargetY);
      } else {
        scrollableElement.scrollTop = scrollTargetY;
      }
    }
  }

  render() {
    const {
      children,
      isManager,
      isFirst,
      isActive,
      isDisabled,
      section,
    } = this.props;

    const {
      decisionBranches,
      similarQuestionAnswers,
      isShowSimilarQuestionAnswers,
      isDone,
    } = section;
    const isDecisionBranch = !isEmpty(decisionBranches);
    const isSQA = isArray(similarQuestionAnswers);
    if ((isDecisionBranch || isSQA) && isDone) { return null; }
    if (isSQA && isEmpty(similarQuestionAnswers)) { return null; }

    const className = classNames({
      "chat-section": !isManager,
      "chat-section--bordered": isManager,
      "active": isActive,
      "collapsed": !isShowSimilarQuestionAnswers && !isFirst
    });

    let innerStyle = {}
    if (isFirst && this.state.isNoHeader) {
      innerStyle.paddingTop = '0px'
    }

    return (
      <div
        className={className}
        ref={node => this.root = node}
        data-decision-branch={isDecisionBranch || isSQA}
      >
        <div className="chat-section__inner" style={innerStyle}>
          <div className="chat-section__switch-container">
            {!isFirst && !isDecisionBranch && !isSQA && (
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
