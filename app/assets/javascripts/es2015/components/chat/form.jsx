import React, { Component, PropTypes } from "react";

export default class ChatForm extends Component {
  static get propTypes() {
    return {
      onChange: PropTypes.func.isRequired,
      onSubmit: PropTypes.func.isRequired,
      messageBody: PropTypes.string.isRequired,
    };
  }

  render() {
    const {
      onChange,
      onSubmit,
      messageBody
    } = this.props;

    return (
      <div className="chat-form">
        <div className="container">
          <div className=".chat-container--no-padding">
            <div className="form">
              <input
                className="chat-form__text-field"
                type="text"
                placeholder="質問を入れてください"
                value={messageBody}
                onChange={onChange}
              />
            <button className="chat-form__submit" id="chat-submit" onClick={() => { onSubmit(messageBody) }}>
                <span className="visible-sm visible-md visible-lg">質問</span>
                <span className="visible-xs">
                  <i className="fa fa-icon fa-paper-plane-o" />
                </span>
              </button>
            </div>
          </div>
        </div>
      </div>
    );
  }
}
