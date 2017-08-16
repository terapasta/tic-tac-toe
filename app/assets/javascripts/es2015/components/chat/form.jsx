import React, { Component, PropTypes } from "react";
import { findDOMNode } from "react-dom";
import isEmpty from "is-empty";

export default class ChatForm extends Component {
  static get propTypes() {
    return {
      onChange: PropTypes.func.isRequired,
      onSubmit: PropTypes.func.isRequired,
      messageBody: PropTypes.string.isRequired,
      isDisabled: PropTypes.bool.isRequired,
    };
  }

  constructor(props) {
    super(props);
    this.state = {
      isInputting: false,
    };
  }

  render() {
    const {
      onSubmit,
      messageBody,
      isDisabled,
    } = this.props;

    return (
      <div className="chat-form">
        <div className="container">
          <div className=".chat-container--no-padding">
            <form className="form" onSubmit={this.onSubmitForm.bind(this)}>
              <input
                ref="input"
                name="chat-message-body"
                className="chat-form__text-field"
                type="text"
                placeholder="質問を入れてください"
                value={messageBody}
                onChange={this.onChange.bind(this)}
                disabled={isDisabled}
              />
              <button
                className="chat-form__submit"
                id="chat-submit"
                disabled={isDisabled}
                onClick={() => onSubmit(messageBody)}>
                <span className="visible-sm visible-md visible-lg">質問</span>
                <span className="visible-xs">
                  <i className="fa fa-icon fa-paper-plane-o" />
                </span>
              </button>
            </form>
          </div>
        </div>
      </div>
    );
  }

  onChange(e) {
    this.setState({ isInputting: true });
    this.props.onChange(e);
  }

  onSubmitForm(e) {
    e.preventDefault();
    const { onSubmit, messageBody } = this.props;
    onSubmit(messageBody);
  }
}
