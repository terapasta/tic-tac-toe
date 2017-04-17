import React, { Component, PropTypes } from "react";
import assign from "lodash/assign";

import * as a from "./action-creators";

import ChatHeader from "./header";
import ChatArea from "./area";
import ChatContainer from "./container";
import ChatForm from "./form";
import ChatRow from "./row";
import ChatSection from "./section";
import ChatDecisionBranchesRow from "./decision-branches-row";
import ChatBotMessageRow from "./bot-message-row";
import ChatGuestMessageRow from "./guest-message-row";
import ChatGuestMessage from "./guest-message";
import ChatReadMore from "./read-more";

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
    dispatch(a.pollLearningStatus(window.currentBot.id));
  }

  componentDidUpdate(prevProps, prevState) {
    scrollToBottomIfNeeded(prevProps, this.props);
  }

  render() {
    const {
      dispatch,
      token,
      messages,
      form,
      learning,
      learnings,
      isManager,
      readMore,
    } = this.props;

    const {
      classifiedData
    } = messages;

    return (
      <div>
        <ChatHeader {...{
          botName: window.currentBot.name,
          learningStatus: learning.status,
          isManager,
          onClickStartLearning() { dispatch(a.startLearning(window.currentBot.id)) },
        }} />
        <ChatArea>
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
                  isFirst,
                  isActive,
                  learnings,
                  onChangeRatingTo(type, messageId) {
                    dispatch(a.changeMessageRatingTo(type, token, messageId));
                  },
                  onChangeLearning(payload) {
                    dispatch(a.updateLearning(payload));
                  },
                }} />
                <ChatDecisionBranchesRow {...{
                  section,
                  onChoose(decisionBranchId) {
                    dispatch(a.chooseDecisionBranch(token, decisionBranchId));
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

function scrollToBottomIfNeeded(prevProps, props) {
  const prevCount = prevProps.messages.classifiedData.length
  const currentCount = props.messages.classifiedData.length;
  if (currentCount > prevCount && (prevCount === 0 || props.messages.isNeedScroll)) {
    window.scrollTo(0, document.body.scrollHeight);
  }
}