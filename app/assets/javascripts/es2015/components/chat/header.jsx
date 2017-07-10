import React, { Component, PropTypes } from "react";
import values from "lodash/values";

import { LearningStatus } from "./constants";
import * as LearningAPI from "../../api/bot-learning";
import Tooltip from "../tooltip";

const POLLING_INTERVAL = 1000 * 2;

class ChatHeader extends Component {
  constructor(props) {
    super(props);
    this.state = {
      isLearning: false,
      learningStatus: null,
    };
    this.onClickLearning = this.onClickLearning.bind(this);
  }

  componentDidMount() {
    if (this.props.enableLearningButton) {
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
    const { botName, isManager, enableLearningButton, showPath } = this.props;
    const { isLearning, learningStatus } = this.state;

    const isSucceeded = learningStatus === LearningStatus.Succeeded;
    const isFailed = learningStatus === LearningStatus.Failed;
    const isProcessing = learningStatus === LearningStatus.Processing;

    return (
      <header className="chat-header">
        <h1 className="chat-header__title">{botName}</h1>
        <div className="chat-header__right">
          {enableLearningButton && (
            <span>
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
            </span>
          )}
          {isManager && (
            <span>
              <a href={showPath} className="chat-header__button btn btn-default">
                <i className="material-icons">refresh</i>
                再読込
              </a>
              <Tooltip content="Q&A、同義語の登録・更新の際は再読込が必要です" placement="left"/>
            </span>
          )}
        </div>
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
  isManager: PropTypes.bool.isRequired,
  enableLearningButton: PropTypes.bool.isRequired,
  learningStatus: PropTypes.oneOf(values(LearningStatus)),
  showPath: PropTypes.string.isRequired,
};

export default ChatHeader;
