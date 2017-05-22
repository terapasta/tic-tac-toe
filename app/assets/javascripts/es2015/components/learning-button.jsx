import React, { Component, PropTypes } from "react";
import classNames from "classnames";

import * as API from "../api/bot-learning";

const labelBoxStyle = {
  padding: "20px 0",
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

export default class LearningButton extends Component {
  static get componentName() {
    return "LearningButton";
  }

  static get propTypes() {
    return {
      botId: PropTypes.number.isRequired,
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
    if (process.env.NODE_ENV == "production") {
      setInterval(this.fetchLearningStatus.bind(this), 1000);
    }
  }

  render() {
    const { isDisabled, status } = this.state;
    const statusLabel = LearningStatus[status];
    const statusClassName = classNames("label", {
      "label-success": LearningStatus.isSucceeded(status),
      "label-danger": LearningStatus.isFailed(status),
      "label-warning": LearningStatus.isProcessing(status),
      "Animate-fadeInOut": LearningStatus.isProcessing(status),
    })

    return (
      <div id="bot-status-label">
        <div style={labelBoxStyle}>
          {status && (
            <label className={statusClassName}>{statusLabel}</label>
          )}
        </div>
        <button className="btn btn-danger btn-block btn-learning"
          disabled={isDisabled}
          onClick={this.onClickButton.bind(this)}>
          学習を実行する
        </button>
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
      .then(() => {})
      .catch(console.error);
  }

  onClickButton(e) {
    e.preventDefault();
    if (this.state.isDisabled) { return; }
    this.setState({ isDisabled: true });
    this.startLearning();
  }
}
