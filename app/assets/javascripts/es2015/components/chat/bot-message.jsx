import React, { Component, PropTypes } from "react";

import MessageRatingButtons from "./message-rating-buttons";

export default class ChatBotMessage extends Component {
  static get propTypes() {
    return {};
  }

  render() {
    const {
      isFirst,
      iconImageUrl,
      rating,
      body,
    } = this.props;

    const iconStyle = {
      backgroundImage: `url(${iconImageUrl})`,
    };

    return (
      <div className="chat-message">
        <div className="chat-message__icon" style={iconStyle} />
        <div className="chat-message__balloon">
          {body}
        </div>
        <div className="chat-message__rating">
          {!isFirst && (
            <MessageRatingButtons {...{
              rating,
            }} />
          )}
        </div>
      </div>
    );
  }
}
