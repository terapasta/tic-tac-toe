import React, { Component, PropTypes } from "react";

import MessageRatingButtons from "./message-rating-buttons";

export default class ChatBotMessage extends Component {
  static get propTypes() {
    return {};
  }

  render() {
    const {
      iconImageUrl,
      body,
    } = this.props;

    return (
      <div className="chat-message">
        <div className="chat-message__icon">
          <img className="listen" src={iconImageUrl} />
        </div>
        <div className="chat-message__balloon">
          {body}
        </div>
        <div className="chat-message__rating">
          <div className="chat-message__rating-title">この返答を評価してください</div>
          <MessageRatingButtons />
        </div>
      </div>
    );
  }
}
