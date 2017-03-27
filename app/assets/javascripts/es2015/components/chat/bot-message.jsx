import React, { Component, PropTypes } from "react";
import Loading from "react-loading";
import values from "lodash/values";
import * as c from "./constants";

import MessageRatingButtons from "./message-rating-buttons";

export default class ChatBotMessage extends Component {
  static get propTypes() {
    return {
      isFirst: PropTypes.bool.isRequired,
      isLoading: PropTypes.bool,
      iconImageUrl: PropTypes.string,
      id: PropTypes.number.isRequired,
      body: PropTypes.string.isRequired,
      rating: PropTypes.oneOf(values(c.Ratings)),
      onChangeRatingTo: PropTypes.func.isRequired,
    };
  }

  render() {
    const {
      isFirst,
      isLoading,
      iconImageUrl,
      id,
      rating,
      body,
      onChangeRatingTo,
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
              messageId: id,
              rating,
              onChangeRatingTo,
            }} />
          )}
        </div>
      </div>
    );
  }
}
