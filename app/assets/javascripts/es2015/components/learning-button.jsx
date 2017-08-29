import React, { Component, PropTypes } from "react";
import classNames from "classnames";

import Mixpanel, { makeEvent } from '../analytics/mixpanel';
import * as API from "../api/bot-learning";

const labelBoxStyle = {
  paddingBottom: "10",
  textAlign: "center",
  backgroundColor: "#fff",
  borderRight: "1px solid rgb(221, 221, 221)",
};

const LearningStatus = {
  processing: "学習中",
  failed: "学習失敗",
  successed: "学習済",
  isProcessing(status) {
    return status === "processing";
  },
  isFailed(status) {
    return status === "failed";
  },
  isSucceeded(status) {
    return status === "successed";
  },
};

const PollingInterval = 1000 * 10;

export default class LearningButton extends Component {
  static get componentName() {
    return "LearningButton";
  }

  static get propTypes() {
    return {
      botId: PropTypes.number.isRequired,
      isAdmin: PropTypes.bool.isRequired,
    };
  }

  constructor(props) {
    super(props);
    this.state = {
      isDisabled: false,
      status: null
    };
  }

  componentDidMount() {
    this.fetchLearningStatus();
    setInterval(this.fetchLearningStatus.bind(this), PollingInterval);
  }

  render() {
    const { isDisabled, status } = this.state;
    const { isAdmin } = this.props;
    const statusLabel = LearningStatus[status];
    const statusClassName = classNames("badge", {
      "badge-success": LearningStatus.isSucceeded(status) && isAdmin,
      "badge-danger": LearningStatus.isFailed(status),
      "badge-warning": LearningStatus.isProcessing(status),
      "Animate-fadeInOut": LearningStatus.isProcessing(status),
    });
    const icon = LearningStatus.isProcessing(status) ? 'cached' : 'trending_up';

    return (
      <div id="bot-status-label" className="d-inline-block">
        {status && (
          <label className={statusClassName}>{statusLabel}</label>
        )}
        &nbsp;
        {(isAdmin || LearningStatus.isFailed(status)) && (
          <button className="btn btn-outline-warning btn-sm"
            disabled={isDisabled}
            onClick={this.onClickButton.bind(this)}>
            <i className="material-icons mi-xs">{icon}</i>&nbsp;
            学習を実行
          </button>
        )}
      </div>
    )
  }

  fetchLearningStatus() {
    API.status(this.props.botId)
      .then((res) => {
        const { learning_status } = res.data;
        this.setState({ status: learning_status });
        if (!LearningStatus.isProcessing(learning_status)) {
          this.setState({ isDisabled: false });
        }
      })
      .catch(console.error);
  }

  startLearning() {
    API.start(this.props.botId)
      .then(() => this.setState({ status: "processing" }))
      .catch(console.error);
  }

  onClickButton(e) {
    e.preventDefault();
    if (this.state.isDisabled) { return; }
    this.setState({ isDisabled: true });
    this.startLearning();

    const { eventName, options } = makeEvent('learning');
    Mixpanel.sharedInstance.trackEvent(eventName, options);
  }
}
