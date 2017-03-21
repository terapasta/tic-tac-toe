import React, { Component, PropTypes } from "react";

export default class ChatForm extends Component {
  static get propTypes() {
    return {
    };
  }

  render() {
    return (
      <div className="chat-form">
        <div className="container">
          <div className=".chat-container--no-padding">
            <div className="form">
              <input
                className="chat-form__text-field"
                type="text"
                placeholder="質問を入れてください"
              />
              <button className="chat-form__submit" id="chat-submit">
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
