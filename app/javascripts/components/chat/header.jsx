import React, { Component, PropTypes } from "react";
import values from "lodash/values";

import LearningButton from '../learning-button';
import { LearningStatus } from "./constants";
import * as LearningAPI from "../../api/bot-learning";
import Modal from '../modal';
import GuestUserForm from './guest-user-form';

const POLLING_INTERVAL = 1000 * 2;

class ChatHeader extends Component {
  constructor(props) {
    super(props);
    this.state = {
      isLearning: false,
      learningStatus: null,
      isShowGuestUserForm: !props.isRegisteredGuestUser,
      isRegisteredGuestUser: props.isRegisteredGuestUser,
    };
    this.onClickLearning = this.onClickLearning.bind(this);
  }

  componentDidMount() {
    if (this.props.isManager) {
      this.pollLearningStatus();
    }
  }

  pollLearningStatus() {
    setTimeout(() => {
      LearningAPI.status(window.currentBot.id).then((res) => {
        this.setState({
          learningStatus: res.data.learning_status,
          isLearning: res.data.learning_status === LearningStatus.Processing,
        });
        this.pollLearningStatus();
      }).catch(console.error);
    }, POLLING_INTERVAL);
  }

  render() {
    const { botName, isAdmin, isManager } = this.props;
    const { isShowGuestUserForm, isRegisteredGuestUser } = this.state;

    return (
      <header className="chat-header">
        <h1 className="chat-header__title">{botName}</h1>
        {isManager && (
          <div className="chat-header__right">
            <LearningButton botId={window.currentBot.id} isAdmin={isAdmin} />
          </div>
        )}
        {!isManager && (
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
      </header>
    );
  }

  onClickLearning() {
    if (this.state.isLearning) { return; }
    this.setState({
      isLearning: true,
      learningStatus: LearningStatus.Processing,
    });
    LearningAPI.start(window.currentBot.id).then((res) => {
      this.setState({
        learningStatus: res.data.learning_status,
      });
    }).catch((err) => {
      console.error(err);
      this.setState({
        isLearning: false,
        learningStatus: LearningStatus.Failed,
      });
    });
  }
}

ChatHeader.propTypes = {
  botName: PropTypes.string.isRequired,
  isAdmin: PropTypes.bool.isRequired,
  isManager: PropTypes.bool.isRequired,
  learningStatus: PropTypes.oneOf(values(LearningStatus)),
};

export default ChatHeader;
/*
          <div className="chat-header__right">
            {isSucceeded && <span className="label label-success">学習済</span>}
            {isFailed && <span className="label label-danger">学習失敗</span>}
            {isProcessing && <span className="label label-warning">学習中</span>}
            {" "}
            <button className="chat-header__button btn btn-default"
              disabled={isLearning}
              onClick={this.onClickLearning}>
              <i className="material-icons">trending_up</i>
              {" "}
              <span>{isLearning ? "学習中..." : "学習を実行"}</span>
            </button>
          </div>
*/
