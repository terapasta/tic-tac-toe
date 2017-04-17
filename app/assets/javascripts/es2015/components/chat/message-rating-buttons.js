import React, { Component, PropTypes } from "react";
import { findDOMNode } from "react-dom";
import classNames from "classnames";
import values from "lodash/values";

import * as c from "./constants";

const ButtonClasses = {
  Good: "chat-message__rating-button good",
  Bad: "chat-message__rating-button bad",
};
const FaIcons = {
  Good: "fa fa-thumbs-up",
  Bad:  "fa fa-thumbs-down",
};

export default class MessageRatingButtons extends Component {
  static get propTypes() {
    return {
      messageId: PropTypes.number.isRequired,
      rating: PropTypes.oneOf(values(c.Ratings)).isRequired,
      onChangeRatingTo: PropTypes.func.isRequired,
    };
  }

  render() {
    const { rating } = this.props;
    const goodClassName = classNames(ButtonClasses.Good, {
      active: rating === c.Ratings.Good,
    });
    const badClassName = classNames(ButtonClasses.Bad, {
      active: rating === c.Ratings.Bad,
    });

    return (
      <span>
        <div className="chat-message__rating-title">この返答を評価してください</div>
        <a href="#" className={goodClassName}
          ref="root" onClick={this.onClick.bind(this, c.Ratings.Good)}>
          <i className={FaIcons.Good} />
        </a>
        {" "}
        <a href="#" className={badClassName}
          ref="root" onClick={this.onClick.bind(this, c.Ratings.Bad)}>
          <i className={FaIcons.Bad} />
        </a>
      </span>
    );
  }

  onClick(newRating, e) {
    e.preventDefault();
    const { messageId, rating, onChangeRatingTo } = this.props;

    if (newRating === rating) {
      onChangeRatingTo(c.Ratings.Nothing, messageId);
    } else {
      onChangeRatingTo(newRating, messageId);
    }
  }
}
