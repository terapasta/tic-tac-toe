import React, { Component, PropTypes } from "react";
import Loading from "react-loading";

export default class ChatGuestMessage extends Component {
  static get propTypes() {
    return {};
  }

  render() {
    const {
      isLoading,
      iconImageUrl,
      body,
    } = this.props;

    const iconStyle = {
      backgroundImage: `url(${window.Images["silhouette.png"]})`,
    };

    return (
      <div className="chat-message--my">
        <div className="chat-message__balloon">
          {!isLoading && body}
          {isLoading && (
            <div className="chat-message__balloon-loader">
              <Loading type="spin" color="#e3e3e3" height={32} width={32} />
            </div>
          )}
        </div>
        <div className="chat-message__icon" style={iconStyle} />
      </div>
    );
  }
}
