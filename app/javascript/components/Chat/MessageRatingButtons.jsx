import React, { Component } from 'react'
import PropTypes from 'prop-types'
import classNames from 'classnames'
import values from 'lodash/values'
import isEmpty from 'is-empty'

import * as c from './Constants'
import BadReasonForm from './BadReasonForm'

const ButtonClasses = {
  Good: 'chat-message__rating-button good',
  Bad: 'chat-message__rating-button bad',
}

export default class MessageRatingButtons extends Component {
  static get propTypes() {
    return {
      messageId: PropTypes.number.isRequired,
      rating: PropTypes.oneOf(values(c.Ratings)).isRequired,
      onChangeRatingTo: PropTypes.func.isRequired
    }
  }

  constructor (props) {
    super(props)
    this.state = {
      isAnimatingLeft: false,
      isAnimatingRight: false,
      isShowBadReasonForm: false
    }
    this.handleCancelBadReason = this.handleCancelBadReason.bind(this)
  }

  render() {
    const { rating, messageId } = this.props;
    const goodClassName = classNames(ButtonClasses.Good, {
      active: rating === c.Ratings.Good,
    });
    const badClassName = classNames(ButtonClasses.Bad, {
      active: rating === c.Ratings.Bad,
    });
    const {
      isAnimatingLeft,
      isAnimatingRight,
      isShowBadReasonForm
    } = this.state

    return (
      <span>
        <div className="chat-message__rating-title">この返答を評価してください</div>
        <a href="#" className={goodClassName}
          ref="root" onClick={this.onClick.bind(this, c.Ratings.Good)}>
          <i className={classNames('material-icons', { scaleUp: isAnimatingLeft })}>thumb_up</i>
        </a>
        {" "}
        <a
          href="#"
          className={badClassName}
          ref={node => this.badButton = node}
          onClick={this.onClick.bind(this, c.Ratings.Bad)}
        >
          <i className={classNames('material-icons', { scaleUp: isAnimatingRight })}>thumb_down</i>
          {!isEmpty(this.badButton) && isShowBadReasonForm && (
            <BadReasonForm
              messageId={messageId}
              onCancel={this.handleCancelBadReason}
            />
          )}
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
      this.setState({
        isAnimatingLeft: false,
        isAnimatingRight: false,
      })
      if (newRating !== rating && newRating === c.Ratings.Bad) {
        this.setState({ isShowBadReasonForm: true })
      }
    }, 500)

    if (newRating === rating) {
      onChangeRatingTo(c.Ratings.Nothing, messageId);
    } else {
      onChangeRatingTo(newRating, messageId);
    }
  }

  handleCancelBadReason () {
    this.setState({ isShowBadReasonForm: false })
  }
}
