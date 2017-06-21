import React, { Component, PropTypes } from "react";
import values from "lodash/values";

import { LearningStatus } from "./constants";

class ChatHeader extends Component {
  render() {
    const { botName, isManager, learningStatus, onClickStartLearning } = this.props;

    const isSucceeded = learningStatus === LearningStatus.Succeeded;
    const isFailed = learningStatus === LearningStatus.Failed;
    const isProcessing = learningStatus === LearningStatus.Processing;

    return (
      <header className="chat-header">
        <h1 className="chat-header__title">{botName}</h1>
        {isManager && (
          <div className="chat-header__right">
            {isSucceeded && <span className="label label-success">学習済</span>}
            {isFailed && <span className="label label-danger">学習失敗</span>}
            {isProcessing && <span className="label label-warning">学習中</span>}
            {" "}
            <button className="chat-header__button btn btn-default"
              disabled={isProcessing}
              onClick={onClickStartLearning}>
              <i className="material-icons">trending_up</i>
              {" "}
              <span>{isProcessing ? "学習中..." : "学習を実行"}</span>
            </button>
          </div>
        )}
      </header>
    );
  }
}

ChatHeader.propTypes = {
  botName: PropTypes.string.isRequired,
  isManager: PropTypes.bool.isRequired,
  learningStatus: PropTypes.oneOf(values(LearningStatus)),
  onClickStartLearning: PropTypes.func.isRequired,
};

export default ChatHeader;
