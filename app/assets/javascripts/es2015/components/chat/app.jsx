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
      dispatch,
      token,
      messages,
      form,
    } = this.props;

    const {
      classifiedData
    } = messages;

    return (
      <div>
        <ChatHeader botName="サンプル" />
        <ChatArea ref="area">
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
        <ChatForm {...assign({
          onChange(e){
            dispatch(a.changeMessageBody({ messageBody: e.target.value }));
          },
          onSubmit(messageBody){
            dispatch(a.postMessage(token, messageBody));
          },
        }, form)} />
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
