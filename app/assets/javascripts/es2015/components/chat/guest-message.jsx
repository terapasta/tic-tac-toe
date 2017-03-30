import React, { Component, PropTypes } from "react";
import Loading from "react-loading";
import classNames from "classnames";

export default class ChatGuestMessage extends Component {
  static get propTypes() {
    return {};
  }

  constructor(props) {
    super(props);
    this.state = {
      isFaded: true,
    };
  }

  componentDidMount() {
    setTimeout(() => { this.setState({ isFaded: false })}, 0);
  }

  render() {
    const {
      isLoading,
      iconImageUrl,
      body,
    } = this.props;

    const { isFaded } = this.state;
    const className = classNames("chat-message--my", { "faded": isFaded });
    const iconStyle = {
      backgroundImage: `url(${window.Images["silhouette.png"]})`,
    };

    return (
      <div className={className}>
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
