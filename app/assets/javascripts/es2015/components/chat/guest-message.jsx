import React, { Component, PropTypes } from "react";

export default class GuestMessage extends Component {
  static get propTypes() {
    return {};
  }

  render() {
    const {
      iconImageUrl,
      body
    } = this.props;

    return (
      <div className="chat-message--my">
        <div className="chat-message__balloon">
          {body}
        </div>
        <div className="chat-message__icon">
          <img className="listen" src={iconImageUrl} />
        </div>
      </div>
    );
  }
}
