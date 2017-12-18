import React, { Component, PropTypes } from 'react'
import toastr from 'toastr'
import isEmpty from 'is-empty'
import find from 'lodash/find'

import Popover from './popover'
import * as API from '../../api/chat-bad-reasons'

const PreparedReasons = [
  '質門に対して回答が噛み合っていない',
  '間違ってはいないが、知りたかった回答ではない',
  '回答内容がわかりづらい'
]
const OtherReason = '__other__'

class BadReasonForm extends Component {
  constructor (props) {
    super(props)
    this.state = {
      text: '',
      isSubmitting: false,
      isCompleted: false,
      isSelectedOther: false
    }
    this.handleSubmit = this.handleSubmit.bind(this)
    this.handleSelectReason = this.handleSelectReason.bind(this)
    this.reasons = {}
  }

  handleSelectReason (e) {
    const checkedReason = find(this.reasons, (input, reason) => input.checked)
    if (isEmpty(checkedReason)) { return }
    const { value } = checkedReason
    if (value === OtherReason) {
      return this.setState({ isSelectedOther: true })
    }
    this.setState({ text: value })
    this.submit(value)
  }

  handleSubmit (e) {
    e.stopPropagation()
    e.preventDefault()
    this.submit()
  }

  submit (forceText) {
    const { messageId } = this.props
    const { text } = this.state
    const resolvedText = forceText || text
    if (isEmpty(resolvedText)) { return }
    this.setState({ isSubmitting: true })
    const botToken = window.location.pathname.split('/')[2]

    API.create(botToken, messageId, resolvedText).then(res => {
      this.setState({ isSubmitting: false, isCompleted: true })
    }).catch(err => {
      console.error(err)
      toastr.error('送信に失敗しました。ご迷惑おかけして申し訳ありません。', 'エラー')
    })
  }

  render () {
    const { onCancel } = this.props
    const { text, isSubmitting, isCompleted, isSelectedOther } = this.state

    return (
      <Popover title="Bad評価の理由を教えていただけませんか？" fadeIn={true}>
        {isSelectedOther && (
          <textarea
            className="form-control"
            placeholder="例：見当違いの回答だった"
            value={text}
            onChange={e => this.setState({ text: e.target.value })}
            disabled={isSubmitting}
          />
        )}
        {!isSelectedOther && (
          <div onChange={this.handleSelectReason}>
            {PreparedReasons.map(r => (
              <label className="d-block" key={r}>
                <input type="radio" value={r} name="reason" ref={node => this.reasons[r] = node} />
                &nbsp;
                <span>{r}</span>
              </label>
            ))}
            <label className="d-block" key={OtherReason}>
              <input type="radio" value={OtherReason} name="reason" ref={node => this.reasons[OtherReason] = node} />
              &nbsp;
              <span>その他</span>
            </label>
          </div>
        )}
        <div className="text-right">
          {isSelectedOther && (
            <span>
              <button
                className="secondary"
                onClick={() => this.setState({ isSelectedOther: false })}
              >キャンセル</button>
              <button
                className="primary"
                onClick={this.handleSubmit}
                disabled={isSubmitting}
              >送信</button>
            </span>
          )}
          {!isSelectedOther && (
            <button
              className="secondary"
              onClick={onCancel}
              disabled={isSubmitting}
            >とじる</button>
          )}
        </div>
        {isSubmitting && (
          <div className="chat-popover__loading" />
        )}
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
}

BadReasonForm.propTypes = {
  messageId: PropTypes.number.isRequired,
  onCancel: PropTypes.func.isRequired
}

export default BadReasonForm