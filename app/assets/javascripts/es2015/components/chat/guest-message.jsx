import React, { Component, PropTypes } from "react";

export default class ChatGuestMessage extends Component {
  static get propTypes() {
    return {};
  }

  render() {
    const {
      iconImageUrl,
      body,
    } = this.props;

    const iconStyle = {
      backgroundImage: `url(${iconImageUrl})`,
    };

    return (
      <div className="chat-message--my">
        <div className="chat-message__balloon">
          {body}
        </div>
        <div className="chat-message__icon" style={iconStyle} />
      </div>
    );
  }
}
