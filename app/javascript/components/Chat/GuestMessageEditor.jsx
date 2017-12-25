import React, { Component } from 'react'
import TextArea from 'react-textarea-autosize'

class ChatGuestMessageEditor extends Component {
  render() {
    const {
      learning: {
        questionId,
        answerId,
        questionBody,
        isDisabled,
      },
      onChangeLearning,
    } = this.props

    const iconStyle = {
      backgroundImage: `url(${window.Images["silhouette.png"]})`,
    }

    return (
      <div className="chat-message--my">
        <div className="chat-message__textarea">
          <div className="chat-message__part-label">質問</div>
          <TextArea
            className="form-control"
            name="chat-guest-message-body"
            rows={1}
            value={questionBody}
            onChange={(e) => {
              onChangeLearning({
                questionId,
                answerId,
                questionBody: e.target.value,
              });
            }}
            disabled={isDisabled}
          />
        </div>
        <div className="chat-message__icon" style={iconStyle} />
      </div>
    )
  }
}

ChatGuestMessageEditor.propTypes = {
}

export default ChatGuestMessageEditor
