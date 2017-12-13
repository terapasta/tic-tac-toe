import React, { Component, PropTypes } from "react";
import classNames from "classnames";
import values from "lodash/values";

import * as c from "./constants";

const ButtonClasses = {
  Good: "chat-message__rating-button good",
  Bad: "chat-message__rating-button bad",
};

export default class MessageRatingButtons extends Component {
  static get propTypes() {
    return {
      messageId: PropTypes.number.isRequired,
      rating: PropTypes.oneOf(values(c.Ratings)).isRequired,
      onChangeRatingTo: PropTypes.func.isRequired,
    };
  }

  constructor (props) {
    super(props)
    this.state = {
      isAnimatingLeft: false,
      isAnimatingRight: false
    }
  }

  render() {
    const { rating } = this.props;
    const goodClassName = classNames(ButtonClasses.Good, {
      active: rating === c.Ratings.Good,
    });
    const badClassName = classNames(ButtonClasses.Bad, {
      active: rating === c.Ratings.Bad,
    });
    const { isAnimatingLeft, isAnimatingRight } = this.state

    return (
      <span>
        <div className="chat-message__rating-title">この返答を評価してください</div>
        <a href="#" className={goodClassName}
          ref="root" onClick={this.onClick.bind(this, c.Ratings.Good)}>
          <i className={classNames('material-icons', { scaleUp: isAnimatingLeft })}>thumb_up</i>
        </a>
        {" "}
        <a href="#" className={badClassName}
          ref="root" onClick={this.onClick.bind(this, c.Ratings.Bad)}>
          <i className={classNames('material-icons', { scaleUp: isAnimatingRight })}>thumb_down</i>
        </a>
      </span>
    );
  }

  onClick(newRating, e) {
    e.preventDefault();
    const { messageId, rating, onChangeRatingTo } = this.props;

    switch (newRating) {
      case c.Ratings.Good:
        this.setState({ isAnimatingLeft: true })
        break
      case c.Ratings.Bad:
        this.setState({ isAnimatingRight: true })
        break
      default: break
    }
    setTimeout(() => {
      this.setState({ isAnimatingLeft: false, isAnimatingRight: false })
    }, 1000)

    if (newRating === rating) {
      onChangeRatingTo(c.Ratings.Nothing, messageId);
    } else {
      onChangeRatingTo(newRating, messageId);
    }
  }
}
