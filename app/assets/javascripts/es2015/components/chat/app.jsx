import React, { Component, PropTypes } from "react";

import ChatHeader from "./header";

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
      </div>
    );
  }
}
