import React, { Component, PropTypes } from "react";
import { findDOMNode } from "react-dom";
import classNames from "classnames";
import values from "lodash/values";

import { directMountComponent, getMountNodes } from "../../modules/mount-component";
import * as API from "../../api/chat-message-rating";

const FaIcons = {
  Good: "fa fa-thumbs-up",
  Bad:  "fa fa-thumbs-down",
};

const Ratings = {
  Nothing: "nothing",
  Good: "good",
  Bad: "bad",
};

export default class MessageRatingButtons extends Component {
  static get componentName() {
    return "MessageRatingButtons";
  }

  static get propTypes() {
    return {
      rating: PropTypes.oneOf(values(Ratings)).isRequired,
    };
  }

  static mountComponentAll() {
    const mountNodes = getMountNodes(this).filter((node) => {
      return node.getAttribute("data-mounted") == null;
    });
    mountNodes.forEach((mountNode) => {
      directMountComponent(this, mountNode);
    });
  }

  constructor(props) {
    super(props);
    const { rating } = props;
    this.state = {
      rating,
      isProcessing: false,
    };
  }

  componentDidMount() {
    const root = findDOMNode(this.refs.root);
    root.parentNode.setAttribute("data-mounted", true);
  }

  render() {
    const { rating } = this.state;
    const goodClassName = classNames("chat-message__rating-button good", {
      active: rating === Ratings.Good,
    });
    const badClassName = classNames("chat-message__rating-button bad", {
      active: rating === Ratings.Bad,
    });

    return (
      <span>
        <div className="chat-message__rating-title">この返答を評価してください</div>
        <a href="#" className={goodClassName}
          ref="root" onClick={this.onClick.bind(this, Ratings.Good)}>
          <i className={FaIcons.Good} />
        </a>
        {" "}
        <a href="#" className={badClassName}
          ref="root" onClick={this.onClick.bind(this, Ratings.Bad)}>
          <i className={FaIcons.Bad} />
        </a>
      </span>
    );
  }

  onClick(newRating, e) {
    e.preventDefault();
    const { token, messageId } = this.props;
    const { rating, isProcessing } = this.state;
    const succeedHandler = () => { this.setState({ isProcessing: false }); };
    const failedHandler = (err) => {
      console.error(err);
      this.setState({ rating, isProcessing: false });
    };

    if (isProcessing) { return; }
    this.setState({ isProcessing: true });

    if (newRating === rating) {
      this.setState({ rating: Ratings.Nothing });
      API.nothing(token, messageId)
        .then(succeedHandler)
        .catch(failedHandler);
      return;
    }

    this.setState({ rating: newRating });
    API[newRating](token, messageId)
      .then(succeedHandler)
      .catch(failedHandler);
  }
}
