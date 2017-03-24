import React, { Component, PropTypes } from "react";

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

export default class ChatApp extends Component {
  static get componentName() {
    return "ChatApp";
  }

  static get propTypes() {
    return {};
  }

  componentDidMount() {
    const { dispatch, token } = this.props;
    dispatch(a.fetchMessages(token));
  }

  componentDidUpdate(prevProps, prevState) {
    scrollToBottomIfNeeded(prevProps, this.props);
  }

  render() {
    const {
      messages
    } = this.props;

    const {
      classifiedData
    } = messages;

    return (
      <div>
        <ChatHeader botName="サンプル" />
        <ChatArea>
          {classifiedData.map((section, i) => {
            const isFirst = i === 0;
            return (
              <ChatSection {...{ isManager: false, isActive: false, key: i }}>
                <ChatGuestMessageRow {...{
                  section,
                }} />
                <ChatBotMessageRow {...{
                  section,
                  isFirst,
                }} />
                <ChatDecisionBranchesRow {...{
                  section,
                }} />
              </ChatSection>
            );
          })}
        </ChatArea>
        <ChatForm />
      </div>
    );
  }
}

function scrollToBottomIfNeeded(prevProps, props) {
  const prevCount = prevProps.messages.classifiedData.length
  const currentCount = props.messages.classifiedData.length;
  if (currentCount > prevCount) {
    window.scrollTo(0, document.body.scrollHeight);
  }
}
