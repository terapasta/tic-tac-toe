import React, { Component, PropTypes } from "react";
import { findDOMNode } from "react-dom";
import assign from "lodash/assign";
import sortBy from "lodash/sortBy";
import isEqual from "lodash/isEqual"
import includes from "lodash/includes"
import isEmpty from "is-empty";

import getOffset from "../../modules/get-offset";
import * as a from "./action-creators";
import * as c from "./constants";

import ChatHeader from "./header";
import ChatArea from "./area";
import ChatContainer from "./container";
import ChatForm from "./form";
import ChatRow from "./row";
import ChatSection from "./section";
import ChatDecisionBranchesRow from "./decision-branches-row";
import ChatSimilarQuestionAnswersRow from "./similar-question-answers-row";
import ChatBotMessageRow from "./bot-message-row";
import ChatGuestMessageRow from "./guest-message-row";
import ChatGuestMessage from "./guest-message";
import ChatReadMore from "./read-more";
import ChatFlashMessage from "./flash-message";

let isFetchedInitialQuestions = false;

export default class ChatApp extends Component {
  static get componentName() {
    return "ChatApp";
  }

  static get propTypes() {
    return {};
  }

  componentDidMount() {
    a.trackMixpanel("Open new chat");
    const { dispatch, token } = this.props;
    dispatch(a.fetchMessages(token));
  }

  componentDidUpdate(prevProps, prevState) {
    scrollToLastSectionIfNeeded(prevProps, this);
    this.fetchInitialQuestionsIfNeeded();
    this.setInitialQuestionsToMessagesIfNeeded(prevProps);
  }

  fetchInitialQuestionsIfNeeded() {
    if (isFetchedInitialQuestions) { return; }
    isFetchedInitialQuestions = true;
    const { dispatch, messages, initialQuestions, isManager } = this.props;
    if (!isEmpty(messages.classifiedData) && isEmpty(initialQuestions) && isManager) {
      dispatch(a.fetchInitialQuestions(window.currentBot.id));
    }
  }

  setInitialQuestionsToMessagesIfNeeded(prevProps) {
    const { dispatch, messages } = this.props;
    const prevInitialQuestions = sortBy(prevProps.initialQuestions, (q) => q.id);
    const initialQuestions = sortBy(this.props.initialQuestions, (q) => q.id);
    const isUpdated = (
      prevInitialQuestions.length !== initialQuestions.length ||
      includes(prevInitialQuestions.map((q, i) => isEqual(q, initialQuestions[i])), false)
    );

    if (isUpdated) {
      dispatch(a.setInitialQuestionsToMessages(this.props.initialQuestions));
    }
  }

  render() {
    const {
      dispatch,
      token,
      useSimilarityClassification,
      showPath,
      messages,
      form,
      learning,
      learnings,
      isManager,
      readMore,
      flashMessage,
      initialQuestions,
    } = this.props;

    const {
      classifiedData
    } = messages;

    return (
      <div ref="root">
        <ChatHeader {...{
          botName: window.currentBot.name,
          learningStatus: learning.status,
          enableLearningButton: isManager && useSimilarityClassification !== true,
          showPath,
          onClickStartLearning() { dispatch(a.startLearning(window.currentBot.id)) },
        }} />
        <ChatArea>
          <ChatFlashMessage flashMessage={flashMessage} />
          <ChatReadMore {...assign({
            isManager,
            onClick(e) {
              e.preventDefault();
              dispatch(a.fetchNextMessages());
            },
          }, readMore)} />
          {classifiedData.map((section, i) => {
            const isFirst = i === 0;
            const { isActive, isDisabled } = section;
            return (
              <ChatSection {...{
                  isManager,
                  isFirst,
                  isActive,
                  isDisabled,
                  key: i,
                  index: i,
                  section,
                  learnings,
                  onClick(index) {
                    dispatch(a.toggleActiveSection(index));
                  },
                  onSaveLearning(payload) {
                    dispatch(a.saveLearning(payload));
                  }
                }}>
                <ChatGuestMessageRow {...{
                  section,
                  isActive,
                  learnings,
                  onChangeLearning(payload) {
                    dispatch(a.updateLearning(payload));
                  },
                }} />
                <ChatBotMessageRow {...{
                  section,
                  isManager,
                  isFirst,
                  isActive,
                  learnings,
                  initialQuestions,
                  onChangeRatingTo(type, messageId) {
                    dispatch(a.changeMessageRatingTo(type, token, messageId));
                  },
                  onChangeLearning(payload) {
                    dispatch(a.updateLearning(payload));
                  },
                  onChangeInitialQuestions() {
                    dispatch(a.fetchInitialQuestions(window.currentBot.id));
                  },
                }} />
                <ChatDecisionBranchesRow {...{
                  section,
                  onChoose(decisionBranchId) {
                    dispatch(a.chooseDecisionBranch(token, decisionBranchId));
                  }
                }} />
                <ChatSimilarQuestionAnswersRow {...{
                  section,
                  onChoose(question) {
                    dispatch(a.postMessageIfNeeded(token, question, { isForce: true }));
                  }
                }} />
              </ChatSection>
            );
          })}
        </ChatArea>
        <ChatForm {...assign({
          onChange(e){
            dispatch(a.changeMessageBody({ messageBody: e.target.value }));
          },
          onSubmit(messageBody){
            dispatch(a.postMessageIfNeeded(token, messageBody));
          },
        }, form)} />
      </div>
    );
  }
}

function scrollToLastSectionIfNeeded(prevProps, component) {
  const { props, refs } = component;
  const prevCount = prevProps.messages.classifiedData.length
  const currentCount = props.messages.classifiedData.length;
  if (currentCount > prevCount &&
     (prevCount === 0 || props.messages.isNeedScroll)) {

    const rootNode = findDOMNode(refs.root);
    const areaNode = rootNode.querySelector(".chat-area");
    const children = [].slice.call(areaNode.children);
    const targetNode = children.reverse().filter((n) => (
      n.querySelector(".chat-decision-branches") == null
    ))[0];
    if (targetNode == null) { return; }
    const offset = getOffset(targetNode);

    window.scrollTo(0, offset.top - c.HeaderHeight);
  }
}
