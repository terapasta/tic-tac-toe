import React, { Component } from 'react'
import PropTypes from 'prop-types'
import values from 'lodash/values'

import LearningButton from '../LearningButton'
import { LearningStatus } from './Constants'
import * as LearningAPI from '../../api/botLearning'
import Modal from '../Modal'
import GuestUserForm from './GuestUserForm'
import queryParams from '../../helpers/queryParams'

const POLLING_INTERVAL = 1000 * 2

class ChatHeader extends Component {
  constructor(props) {
    super(props);
    this.state = {
      isLearning: false,
      learningStatus: null,
      isShowGuestUserForm: !props.isRegisteredGuestUser,
      isRegisteredGuestUser: props.isRegisteredGuestUser,
      isNoHeader: queryParams().noheader === 'true'
    }
    this.onClickLearning = this.onClickLearning.bind(this)
  }

  componentDidMount() {
    if (this.props.isManager) {
      this.pollLearningStatus()
    }
  }

  pollLearningStatus() {
    setTimeout(() => {
      LearningAPI.status(window.currentBot.id).then((res) => {
        this.setState({
          learningStatus: res.data.learning_status,
          isLearning: res.data.learning_status === LearningStatus.Processing,
        })
        this.pollLearningStatus()
      }).catch(console.error)
    }, POLLING_INTERVAL)
  }

  render() {
    const { botName, isAdmin, isManager } = this.props
    const { isNoHeader } = this.state

    if (isNoHeader) { return this.renderGuestUserParts() }

    return (
      <header className="chat-header">
        <h1 className="chat-header__title">{botName}</h1>
        {isManager && (
          <div className="chat-header__right">
            <LearningButton botId={window.currentBot.id} isAdmin={isAdmin} />
          </div>
        )}
        {this.renderGuestUserParts()}
      </header>
    )
  }

  renderGuestUserParts() {
    const { isManager, isEnableGuestUserRegistration } = this.props
    const { isNoHeader, isShowGuestUserForm, isRegisteredGuestUser } = this.state

    if (!isEnableGuestUserRegistration) { return null }

    return (
      <span>
        {!isManager && !isNoHeader && (
          <div className="chat-header__left">
            <a
              id="guest-user-modal-button"
              href="#"
              className="btn btn-link"
              title="ユーザー情報を編集できます"
              onClick={() => this.setState({ isShowGuestUserForm: true })}
            >
              <i className="material-icons">person</i>
            </a>
          </div>
        )}
        {(!isManager && isShowGuestUserForm) && (
          <Modal
            title="ユーザー情報"
            onClose={isRegisteredGuestUser ? () => { this.setState({ isShowGuestUserForm: false })} : null}
          >
            <GuestUserForm
              handleRegistered={() => {
                this.setState({
                  isShowGuestUserForm: false,
                  isRegisteredGuestUser: true
                });
              }}
            />
          </Modal>
        )}
      </span>
    )
  }

  onClickLearning() {
    if (this.state.isLearning) { return; }
    this.setState({
      isLearning: true,
      learningStatus: LearningStatus.Processing,
    })
    LearningAPI.start(window.currentBot.id).then((res) => {
      this.setState({
        learningStatus: res.data.learning_status,
      })
    }).catch((err) => {
      console.error(err);
      this.setState({
        isLearning: false,
        learningStatus: LearningStatus.Failed,
      })
    })
  }
}

ChatHeader.propTypes = {
  botName: PropTypes.string.isRequired,
  isAdmin: PropTypes.bool.isRequired,
  isManager: PropTypes.bool.isRequired,
  learningStatus: PropTypes.oneOf(values(LearningStatus)),
}

export default ChatHeader