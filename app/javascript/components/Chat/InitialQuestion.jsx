import React, { Component } from 'react'
import PropTypes from 'prop-types'
import isEmpty from 'is-empty'
import get from 'lodash/get'

import ChatContainer from './Container'
import Modal from '../Modal'
import Mixpanel from '../../analytics/mixpanel'

export default class ChatInitialQuestion extends Component {
  static get propTypes() {
    return {
      isManager: PropTypes.bool,
      isFirst: PropTypes.bool,
      isLastPage: PropTypes.bool,
      initialQuestions: PropTypes.array.isRequired,
    }
  }

  constructor(props) {
    super(props);
    this.state = {
      isAppearDesc: false,
      isAppearSelector: false,
    }

    this.openDesc = this.openDesc.bind(this)
  }

  render() {
    const {
      isManager,
      isFirst,
      isLastPage,
    } = this.props

    return (
      <ChatContainer>
        {isManager && isFirst && isLastPage && (
          <div style={{marginTop:"32px"}}>
            {this.renderEmptyMessage()}
            {this.renderDesc()}
          </div>
        )}
      </ChatContainer>
    )
  }

  renderEmptyMessage() {
    const { initialQuestions } = this.props
    const isEmptyInitQs = isEmpty(initialQuestions)

    return (
      <span>
        {isEmptyInitQs && (
          <span>
            <p className="text-muted" style={{borderBottom:"1px solid #ccc", paddingBottom:"8px"}}>チャットボット管理者の方へ</p>
            <h4>チャットに初期質問リストを表示できます</h4>
          </span>
        )}
        <p>
          <a href={`/bots/${window.currentBot.id}/question_answers/selections`} target="_blank" className="btn btn-secondary">
            <i className="material-icons">playlist_add_check</i>
            {" "}
            <span>初期質問リストを選択する</span>
          </a>
        </p>
        <p>
          <a href="#" onClick={this.openDesc}>
            <i className="material-icons" style={{fontSize:"18px"}}>help</i>
            {" "}
            初期質問リストとは
          </a>
        </p>
      </span>
    )
  }

  renderDesc() {
    if (!this.state.isAppearDesc) { return null }
    const imageStyle = {
      border: "2px solid #ccc",
      width: "400px",
      height: "auto",
      display: "block",
      margin: "0 auto",
    }

    return (
      <Modal title="初期質問リストとは"
             onClose={() => this.setState({ isAppearDesc: false })}>
        <p>チャットを開始すぐの画面に、任意の質問候補を最大で５つまで表示できる機能です。</p>
        <p><img src={window.Images["initial-questions-sample.png"]} style={imageStyle}/></p>
        <p>時期によって質問内容が予想される場合等に設定しておくと効果的です。</p>
      </Modal>
    )
  }

  renderSelector() {
    if (!this.state.isAppearSelector) { return null }

    return (
      <Modal title="初期質問を選択"
        onClose={this.closeSelector}
        iframeUrl={this.iframePath}
        wide
      />
    )
  }

  openDesc() {
    this.setState({ isAppearDesc: true })
    Mixpanel.sharedInstance.trackEvent("description of first question", {
      bot_id: get(window, "currentBot.id"),
      bot_name: get(window, "currentBot.name"),
    })
  }
}
