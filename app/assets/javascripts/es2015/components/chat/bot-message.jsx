import React, { Component, PropTypes } from "react";
import Loading from "react-loading";

import MessageRatingButtons from "./message-rating-buttons";

export default class ChatBotMessage extends Component {
  static get propTypes() {
    return {};
  }

  render() {
    const {
      isFirst,
      isLoading,
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
          {!isLoading && body}
          {isLoading && (
            <div className="chat-message__balloon-loader">
              <Loading type="spin" color="#e3e3e3" height={32} width={32} />
            </div>
          )}
        </div>
        <div className="chat-message__rating">
          {!isLoading && !isFirst && (
            <MessageRatingButtons {...{
              rating,
            }} />
          )}
        </div>
      </div>
    );
  }
}
