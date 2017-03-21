import React, { Component, PropTypes } from "react";

import ChatHeader from "./header";
import ChatArea from "./area";
import ChatContainer from "./container";
import ChatForm from "./form";
import ChatRow from "./row";
import BotMessage from "./bot-message";
import GuestMessage from "./guest-message";

export default class ChatApp extends Component {
  static get componentName() {
    return "ChatApp";
  }

  static get propTypes() {
    return {};
  }

  render() {
    return (
      <div>
        <ChatHeader botName="サンプル" />
        <ChatContainer>
          <ChatRow>
            <BotMessage />
          </ChatRow>
          <ChatRow>
            <GuestMessage />
          </ChatRow>
        </ChatContainer>
        <ChatForm />
      </div>
    );
  }
}
