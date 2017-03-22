import React, { Component, PropTypes } from "react";

import ChatHeader from "./header";
import ChatArea from "./area";
import ChatContainer from "./container";
import ChatForm from "./form";
import ChatRow from "./row";
import ChatSection from "./section";
import ChatDecisionBranches from "./decision-branches";
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
        <ChatArea>
          <ChatSection>
            <ChatRow>
              <ChatContainer>
                <BotMessage />
              </ChatContainer>
            </ChatRow>
            <ChatRow>
              <ChatContainer>
                <GuestMessage />
              </ChatContainer>
            </ChatRow>
          </ChatSection>
        </ChatArea>
        <ChatForm />
      </div>
    );
  }
}
