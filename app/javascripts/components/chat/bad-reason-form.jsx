import React, { Component, PropTypes } from 'react'
import isEmpty from 'is-empty'

import Popover from './popover'

class BadReasonForm extends Component {
  constructor (props) {
    super(props)
    this.state = {
      text: '',
      isSubmitting: false,
      isCompleted: false
    }
    this.handleSubmit = this.handleSubmit.bind(this)
  }

  render () {
    const { onCancel } = this.props
    const { text, isSubmitting, isCompleted } = this.state

    return (
      <Popover title="Bad評価の理由を教えていただけませんか？" fadeIn={true}>
        <textarea
          className="form-control"
          placeholder="例：見当違いの回答だった"
          value={text}
          onChange={e => this.setState({ text: e.target.value })}
          disabled={isSubmitting}
        />
        <div className="text-right">
          <button
            className="secondary"
            onClick={onCancel}
            disabled={isSubmitting}
          >とじる</button>
          <button
            className="primary"
            onClick={this.handleSubmit}
            disabled={isSubmitting}
          >送信</button>
        </div>
        {isCompleted && (
          <div className="chat-popover__cover-message">
            <div className="inner">
              <div className="title">
                ありがとうございます。<br />送信完了しました。
              </div>
              <a href="#" onClick={onCancel}>閉じる</a>
            </div>
          </div>
        )}
      </Popover>
    )
  }

  handleSubmit (e) {
    e.stopPropagation()
    e.preventDefault()
    const { text } = this.state
    if (isEmpty(text)) { return }
    this.setState({ isSubmitting: true })
    console.log(text)
  }
}

BadReasonForm.propTypes = {
  messageId: PropTypes.number.isRequired,
  onCancel: PropTypes.func.isRequired
}

export default BadReasonForm