import React, { Component } from 'react'
import Loading from 'react-loading'
import Linkify from 'react-linkify'
import nl2br from 'react-nl2br'
import classNames from 'classnames'

export default class ChatGuestMessage extends Component {
  static get propTypes() {
    return {}
  }

  constructor(props) {
    super(props);
    this.state = {
      isFaded: true,
    }
  }

  componentDidMount() {
    setTimeout(() => { this.setState({ isFaded: false })}, 0)
  }

  render() {
    const {
      isLoading,
      body,
    } = this.props

    const { isFaded } = this.state;
    const className = classNames("chat-message--my", { "faded": isFaded })

    return (
      <div className={className}>
        <div className="chat-message__balloon">
          {!isLoading && <Linkify properties={{ target: "_blank" }}>{nl2br(body)}</Linkify>}
          {isLoading && (
            <div className="chat-message__balloon-loader">
              <Loading type="spin" color="#e3e3e3" height={32} width={32} />
            </div>
          )}
        </div>
      </div>
    )
  }
}
