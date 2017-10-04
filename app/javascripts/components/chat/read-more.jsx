import React, { Component, PropTypes } from "react";
import classNames from "classnames";
import ChatRow from "./row";
import ChatContainer from "./container";

class ChatReadMore extends Component {
  render() {
    const { onClick, isManager, isAppered, isDisabled } = this.props;

    if (!isAppered) { return null; }

    const className = classNames({
      "chat-section": !isManager,
      "chat-section--bordered": isManager,
    });

    return (
      <div className="chat-section">
        <div className="chat-section__switch-container" />
        <ChatRow>
          <ChatContainer>
            <div style={{textAlign: "center"}}>
              <a href="#" className="btn btn-default" onClick={onClick} disabled={isDisabled}>
                もっと読み込む
              </a>
            </div>
          </ChatContainer>
        </ChatRow>
      </div>
    );
  }
}

ChatReadMore.propTypes = {};

export default ChatReadMore;
