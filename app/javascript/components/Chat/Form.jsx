import React, { Component } from 'react'
import PropTypes from 'prop-types'

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
    }
  }

  render() {
    const {
      onSubmit,
      messageBody,
      isDisabled,
    } = this.props

    return (
      <div className="chat-form">
        <div style={{ margin: '0 auto', padding: '0 15px', maxWidth: '970px' }}>
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
                <span className="d-sm-inline-block d-none">質問</span>
                <span className="d-inline-block d-sm-none">
                  <i className="material-icons">send</i>
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
